import Foundation
import SourceryRuntime

class MockMethod {
    fileprivate let type: SourceryRuntime.`Type`
    let method: SourceryRuntime.Method
    fileprivate let genericTypePrefix: String
    fileprivate let useShortName: Bool

    init(type: SourceryRuntime.`Type`, method: SourceryRuntime.Method, genericTypePrefix: String, useShortName: Bool) {
        self.type = type
        self.method = method
        self.genericTypePrefix = genericTypePrefix
        self.useShortName = useShortName
    }

    static func from(_ type: Type, genericTypePrefix: String) throws -> [MockMethod] {
        let allMethods = type.allMethods.filter { !$0.isStatic && $0.definedInType != nil && $0.definedInType?.isExtension == false }.uniquesWithoutGenericConstraints()
        let mockedMethods = allMethods
            .map { MockMethod(type: type, method: $0, genericTypePrefix: genericTypePrefix, useShortName: true) }
            .minimumNonConflictingPermutation
        guard !mockedMethods.hasDuplicateMockedMethodNames else {
            throw MockError.internalError(message: "Mock generator: not all duplicates resolved: \(mockedMethods.map { $0.mockedMethodName })!")
        }
        return mockedMethods.sorted { $0.mockedMethodName < $1.mockedMethodName }
    }
}

extension MockMethod {
    var isVoid: Bool {
        return method.returnTypeName.isVoid
    }

    var isGeneric: Bool {
        return method.isGeneric
    }

    var genericTypes: [GenericTypeInfo] {
        return method.annotatedGenericTypes()
    }
}

extension MockMethod {
    fileprivate var annotatedMethodName: String? {
        return method.annotations(for: ["methodName"]).first
    }

    fileprivate var mockedMethodName: String {
        if let annotatedMethodName = annotatedMethodName {
            return annotatedMethodName
        }
        var result: [String] = [method.callName]
        if !useShortName {
            result += method.parameters.map {
                let argumentLabel = $0.argumentLabel == nil ? "" : $0.argumentLabel != $0.name ? $0.argumentLabel!.uppercasedFirstLetter() : ""
                return "\(argumentLabel)\($0.name.uppercasedFirstLetter())"
            }
        }
        return result.joined().swiftifiedMethodName
    }

    func mockImpl() throws -> [SourceCode] {
        var mockMethodHandlers = TopScope()

        let mockCallCount = mockCallCountImpl
        mockMethodHandlers += mockCallCount.1

        var mockHandler = mockHandlerImpl
        mockMethodHandlers += mockHandler.1

        // func declaration
        var methodImpl = SourceCode("func \(method.shortName)(\(method.methodParametersDecl))\(method.throwingDecl)\(method.returnTypeDecl)")

        // Increment usage call count.
        methodImpl += "\(mockCallCount.0) += 1"

        // Call the handler.
        methodImpl += mockHandlerCallImpl

        // Fallback return value.
        if isVoid {
            // No return value
        } else if method.isOptionalReturnType {
            // Return nil
            methodImpl += "return nil"
        } else {
            // Do something smart
            if method.returnTypeName.hasComplexTypeWithSmartDefaultValue(isProperty: false) {
                let smartDefaultValueImplementation = try method.returnTypeName.smartDefaultValueImplementation(
                    isProperty: false,
                    mockVariablePrefix: mockedMethodName,
                    forceCastingToReturnTypeName: isGeneric)

                methodImpl += smartDefaultValueImplementation.0
                mockMethodHandlers += smartDefaultValueImplementation.1
            } else if method.returnTypeName.hasDefaultValue, let defaultValue = try? method.returnTypeName.defaultValue() {
                methodImpl += SourceCode("return \(defaultValue)")
            } else {
                // fatal
                methodImpl += "fatalError(\"\(mockHandler.0) expected to be set.\")"
            }
        }

        var result = TopScope()
        result += methodImpl
        result += mockMethodHandlers.nested
        return result.nested
    }

    private var mockedVarCallCountName: String {
        return "\(mockedMethodName)CallCount"
    }

    private var mockCallCountImpl: (String, SourceCode) {
        return (mockedVarCallCountName, SourceCode("var \(mockedVarCallCountName): Int = 0"))
    }

    private var mockMethodHandlerName: String {
        return "\(mockedMethodName)Handler"
    }

    private var mockMethodHandlerReturnType: String {
        return !isVoid ? method.returnTypeName.name.trimmingWhereClause() : ""
    }

    private var mockHandlerImpl: (String, SourceCode) {
        let handlerParameters = method.parameters.map { "_ \($0.name): \($0.typeName.name)" }.joined(separator: ", ")
        return (mockMethodHandlerName, SourceCode("var \(mockMethodHandlerName): ((\(handlerParameters))\(method.throwingHandlerDecl) -> (\(mockMethodHandlerReturnType)))? = nil"))
    }

