import Foundation
import SourceryRuntime

extension SourceryRuntime.Annotated {
    func annotations(for names: [String]) -> [String] {
        return names
            .flatMap { extractAnnotations(for: $0) }
            .removeDuplicates()
            .sorted()
    }

    private func extractAnnotations(for name: String) -> [String] {
        if let annotations = annotations[caseInsensitive: name] as? [String] {
            return annotations.map { $0.trimmingWhitespace() }
        } else if let annotation = annotations[caseInsensitive: name] as? String {
            return [annotation.trimmingWhitespace()]
        } else {
            return []
        }
    }
}

private extension Dictionary where Key == String {
    subscript(caseInsensitive key: Key) -> Value? {
        return first { $0.0.lowercased() == key.lowercased() }?.value
    }
}

private extension Array where Element: Hashable, Element: Comparable {
    func removeDuplicates() -> [Element] {
        return Array(Set(self)).sorted()
    }
}
