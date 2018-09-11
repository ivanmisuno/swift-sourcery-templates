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
        case "Int", "Int32", "Int64", "UInt", "UInt32", "UInt64": return "0"
        case "Float", "Double": return "0.0"
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

    func smartDefaultValueImplementation(isProperty: Bool, mockVariablePrefix: String) throws -> (getterImplementation: SourceCode, mockedVariableHandlers: [SourceCode]) {
        guard
            isGeneric,
            let generic = generic,
            generic.name == "Observable" || generic.name == "AnyObserver",
            generic.typeParameters.count == 1
        else { throw MockError.noDefaultValue(typeName: self) }

        switch generic.name {
        case "Observable":
            let getterImplementation = SourceCode("return \(mockVariablePrefix)Subject.asObservable()")
            let mockedVariableHandlers = [SourceCode("lazy var \(mockVariablePrefix)Subject = PublishSubject<\(generic.typeParameters[0].typeName.name)>()")]
            return (getterImplementation, mockedVariableHandlers)
        case "AnyObserver":
            let getterImplementation = SourceCode("return AnyObserver { [weak self] event in") { [
                SourceCode("self?.\(mockVariablePrefix)CallCount += 1"),
                SourceCode("self?.\(mockVariablePrefix)EventHandler?(event)"),
            ]}
            var mockedVariableHandlers: [SourceCode] = []
            if isProperty {
                mockedVariableHandlers.append(SourceCode("var \(mockVariablePrefix)CallCount: Int = 0"))
            }
            mockedVariableHandlers.append(SourceCode("var \(mockVariablePrefix)EventHandler: ((Event<\(generic.typeParameters[0].typeName.name)>) -> ())? = nil"))
            return (getterImplementation, mockedVariableHandlers)
        default:
            fatalError("Should not happen")
        }
    }

}