    private var mockHandlerCallImpl: SourceCode {
        let returning = isVoid ? "" : "return "
        let parameters = method.parameters
            .map {
                let autoclosureInvoking = $0.typeAttributes["autoclosure"] != nil ? "()" : ""
                if isGeneric, let extractedAnnotatedGenericTypesPlaceholder = $0.annotations(for: ["annotatedGenericType", "annotatedGenericTypes", "genericTypePlaceholder", "genericTypesPlaceholder"]).first {
                    let forceCastingToGenericParameterType = " as! \(extractedAnnotatedGenericTypesPlaceholder.resolvingGenericPlaceholders(prefix: genericTypePrefix))"
                    return "\($0.name)\(autoclosureInvoking)\(forceCastingToGenericParameterType)"
                }
                return "\($0.name)\(autoclosureInvoking)"
            }
            .joined(separator: ", ")
        let forceCastingToGenericReturnValue = isGeneric && !isVoid ? " as! \(mockMethodHandlerReturnType)" : ""
        let invocationThrowing = method.`throws` ? "try " : method.`rethrows` ? "try! " : ""
        let handlerName = mockHandlerImpl.0
        return SourceCode("if let __\(handlerName) = self.\(handlerName)") {[
            SourceCode("\(returning)\(invocationThrowing)__\(handlerName)(\(parameters))\(forceCastingToGenericReturnValue)")
        ]}
    }
}

private struct Regex {
    static let placeholderPattern = "\\{([^\\}]+)\\}"
}

private extension String {
    var swiftifiedMethodName: String {
        return self
            .replacingOccurrences(of: "(", with: "_")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "`", with: "")
            .camelCased()
            .lowercasedFirstWord()
    }

    func resolvingGenericPlaceholders(prefix genericTypePrefix: String) -> String {
        return replacingOccurrences(of: Regex.placeholderPattern, with: "\(genericTypePrefix)$1", options: .regularExpression)
    }
}

private extension MockMethod {
    var shortNameKey: String {
        return method.shortName.swiftifiedMethodName
    }
}

private extension SourceryRuntime.Method {
    var methodParametersDecl: String {
        return parameters
            .map {
                let argumentLabel = $0.argumentLabel == nil ? "_ " : $0.argumentLabel != $0.name ? "\($0.argumentLabel!) " : ""
                return "\(argumentLabel)\($0.name): \($0.typeName.name)"
            }
            .joined(separator: ", ")
    }

    var throwingDecl: String {
        return self.`throws` ? " throws" : self.`rethrows` ? " rethrows" : ""
    }

    var throwingHandlerDecl: String {
        return self.`throws` || self.`rethrows` ? " throws" : ""
    }

    var returnTypeDecl: String {
        return !returnTypeName.isVoid ? " -> \(returnTypeName.name)" : ""
    }
}

private extension Collection where Element == MockMethod {
    /// If all method mocks were created with `useShortName: true`, then the resulting mock might have duplicate backing variable names for methods, e.g.:
    /// ```
    /// func updateTips(_ tips: [Tip])
    /// func updateTips(with: AnySequence<Tip>) throws
    /// ```
    /// would both produce `var updateTipsCallCount: Int = 0`, which will break the build.
    /// This method finds such occurrences and tries to use fully-qualified names of the method to produce mock variables for groups of duplicate methods.
    /// While doing so, it will try to use `useShortName: true` for the shortest method name, to produce a little bit more readable/deterministic mock class,
    /// where the existing implementation would not change if new method overrides are added later with more parameters.
    var minimumNonConflictingPermutation: [MockMethod] {
        return reduce(into: [:]) { (partialResult: inout [String: [MockMethod]], nextItem: MockMethod) in
                let key = nextItem.shortNameKey
                var group = partialResult[key] ?? []
                group.append(nextItem)
                partialResult[key] = group
            }
            .map { $0.1.makeUniqueByUsingLongNamesExceptForFewestArgumentMethod() }
            .joined()
            .map { $0 }
    }

    private func makeUniqueByUsingLongNamesExceptForFewestArgumentMethod() -> [MockMethod] {
        guard count != 1 else { return Array(self) }
        func areInAscendingOrder(lhs: MockMethod, rhs: MockMethod) -> Bool {
            if lhs.method.parameters.count < rhs.method.parameters.count {
                // Use the method with the fewest number of parameters
                return true
            }
            if lhs.method.parameters.count == rhs.method.parameters.count,
                let firstParameterLhs = lhs.method.parameters.first,
                let firstParameterRhs = rhs.method.parameters.first {
                // If two methods have the same number of parameters, but one has shorter syntax by not requiring parameter label, use it instead.
                return firstParameterLhs.argumentLabel == nil && firstParameterRhs.argumentLabel != nil
            }
            // Otherwise, use the other one.
            return false
        }
        guard let fewestArgumentsMethod = min(by: areInAscendingOrder), let largestArgumentsMethod = max(by: areInAscendingOrder) else { fatalError("Should not happen.") }
        if fewestArgumentsMethod.method.parameters.parametersCountAppendingOneForArgumentLabel == largestArgumentsMethod.method.parameters.parametersCountAppendingOneForArgumentLabel {
            // min and max methods in the collection have exactly the same number of parameters, we can't choose one over another,
            // so use long form for all.
            return makeUniqueByUsingLongNames()
        }
        let copy = map { MockMethod(type: $0.type, method: $0.method, genericTypePrefix: $0.genericTypePrefix, useShortName: $0 === fewestArgumentsMethod) }
        guard !copy.hasDuplicateMockedMethodNames else {
            return makeUniqueByUsingLongNames()
        }
        return copy
    }

