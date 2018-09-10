import Foundation
import SourceryRuntime

enum MockError: Error {
case noDefaultValue
}

extension SourceryRuntime.TypeName {
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

        throw MockError.noDefaultValue
    }
}
