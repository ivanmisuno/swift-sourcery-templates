import Foundation
import SourceryRuntime

class MockMethod {
    fileprivate let method: SourceryRuntime.Method
    fileprivate let useShortName: Bool

    init(method: SourceryRuntime.Method, useShortName: Bool) {
        self.method = method
        self.useShortName = useShortName
    }

    static func from(_ type: Type) throws -> [MockMethod] {
        let allMethods = type.allMethods.filter { !$0.isStatic }.uniquesWithoutGenericConstraints()
        let mockedMethods = allMethods
            .map { MockMethod(method: $0, useShortName: true) }
            .minimumNonConflictingPermutation
        guard !mockedMethods.hasDuplicateMockedMethodNames else {
            throw MockError.internalError(message: "Mock generator: not all duplicates resolved!")
        }
        return mockedMethods
    }

/*
    func methodThrowableErrorDeclaration(_ method: SourceryRuntime.Method) -> String {
        return "var \(swiftifyMethodName(method.selectorName))ThrowableError: Error?"
    }
    func methodThrowableErrorUsage(_ method: SourceryRuntime.Method) -> String {
        return """
            if let error = \(methodThrowableErrorDeclaration(method))ThrowableError {
                throw error
            }
        """
    }
    func methodHandlerName(_ method: SourceryRuntime.Method) -> String {
        return "\(swiftifyMethodName(method.callName))Handler"
    }
    func methodHandlerDeclaration(_ method: SourceryRuntime.Method) -> String {
        let parameters = method.parameters.map {
            if let argumentLabel = $0.argumentLabel {
                return "_ \($0.name): \($0.typeName.name)"
            } else {
                return $0.typeName.name
            }
        }.joined(separator: ", ")
        let throwing = method.throws ? " throws" : ""
        let returnType = method.isInitializer ? "()" : method.returnTypeName.name
        return "var \(methodHandlerName(method)): ((\(parameters))\(throwing) -> \(returnType))? = nil"
    }
    func methodHandlerCallParameters(_ method: SourceryRuntime.Method) -> String {
        return method.parameters.map { $0.name }.joined(separator: ", ")
    }
    func mockMethod(_ method: SourceryRuntime.Method) -> String {
        return """
            // MARK: - \(method.name)
            \(methodHandlerDeclaration(method))

        """
    }
*/
}

extension MockMethod {
    fileprivate var mockedMethodName: String {
        var result: [String] = [method.callName]
        if !useShortName {
            result += method.parameters.map { "\($0.argumentLabel?.uppercasedFirstLetter() ?? "")\($0.name.uppercasedFirstLetter())" }
        }
        return result.joined().swiftifiedMethodName
    }

    func mockImpl() throws -> [SourceCode] {
        var mockMethodHandlers = TopScope()

        let throwing = method.`throws` ? " throws" : method.`rethrows` ? " rethrows" : ""
        let returnTypeDecl = !method.returnTypeName.isVoid ? " -> \(method.returnTypeName.name)" : ""

        let mockCallCount = mockCallCountImpl
        mockMethodHandlers += mockCallCount.1

        var mockHandler = mockHandlerImpl
        mockMethodHandlers += mockHandler.1

        // Increment usage call count.
        var methodImpl = SourceCode("func \(method.name)\(throwing)\(returnTypeDecl)") {[
            SourceCode("\(mockCallCount.0) += 1"),
        ]}

        // Call the handler.
        methodImpl += mockHandlerCallImpl

        // Fallback return value.
        if method.returnTypeName.isVoid {
            // No return value
        } else if method.isOptionalReturnType {
            // Return nil
            methodImpl += "return nil"
        } else {
            // Do something smart
            /*if method.returnTypeName.isComplexTypeWithSmartDefaultValue, let smartDefaultValueImplementation = method.returnTypeName.smartDefaultValueImplementation(isProperty: false, mockVariablePrefix: mockedMethodName) {
                methodImpl += smartDefaultValueImplementation.0
                mockMethodHandlers += smartDefaultValueImplementation.1
            } else*/
            if method.returnTypeName.hasDefaultValue, let defaultValue = try? method.returnTypeName.defaultValue() {
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

    private var mockCallCountImpl: (String, SourceCode) {
        let mockedVarCallCountName = "\(mockedMethodName)CallCount"
        return (mockedVarCallCountName, SourceCode("var \(mockedVarCallCountName): Int = 0"))
    }

    private var mockHandlerImpl: (String, SourceCode) {
        let mockMethodHandlerName = "\(mockedMethodName)Handler"
        let handlerParameters = method.parameters.map { "_ \($0.name): \($0.typeName.name)" }.joined(separator: ", ")
        let throwing = method.`throws` || method.`rethrows` ? " throws" : ""
        let returnType = !method.returnTypeName.isVoid ? method.returnTypeName.name : ""
        return (mockMethodHandlerName, SourceCode("var \(mockMethodHandlerName): ((\(handlerParameters))\(throwing) -> (\(returnType)))? = nil"))
    }

    private var mockHandlerCallImpl: SourceCode {
        let mockMethodHandlerName = "\(mockedMethodName)Handler"
        let returning = method.returnTypeName.isVoid ? "" : "return "
        let parameters = method.parameters.map { "\($0.name)" }.joined(separator: ", ")
        return SourceCode("if let handler = \(mockHandlerImpl.0)") {[
            SourceCode("\(returning)\(method.`throws` || method.`rethrows` ? "try " : "")handler(\(parameters))")
        ]}
    }
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
}

private extension MockMethod {
    var shortNameKey: String {
        return method.shortName.swiftifiedMethodName
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
        guard let fewestArgumentsMethod = min(by: areInAscendingOrder) else { fatalError("Should not happen.") }
        let copy = map { MockMethod(method: $0.method, useShortName: $0 === fewestArgumentsMethod) }
        guard !copy.hasDuplicateMockedMethodNames else {
            return makeUniqueByUsingLongNames()
        }
        return copy
    }

    private func makeUniqueByUsingLongNames() -> [MockMethod] {
        return map { MockMethod(method: $0.method, useShortName: false) }
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