    private func makeUniqueByUsingLongNames() -> [MockMethod] {
        return map { MockMethod(type: $0.type, method: $0.method, genericTypePrefix: $0.genericTypePrefix, useShortName: false) }
    }

    var hasDuplicateMockedMethodNames: Bool {
        var mockedMethodNames = Set<String>()
        for nextItem in self {
            let key = nextItem.mockedMethodName
            if mockedMethodNames.contains(key) {
                return true
            }
            mockedMethodNames.insert(key)
        }
        return false
    }
}

private extension Collection where Element == SourceryRuntime.MethodParameter {
    var parametersCountAppendingOneForArgumentLabel: Int {
        return (first?.argumentLabel != nil ? 1 : 0) + count
    }
}

private extension Collection where Element == SourceryRuntime.Method {
    /// Courtesy of https://github.com/MakeAWishFoundation/SwiftyMocky/blob/develop/Sources/Templates/Mock.swifttemplate
    func uniques() -> [SourceryRuntime.Method] {
        func returnTypeStripped(_ method: SourceryRuntime.Method) -> String {
            let returnTypeRaw = "\(method.returnTypeName)"
            var stripped: String = {
                guard let range = returnTypeRaw.range(of: "where") else { return returnTypeRaw }
                var stripped = returnTypeRaw
                stripped.removeSubrange((range.lowerBound)...)
                return stripped
            }()
            stripped = stripped.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            return stripped
        }

        func areSameParams(_ p1: SourceryRuntime.MethodParameter, _ p2: SourceryRuntime.MethodParameter) -> Bool {
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.name == p2.name else { return false }
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.typeName.name == p2.typeName.name else { return false }
            guard p1.actualTypeName?.name == p2.actualTypeName?.name else { return false }
            return true
        }

        func areSameMethods(_ m1: SourceryRuntime.Method, _ m2: SourceryRuntime.Method) -> Bool {
            guard m1.name != m2.name else { return m1.returnTypeName == m2.returnTypeName }
            guard m1.selectorName == m2.selectorName else { return false }
            guard m1.parameters.count == m2.parameters.count else { return false }

            let p1 = m1.parameters
            let p2 = m2.parameters

            for i in 0..<p1.count {
                if !areSameParams(p1[i],p2[i]) { return false }
            }

            return m1.returnTypeName == m2.returnTypeName
        }

        return reduce([], { (result, element) -> [SourceryRuntime.Method] in
            guard !result.contains(where: { areSameMethods($0,element) }) else { return result }
            return result + [element]
        })
    }

    /// Courtesy of https://github.com/MakeAWishFoundation/SwiftyMocky/blob/develop/Sources/Templates/Mock.swifttemplate
    func uniquesWithoutGenericConstraints() -> [SourceryRuntime.Method] {
        func returnTypeStripped(_ method: SourceryRuntime.Method) -> String {
            let returnTypeRaw = "\(method.returnTypeName)"
            var stripped: String = {
                guard let range = returnTypeRaw.range(of: "where") else { return returnTypeRaw }
                var stripped = returnTypeRaw
                stripped.removeSubrange((range.lowerBound)...)
                return stripped
            }()
            stripped = stripped.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            return stripped
        }

        func areSameParams(_ p1: SourceryRuntime.MethodParameter, _ p2: SourceryRuntime.MethodParameter) -> Bool {
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.name == p2.name else { return false }
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.typeName.name == p2.typeName.name else { return false }
            guard p1.actualTypeName?.name == p2.actualTypeName?.name else { return false }
            return true
        }

        func areSameMethods(_ m1: SourceryRuntime.Method, _ m2: SourceryRuntime.Method) -> Bool {
            guard m1.name != m2.name else { return returnTypeStripped(m1) == returnTypeStripped(m2) }
            guard m1.selectorName == m2.selectorName else { return false }
            guard m1.parameters.count == m2.parameters.count else { return false }

            let p1 = m1.parameters
            let p2 = m2.parameters

            for i in 0..<p1.count {
                if !areSameParams(p1[i],p2[i]) { return false }
            }

            return returnTypeStripped(m1) == returnTypeStripped(m2)
        }

        return reduce([], { (result, element) -> [SourceryRuntime.Method] in
            guard !result.contains(where: { areSameMethods($0,element) }) else { return result }
            return result + [element]
        })
    }
}
