import Foundation
import SourceryRuntime

extension SourceryRuntime.TypeName {

    var hasDefaultValue: Bool {
        return (try? defaultValue()) != nil
    }

    func defaultValue() throws -> String {
        if isOptional { return "nil" }
        if isVoid { return "()" }
        if isArray { return "[]" }
        if isDictionary { return "[:]" }
        if isTuple, let tuple = tuple {
            let joined = try tuple.elements.map { try $0.typeName.defaultValue() }.joined(separator: ", ")
            return "(\(joined))"
        }

        switch unwrappedTypeName {
        case "String": return "\"\""
        case "Bool": return "false"
        case "Int", "Int32", "Int64", "UInt", "UInt32", "UInt64": return "0"
        case "Float", "Double": return "0.0"
        case "NSTimeInterval", "TimeInterval": return "0.0"
        case "CGFloat": return "CGFloat(0)"
        case "CGPoint", "NSPoint": return "CGPoint.zero"
        case "CGSize", "NSSize": return "CGSize.zero"
        case "CGRect", "NSRect": return "CGRect.zero"
        default:
            break
        }

        throw MockError.noDefaultValue(typeName: self)
    }

    var isComplexTypeWithSmartDefaultValue: Bool {
        return (try? smartDefaultValueImplementation(isProperty: true, mockVariablePrefix: "")) != nil
    }

    func smartDefaultValueImplementation(isProperty: Bool, mockVariablePrefix: String, forceCastingToReturnTypeName: Bool = false) throws -> (getterImplementation: SourceCode, mockedVariableHandlers: [SourceCode]) {
        guard
            isGeneric,
            let generic = generic,
            generic.name == "Single" || generic.name == "Observable" || generic.name == "AnyObserver",
            generic.typeParameters.count == 1
        else { throw MockError.noDefaultValue(typeName: self) }

        let returnTypeName = !generic.typeParameters[0].typeName.isVoid ? generic.typeParameters[0].typeName.name : "()"
        let forceCasting = forceCastingToReturnTypeName && !isVoid ? " as! \(name.trimmingWhereClause())" : ""
        switch generic.name {
        case "Single", "Observable":
            let getterImplementation = SourceCode("return \(mockVariablePrefix)Subject.as\(generic.name)()\(forceCasting)") // ".asSingle()" | ".asObservable()"
            let mockedVariableHandlers = [SourceCode("lazy var \(mockVariablePrefix)Subject = PublishSubject<\(returnTypeName)>()")]
            return (getterImplementation, mockedVariableHandlers)
        case "AnyObserver":
            guard isProperty else { throw MockError.noDefaultValue(typeName: self) } // Only properties with `AnyObserver` type are supported.
            let getterImplementation = SourceCode("return AnyObserver { [weak self] event in") { [
                SourceCode("self?.\(mockVariablePrefix)EventCallCount += 1"),
                SourceCode("self?.\(mockVariablePrefix)EventHandler?(event)"),
            ]}
            let mockedVariableHandlers: [SourceCode] = [
                SourceCode("var \(mockVariablePrefix)EventCallCount: Int = 0"),
                SourceCode("var \(mockVariablePrefix)EventHandler: ((Event<\(returnTypeName)>) -> ())? = nil"),
            ]
            return (getterImplementation, mockedVariableHandlers)
        default:
            fatalError("Should not happen")
        }
    }

}
