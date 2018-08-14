import Foundation
import SourceryRuntime

// MARK: - low-level utility methods
func trimmingWhitespace(_ string: String) -> String {
  return string.trimmingCharacters(in: .whitespacesAndNewlines)
}
func removeDuplicates<T: Hashable>(_ array: [T]) -> [T] {
  return Array(Set(array))
}

// MARK: - generic utility
func extractAnnotations(_ type: Type, annotationNames: [String]) -> [String] {
  let annotations = annotationNames.flatMap { _extractAnnotations(type, annotationName: $0) }
  return removeDuplicates(annotations).sorted()
}
func extractAnnotations(_ type: Type, annotationName: String) -> [String] {
  return removeDuplicates(_extractAnnotations(type, annotationName: annotationName)).sorted()
}
func _extractAnnotations(_ type: Type, annotationName: String) -> [String] {
  if let annotations = type.annotations[annotationName] as? [String] {
    return annotations.map { trimmingWhitespace($0) }
  } else if let annotations = type.annotations[annotationName] as? String {
    return [trimmingWhitespace(annotations)]
  } else {
    return []
  }
}

// MARK: - extractors
func extractAssociatedTypes(_ type: Type) -> [(associatedType: String, constraints: [String])] {
  return extractAnnotations(type, annotationNames: ["associatedtype", "associatedtypes"])
    .map {
      let split = $0.replacingOccurrences(of: " ", with: "").characters.split(separator: ":").map(String.init)
      let associatedType = split[0]
      let constraints = split.count == 2 ? split[1].characters.split(separator: ",").map(String.init) : []
      return (associatedType: associatedType, constraints: constraints)
    }
}
