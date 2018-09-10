import Foundation
import SourceryRuntime

private struct Constants {
    static let NEWL = ""
    static let genericTypePrefix = "Type"
}

class MockGenerator {
    static func generate(for types: [Type]) -> String {
        var topScope = TopScope()

        for type in types {
            let genericTypes = type.genericTypes

            //let allMethods = uniques(methods: type.allMethods.filter { !$0.isStatic })

            topScope += Constants.NEWL
            topScope += "// MARK: - \(type.name)"

            var mock = SourceCode("class \(type.name)Mock\(genericTypes.genericTypesModifier): \(type.isObjcProtocol ? "NSObject, " : "")\(type.name)\(genericTypes.genericTypesConstraints)")
            mock.isBlockMandatory = true
            mock += genericTypes.typealiasesDeclarations

            let mockVars = MockVar.from(type)
            mock += mockVars.flatMap { $0.mockImpl }

            topScope += mock
        }

        return topScope.indentedSourcecode()
    }
}

private extension Collection where Element == GenericTypeInfo {

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

private struct GenericTypeInfo {
    let genericType: String
    let constraints: [String]
}

private extension SourceryRuntime.`Type` {
    var isObjcProtocol: Bool {
        return annotations["ObjcProtocol"] != nil
            || inheritedTypes.contains("NSObjectProtocol")
    }

    var genericTypes: [GenericTypeInfo] {
        let genericTypes = extractAssociatedTypes(self).map { GenericTypeInfo(genericType: $0.associatedType, constraints: $0.constraints) }
        return genericTypes
    }
}
