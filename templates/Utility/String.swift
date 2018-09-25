import Foundation

extension String {
    func trimmingWhitespace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func trimmingWhereClause() -> String {
        if let rangeOfWhereClause = range(of: " where ") {
            return String(self[..<rangeOfWhereClause.lowerBound]).trimmingWhitespace()
        }
        return self
    }
}
