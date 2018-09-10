import Foundation
import SourceryRuntime

class MockMethod {
    static func from(_ type: Type) -> [MockMethod] {
        //let uniqueMethods = type.allMethods.filter { !$0.isStatic }
        //return allVariables.map { MockVar(variable: $0) }

        return []
    }

/*
    func swiftifyMethodName(_ name: String) -> String {
        let swiftifiedName = name
            .replacingOccurrences(of: "(", with: "_")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: ":", with: "_")
            .replacingOccurrences(of: "`", with: "")
        let camelCasedName = snakeToCamelCase(swiftifiedName)
        let lowercasedFirstWordName = lowerFirstWord(camelCasedName)
        return lowercasedFirstWordName
    }
    func uniques(methods: [SourceryRuntime.Method]) -> [SourceryRuntime.Method] {
        func returnTypeStripped(_ method: SourceryRuntime.Method) -> String {
            let returnTypeRaw = "\(method.returnTypeName)"
            var stripped: String = {
                guard let range = returnTypeRaw.range(of: "where") else { return returnTypeRaw }
                var stripped = returnTypeRaw
                stripped.removeSubrange((range.lowerBound)...)
                return stripped
            }()
            stripped = stripped.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            return stripped
        }

        func areSameParams(_ p1: SourceryRuntime.MethodParameter, _ p2: SourceryRuntime.MethodParameter) -> Bool {
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.name == p2.name else { return false }
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.typeName.name == p2.typeName.name else { return false }
            guard p1.actualTypeName?.name == p2.actualTypeName?.name else { return false }
            return true
        }

        func areSameMethods(_ m1: SourceryRuntime.Method, _ m2: SourceryRuntime.Method) -> Bool {
            guard m1.name != m2.name else { return m1.returnTypeName == m2.returnTypeName }
            guard m1.selectorName == m2.selectorName else { return false }
            guard m1.parameters.count == m2.parameters.count else { return false }

            let p1 = m1.parameters
            let p2 = m2.parameters

            for i in 0..<p1.count {
                if !areSameParams(p1[i],p2[i]) { return false }
            }

            return m1.returnTypeName == m2.returnTypeName
        }

        return methods.reduce([], { (result, element) -> [SourceryRuntime.Method] in
            guard !result.contains(where: { areSameMethods($0,element) }) else { return result }
            return result + [element]
        })
    }

    func uniquesWithoutGenericConstraints(methods: [SourceryRuntime.Method]) -> [SourceryRuntime.Method] {
        func returnTypeStripped(_ method: SourceryRuntime.Method) -> String {
            let returnTypeRaw = "\(method.returnTypeName)"
            var stripped: String = {
                guard let range = returnTypeRaw.range(of: "where") else { return returnTypeRaw }
                var stripped = returnTypeRaw
                stripped.removeSubrange((range.lowerBound)...)
                return stripped
            }()
            stripped = stripped.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            return stripped
        }

        func areSameParams(_ p1: SourceryRuntime.MethodParameter, _ p2: SourceryRuntime.MethodParameter) -> Bool {
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.name == p2.name else { return false }
            guard p1.argumentLabel == p2.argumentLabel else { return false }
            guard p1.typeName.name == p2.typeName.name else { return false }
            guard p1.actualTypeName?.name == p2.actualTypeName?.name else { return false }
            return true
        }

        func areSameMethods(_ m1: SourceryRuntime.Method, _ m2: SourceryRuntime.Method) -> Bool {
            guard m1.name != m2.name else { return returnTypeStripped(m1) == returnTypeStripped(m2) }
            guard m1.selectorName == m2.selectorName else { return false }
            guard m1.parameters.count == m2.parameters.count else { return false }

            let p1 = m1.parameters
            let p2 = m2.parameters

            for i in 0..<p1.count {
                if !areSameParams(p1[i],p2[i]) { return false }
            }

            return returnTypeStripped(m1) == returnTypeStripped(m2)
        }

        return methods.reduce([], { (result, element) -> [SourceryRuntime.Method] in
            guard !result.contains(where: { areSameMethods($0,element) }) else { return result }
            return result + [element]
        })
    }

    func methodThrowableErrorDeclaration(_ method: SourceryRuntime.Method) -> String {
        return "var \(swiftifyMethodName(method.selectorName))ThrowableError: Error?"
    }
    func methodThrowableErrorUsage(_ method: SourceryRuntime.Method) -> String {
        return """
            if let error = \(methodThrowableErrorDeclaration(method))ThrowableError {
                throw error
            }
        """
    }
    func methodHandlerName(_ method: SourceryRuntime.Method) -> String {
        return "\(swiftifyMethodName(method.callName))Handler"
    }
    func methodHandlerDeclaration(_ method: SourceryRuntime.Method) -> String {
        let parameters = method.parameters.map {
            if let argumentLabel = $0.argumentLabel {
                return "_ \($0.name): \($0.typeName.name)"
            } else {
                return $0.typeName.name
            }
        }.joined(separator: ", ")
        let throwing = method.throws ? " throws" : ""
        let returnType = method.isInitializer ? "()" : method.returnTypeName.name
        return "var \(methodHandlerName(method)): ((\(parameters))\(throwing) -> \(returnType))? = nil"
    }
    func methodHandlerCallParameters(_ method: SourceryRuntime.Method) -> String {
        return method.parameters.map { $0.name }.joined(separator: ", ")
    }
    func mockMethod(_ method: SourceryRuntime.Method) -> String {
        return """
            // MARK: - \(method.name)
            \(methodHandlerDeclaration(method))

        """
    }
*/
}
