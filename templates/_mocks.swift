import Foundation
import SourceryRuntime

func swiftifyMethodName(_ name: String) -> String {
    let swiftifiedName = name
        .replacingOccurrences(of: "(", with: "_")
        .replacingOccurrences(of: ")", with: "")
        .replacingOccurrences(of: ":", with: "_")
        .replacingOccurrences(of: "`", with: "")
    let camelCasedName = snakeToCamelCase(swiftifiedName)
    let lowercasedFirstWordName = lowerFirstWord(camelCasedName)
    return lowercasedFirstWordName
}
func uniques(methods: [SourceryRuntime.Method]) -> [SourceryRuntime.Method] {
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

    return methods.reduce([], { (result, element) -> [SourceryRuntime.Method] in
        guard !result.contains(where: { areSameMethods($0,element) }) else { return result }
        return result + [element]
    })
}

func uniquesWithoutGenericConstraints(methods: [SourceryRuntime.Method]) -> [SourceryRuntime.Method] {
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

    return methods.reduce([], { (result, element) -> [SourceryRuntime.Method] in
        guard !result.contains(where: { areSameMethods($0,element) }) else { return result }
        return result + [element]
    })
}

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

/// Represents source code construct:
/// line
/// or
/// line {
///     $(nested)
/// }
class SourceCode {
    let line: String
    var nested: [SourceCode]
    var isBlockMandatory: Bool = false // if `true`, always output curly braces after the line, even if nested is empty, e.g., empty class/function declaration.

    init(_ line: String, nested: [SourceCode] = []) {
        self.line = line
        self.nested = nested
    }
    convenience init(_ line: String, nested: () -> [SourceCode]) {
        self.init(line, nested: nested())
    }

    func nest(_ source: SourceCode) {
        nested.append(source)
    }

    func indentedSourcecode(_ level: Int = 0) -> String {
        guard !line.isEmpty else {
            assert(nested.isEmpty)
            return ""
        }
        let indent = String(repeating: " ", count: level * 4)
        var result = "\(indent)\(line)"
        let nestedCode = nested.map { $0.indentedSourcecode(level + 1) }.joined(separator: "\n")
        if !nestedCode.isEmpty {
            if !line.contains("{") { // as in, e.g., "return AnyObserver { [weak self] event in"
                result += " {"
            }
            result += "\n\(nestedCode)\n\(indent)}"
        } else if isBlockMandatory {
            result += " {\n\(indent)}"
        }
        return result
    }
}

class TopScope {
    var nested: [SourceCode] = []

    func nest(_ source: SourceCode) {
        nested.append(source)
    }

    func indentedSourcecode() -> String {
        return nested.map { $0.indentedSourcecode(0) }.joined(separator: "\n")
    }
}

extension TopScope: CustomStringConvertible {
    var description: String {
        return indentedSourcecode()
    }
}

protocol SourceAppendable {
    func nest(_ source: SourceCode)
}
extension SourceCode: SourceAppendable {}
extension TopScope: SourceAppendable {}
extension SourceAppendable {
    @discardableResult
    func nest(_ line: String) -> SourceCode {
        let sourceLine = SourceCode(line)
        nest(sourceLine)
        return sourceLine
    }

    func nest(contentsOf array: [SourceCode]) {
        array.forEach { nest($0) }
    }

    func nest(contentsOf array: [String]) {
        array.forEach { nest($0) }
    }

    static func +=(_ lhs: Self, _ rhs: SourceCode) {
        lhs.nest(rhs)
    }
    static func +=(_ lhs: Self, _ rhs: [SourceCode]) {
        lhs.nest(contentsOf: rhs)
    }

    @discardableResult
    static func +=(_ lhs: Self, _ line: String) -> SourceCode {
        return lhs.nest(line)
    }

    static func +=(_ lhs: Self, _ lines: [String]) {
        lhs.nest(contentsOf: lines)
    }
}

