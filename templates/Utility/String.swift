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

    // Courtesy https://github.com/krzysztofzablocki/Sourcery

    /// :nodoc:
    /// Returns components separated with a comma respecting nested types
    func commaSeparated() -> [String] {
        return components(separatedBy: ",", excludingDelimiterBetween: ("<[({", "})]>"))
    }

    /// :nodoc:
    /// Returns components separated with colon respecting nested types
    func colonSeparated() -> [String] {
        return components(separatedBy: ":", excludingDelimiterBetween: ("<[({", "})]>"))
    }

    /// :nodoc:
    /// Returns components separated with semicolon respecting nested contexts
    func semicolonSeparated() -> [String] {
        return components(separatedBy: ";", excludingDelimiterBetween: ("{", "}"))
    }

    /// :nodoc:
    func components(separatedBy delimiter: String, excludingDelimiterBetween between: (open: String, close: String)) -> [String] {
        var boundingCharactersCount: Int = 0
        var quotesCount: Int = 0
        var item = ""
        var items = [String]()
        var matchedDelimiter = (alreadyMatched: "", leftToMatch: delimiter)

        for char in self {
            if between.open.contains(char) {
                if !(boundingCharactersCount == 0 && String(char) == delimiter) {
                    boundingCharactersCount += 1
                }
            } else if between.close.contains(char) {
                // do not count `->`
                if !(char == ">" && item.last == "-") {
                    boundingCharactersCount = max(0, boundingCharactersCount - 1)
                }
            }
            if char == "\"" {
                quotesCount += 1
            }

            guard boundingCharactersCount == 0 && quotesCount % 2 == 0 else {
                item.append(char)
                continue
            }

            if char == matchedDelimiter.leftToMatch.first {
                matchedDelimiter.alreadyMatched.append(char)
                matchedDelimiter.leftToMatch = String(matchedDelimiter.leftToMatch.dropFirst())
                if matchedDelimiter.leftToMatch.isEmpty {
                    items.append(item)
                    item = ""
                    matchedDelimiter = (alreadyMatched: "", leftToMatch: delimiter)
                }
            } else {
                if matchedDelimiter.alreadyMatched.isEmpty {
                    item.append(char)
                } else {
                    item.append(matchedDelimiter.alreadyMatched)
                    matchedDelimiter = (alreadyMatched: "", leftToMatch: delimiter)
                }
            }
        }
        items.append(item)
        return items
    }
}
