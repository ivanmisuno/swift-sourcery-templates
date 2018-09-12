import Foundation
import SourceryRuntime

struct GenericTypeInfo {
    let genericType: String
    let constraints: [String]
}

extension SourceryRuntime.Annotated {
    func annotatedAssociatedTypes() -> [GenericTypeInfo] {
        return extractAnnotatedGenericTypes(for: ["associatedtype", "associatedtypes"])
    }
    func annotatedGenericTypes() -> [GenericTypeInfo] {
        return extractAnnotatedGenericTypes(for: ["generictype", "generictypes"])
    }

    private func extractAnnotatedGenericTypes(for names: [String]) -> [GenericTypeInfo] {
        return annotations(for: names)
            .map {
                let split = $0.replacingOccurrences(of: " ", with: "").split(separator: ":").map(String.init)
                let associatedType = split[0]
                let constraints = split.count == 2 ? split[1].split(separator: ",").map(String.init) : []
                return GenericTypeInfo(genericType: associatedType, constraints: constraints)
            }
    }
}