fileprivate extension SourceryRuntime.TypeName {
    var isComplexTypeWithSmartDefaultValueImplementation: Bool {
        guard
            isGeneric,
            let generic = generic,
            generic.name == "Observable" || generic.name == "AnyObserver",
            generic.typeParameters.count == 1
        else {
            return false
        }
        return true
    }

    var smartDefaultValueImplementation: ((String) -> (getterImplementation: SourceCode, mockedVariableHandlers: [SourceCode])?) {
        return { mockedVariableName in
            guard self.isComplexTypeWithSmartDefaultValueImplementation, let generic = self.generic else { return nil }
            switch generic.name {
            case "Observable":
                let getterImplementation = SourceCode("return \(mockedVariableName)Subject.asObservable()")
                let mockedVariableHandlers = [SourceCode("lazy var \(mockedVariableName)Subject = PublishSubject<\(generic.typeParameters[0].typeName.name)>()")]
                return (getterImplementation, mockedVariableHandlers)
            case "AnyObserver":
                let getterImplementation = SourceCode("return AnyObserver { [weak self] event in") { [
                    SourceCode("self?.\(mockedVariableName)CallCount += 1"),
                    SourceCode("self?.\(mockedVariableName)EventHandler?(event)"),
                ]}
                let mockedVariableHandlers = [SourceCode("var \(mockedVariableName)CallCount: Int = 0"),
                                              SourceCode("var \(mockedVariableName)EventHandler = ((Event<\(generic.typeParameters[0].typeName.name)>) -> ())? = nil")]
                return (getterImplementation, mockedVariableHandlers)
            default:
                fatalError("Should not get here.")
            }
        }
    }
}

class MockVar {
    let variable: SourceryRuntime.Variable

    init(variable: SourceryRuntime.Variable) {
        self.variable = variable
    }

    lazy var mockedVariableName = "\(variable.name)"
    var backingMockedVariableName: String { return "\(mockedVariableName)Backing" }

    private var needBackingVariable: Bool {
        return variable.isMutable
            || variable.typeName.isOptional
            || !isComplexTypeWithSmartDefaultValueImplementation
    }

    private var isComplexTypeWithSmartDefaultValueImplementation: Bool {
        return !variable.isMutable
            && variable.typeName.isComplexTypeWithSmartDefaultValueImplementation
    }

    static func from(_ type: Type) -> [MockVar] {
        let allVariables = type.allVariables.filter { !$0.isStatic }.uniqueVariables
        return allVariables.map { MockVar(variable: $0) }
    }

    var mockImpl: [SourceCode] {
        var mockedVariableHandlers = TopScope()

        var getterImplementation = SourceCode("get")
        if variable.typeName.isOptional {
            getterImplementation += SourceCode("return \(mockedVariableName)GetHandler?() ?? \(backingMockedVariableName)")
            mockedVariableHandlers += "var \(mockedVariableName)GetHandler: (() -> \(variable.typeName))? = nil"
        } else {
            getterImplementation += SourceCode("if let handler = \(mockedVariableName)GetHandler") { [
                SourceCode("return handler()")
            ]}
            mockedVariableHandlers += "var \(mockedVariableName)GetHandler: (() -> \(variable.typeName))? = nil"

            if isComplexTypeWithSmartDefaultValueImplementation, let smartDefaultValueImplementation = variable.typeName.smartDefaultValueImplementation(mockedVariableName) {
                getterImplementation += smartDefaultValueImplementation.getterImplementation
                mockedVariableHandlers += smartDefaultValueImplementation.mockedVariableHandlers
            } else {
                getterImplementation += SourceCode("if let value = \(backingMockedVariableName)") {[
                    SourceCode("return value")
                ]}

                if let defaultValue = try? defaultValue(variable.typeName) {
                    getterImplementation += SourceCode("return \(defaultValue)")
                } else {
                    getterImplementation += SourceCode("fatalError(\"Either `\(mockedVariableName)GetHandler` or value must be provided!\")")
                }
            }
        }

        var setterImplementation = SourceCode("set")
        if variable.isMutable {
            setterImplementation += "\(backingMockedVariableName) = newValue"
            setterImplementation += "\(mockedVariableName)SetCount += 1"
            setterImplementation += "\(mockedVariableName)SetHandler?(newValue)"

            mockedVariableHandlers += "var \(mockedVariableName)SetCount: Int = 0"
            mockedVariableHandlers += "var \(mockedVariableName)SetHandler: ((_ \(mockedVariableName): \(variable.typeName)) -> ())? = nil"
        }

        var mockedVariableImplementation = SourceCode("var \(variable.name): \(variable.typeName)")
        if !setterImplementation.nested.isEmpty {
            mockedVariableImplementation += getterImplementation
            mockedVariableImplementation += setterImplementation
        } else {
            mockedVariableImplementation += getterImplementation.nested
        }

        if needBackingVariable {
            mockedVariableHandlers += "var \(backingMockedVariableName): \(variable.unwrappedTypeName)?"
        }

        var result = TopScope()
        result += mockedVariableImplementation
        result += mockedVariableHandlers.nested
        return result.nested
    }
}

