import Foundation
import SourceryRuntime

enum MockError: Error {
case noDefaultValue(typeName: TypeName)
case duplicateGenericTypeName(context: String)
case internalError(message: String)
}

private struct Constants {
    static let NEWL = ""
    static let genericTypePrefix = "_"
}

class MockGenerator {
    static func generate(for types: [Type]) throws -> String {
        var topScope = TopScope()

        for type in types {
            let mockVars = MockVar.from(type)
            let mockMethods = try MockMethod.from(type)

            topScope += Constants.NEWL
            topScope += "// MARK: - \(type.name)"

            let genericTypes: [GenericTypeInfo]
            do {
                genericTypes = try mockMethods.reduce(into: type.genericTypes) { (partialResult: inout [GenericTypeInfo], mockMethod: MockMethod) in
                    try mockMethod.genericTypes.forEach { genericType in
                        guard !partialResult.contains(where: { $0.genericType == genericType.genericType }) else {
                            throw MockError.duplicateGenericTypeName(context: "`func \(mockMethod.method.name)` has generic type name `\(genericType.genericType)` which is not unique across all generic types for the protocol (\(partialResult.map { $0.genericType })). Please change protocol declaration so that generic types have unique names!")
                        }
                        partialResult.append(genericType)
                    }
                }
            } catch {
                topScope += "// \(error)"
                continue
            }

            var mock = SourceCode("class \(type.name)Mock\(genericTypes.genericTypesModifier): \(type.isObjcProtocol ? "NSObject, " : "")\(type.name)\(genericTypes.genericTypesConstraints)")
            mock.isBlockMandatory = true
            mock += genericTypes.typealiasesDeclarations

            let mockVarsFlattened = try mockVars.flatMap { try $0.mockImpl() }
            if !mockVarsFlattened.isEmpty {
                mock += Constants.NEWL
                mock += "// MARK: - Variables"
                mock += mockVarsFlattened
            }

            let mockMethodsFlattened = try mockMethods.flatMap { try $0.mockImpl() }
            if !mockMethodsFlattened.isEmpty {
                mock += Constants.NEWL
                mock += "// MARK: - Methods"
                mock += mockMethodsFlattened
            }

            topScope += mock
        }

        return topScope.indentedSourcecode()
    }
}

private extension SourceryRuntime.`Type` {
    var isObjcProtocol: Bool {
        return annotations["ObjcProtocol"] != nil
            || inheritedTypes.contains("NSObjectProtocol")
    }
}

private extension SourceryRuntime.`Type` {
    var genericTypes: [GenericTypeInfo] {
        let associatedTypes = annotatedAssociatedTypes()
        return associatedTypes
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

extension MockError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noDefaultValue(let typeName): return "Unable to generate default value for \(typeName)"
        case .duplicateGenericTypeName(let context): return "Duplicate generic type name found while generating mock implementation: \(context)"
        case .internalError(let message): return "Internal error: \(message)"
        }
    }
}

extension MockError: CustomStringConvertible {
    var description: String {
        return errorDescription ?? String(describing: self)
    }
}

extension MockError: CustomDebugStringConvertible {
    var debugDescription: String {
        return errorDescription ?? String(describing: self)
    }
}
