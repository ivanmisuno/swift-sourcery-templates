import Foundation
import SourceryRuntime

class MockVar {
    let variable: SourceryRuntime.Variable

    var mockedVariableName: String {
        return "\(variable.name)"
    }

    init(variable: SourceryRuntime.Variable) {
        self.variable = variable
    }

    static func from(_ type: Type) -> [MockVar] {
        let allVariables = type.allVariables.filter { !$0.isStatic && $0.definedInType != nil && $0.definedInType?.isExtension == false }.uniqueVariables
        return allVariables.map { MockVar(variable: $0) }.sorted { $0.mockedVariableName < $1.mockedVariableName }
    }
}

extension MockVar {

    // Does this variable require init()?
    var provideValueInInitializer: Bool {
        return !variable.typeName.hasComplexTypeWithSmartDefaultValue(isProperty: true)
            && (variable.isAnnotatedInit || !variable.typeName.hasDefaultValue)
            && !variable.isAnnotatedHandler
    }

    func mockImpl() throws -> [SourceCode] {
        let mockedVariableImplementation: SourceCode
        let mockedVariableHandlers = TopScope()

        if !variable.isMutable,
            variable.typeName.hasComplexTypeWithSmartDefaultValue(isProperty: true),
            let smartDefaultValueImplementation = try? variable.typeName.smartDefaultValueImplementation(isProperty: true, mockVariablePrefix: mockedVariableName) {

            mockedVariableImplementation = SourceCode("var \(variable.name): \(variable.typeName)") {[
                SourceCode("\(mockedVariableName)GetCount += 1"),
                SourceCode("if let handler = \(mockedVariableName)GetHandler") {[
                    SourceCode("return handler()")
                ]},
                smartDefaultValueImplementation.getterImplementation
            ]}
            mockedVariableHandlers += "var \(mockedVariableName)GetCount: Int = 0"
            mockedVariableHandlers += "var \(mockedVariableName)GetHandler: (() -> \(variable.typeName))? = nil"
            mockedVariableHandlers += smartDefaultValueImplementation.mockedVariableHandlers
        } else {
            let variableDecl = !variable.isMutable && variable.isAnnotatedConst ? "let" : "var"
            if variable.isAnnotatedHandler {
                // Value should be implemented with the `get` handler
                var getterImplementation: [SourceCode] = [
                    SourceCode("\(mockedVariableName)GetCount += 1"),
                    SourceCode("if let handler = \(mockedVariableName)GetHandler") {[
                        SourceCode("return handler()")
                    ]},
                    SourceCode("fatalError(\"`\(mockedVariableName)GetHandler` must be set!\")")
                ]
                if variable.isMutable {
                    mockedVariableImplementation = SourceCode("var \(variable.name): \(variable.typeName)") {[
                        SourceCode("get", nested: getterImplementation)
                    ]}
                } else {
                    mockedVariableImplementation = SourceCode("var \(variable.name): \(variable.typeName)", nested: getterImplementation)
                }
                mockedVariableHandlers += "var \(mockedVariableName)GetCount: Int = 0"
                mockedVariableHandlers += "var \(mockedVariableName)GetHandler: (() -> \(variable.typeName))? = nil"
            } else if !variable.isAnnotatedInit, variable.typeName.hasDefaultValue, let defaultValue = try? variable.typeName.defaultValue() {
                // Default value can be guessed.
                mockedVariableImplementation = SourceCode("\(variableDecl) \(variable.name): \(variable.typeName) = \(defaultValue)")
            } else {
                // No default value, the value must be provided to the mock class's initializer.
                mockedVariableImplementation = SourceCode("\(variableDecl) \(variable.name): \(variable.typeName)")
            }
            if variable.isMutable {
                mockedVariableImplementation += SourceCode(variable.isAnnotatedHandler ? "set" : "didSet") {[
                    SourceCode("\(mockedVariableName)SetCount += 1")
                ]}
                mockedVariableHandlers += "var \(mockedVariableName)SetCount: Int = 0"
            }
        }
        var topScope = TopScope()
        topScope += mockedVariableImplementation
        topScope += mockedVariableHandlers.nested
        return topScope.nested
    }
}

private extension Collection where Element: SourceryRuntime.Variable {
    var uniqueVariables: [SourceryRuntime.Variable] {
        return reduce(into: [], { (result, element) in
            guard !result.contains(where: { $0.name == element.name }) else { return }
            result.append(element)
        })
    }
}