extension Collection where Element: SourceryRuntime.Variable {
    var uniqueVariables: [SourceryRuntime.Variable] {
        return reduce(into: [], { (result, element) in
            guard !result.contains(where: { $0.name == element.name }) else { return }
            result.append(element)
        })
    }
}

class MockFunc {
}

enum MockImpl {
case Var(MockVar)
case Func(MockFunc)
}

enum MockError: Error {
case noDefaultValue
}

func defaultValue(_ typeName: SourceryRuntime.TypeName) throws -> String {
    if typeName.isOptional { return "nil" }
    if typeName.isVoid { return "()" }
    if typeName.isArray { return "[]" }
    if typeName.isDictionary { return "[:]" }
    if typeName.isTuple, let tuple = typeName.tuple {
        let joined = try tuple.elements.map { try defaultValue($0.typeName) }.joined(separator: ", ")
        return "(\(joined))"
    }

    switch typeName.unwrappedTypeName {
    case "String": return "\"\""
    case "Int", "Int32", "Int64", "UInt", "UInt32", "UInt64": return "0"
    case "Float", "Double": return "0.0"
    case "CGFloat": return "CGFloat(0)"
    case "CGPoint", "NSPoint": return "CGPoint.zero"
    case "CGSize", "NSSize": return "CGSize.zero"
    case "CGRect", "NSRect": return "CGRect.zero"
    default:
        break
    }

    throw MockError.noDefaultValue
}



struct Constants {
    static let NEWL = ""
    static let genericTypePrefix = "Type"
}

struct GenericTypeInfo {
    let genericType: String
    let constraints: [String]
}
extension SourceryRuntime.`Type` {
    var isObjcProtocol: Bool {
        return annotations["ObjcProtocol"] != nil
            || inheritedTypes.contains("NSObjectProtocol")
    }

    var genericTypes: [GenericTypeInfo] {
        let genericTypes = extractAssociatedTypes(self).map { GenericTypeInfo(genericType: $0.associatedType, constraints: $0.constraints) }
        return genericTypes
    }
}
extension Collection where Element == GenericTypeInfo {

    /// For a given list of generic types, creates a corresponding type declaration modifier string.
    /// E.g., for a list ["T1", "T2"] this will create "<T1, T2>" modifier string.
    var genericTypesModifier: String {
        let types = map { "\(Constants.genericTypePrefix)\($0.genericType)" }
        return !types.isEmpty ? "<\(types.joined(separator: ", "))>" : ""
    }

    /// For a given list of generic types, some of which has constraints, creates a "where" clause for the type declaration.
    /// E.g., for a list ["T1: RawRepresentable, Hashable", "T2"] this will create "where T1: RawRepresentable, T1: Hashable" modifier string.
    var genericTypesConstraints: String {
        let constraints = flatMap { genericType in return genericType.constraints.map { "\(Constants.genericTypePrefix)\(genericType.genericType): \($0)" } }
        return !constraints.isEmpty ? " where \(constraints.joined(separator: ", "))" : ""
    }

    var typealiasesDeclarations: [String] {
        guard !isEmpty else { return [] }
        var result: [String] = []
        result.append(Constants.NEWL)
        result.append("// MARK: - Generic typealiases")
        result.append(contentsOf: map { "typealias \($0.genericType) = \(Constants.genericTypePrefix)\($0.genericType)" })
        return result
    }
}
