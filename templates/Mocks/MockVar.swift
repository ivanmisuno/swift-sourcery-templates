import Foundation
import SourceryRuntime

class MockVar {
    fileprivate let variable: SourceryRuntime.Variable

    fileprivate lazy var mockedVariableName = "\(variable.name)"

    init(variable: SourceryRuntime.Variable) {
        self.variable = variable
    }

    static func from(_ type: Type) -> [MockVar] {
        let allVariables = type.allVariables.filter { !$0.isStatic }.uniqueVariables
        return allVariables.map { MockVar(variable: $0) }
    }
}

extension MockVar {
    private var backingMockedVariableName: String { return "\(mockedVariableName)Backing" }

    private var needsBackingVariable: Bool {
        return variable.isMutable
            || variable.typeName.isOptional
            || !isComplexTypeWithSmartDefaultValue
    }

    private var isComplexTypeWithSmartDefaultValue: Bool {
        return !variable.isMutable
            && variable.typeName.isComplexTypeWithSmartDefaultValue
    }

    func mockImpl() throws -> [SourceCode] {
        var mockedVariableHandlers = TopScope()

        var getterImplementation = SourceCode("get")
        if variable.typeName.isOptional {
            getterImplementation += SourceCode("return \(mockedVariableName)GetHandler?() ?? \(backingMockedVariableName)")
            mockedVariableHandlers += "var \(mockedVariableName)GetHandler: (() -> \(variable.typeName))? = nil"
        } else {
            getterImplementation += SourceCode("if let handler = \(mockedVariableName)GetHandler") { [
                SourceCode("return handler()")
            ]}
            mockedVariableHandlers += "var \(mockedVariableName)GetHandler: (() -> \(variable.typeName))? = nil"

            if isComplexTypeWithSmartDefaultValue {
                let smartDefaultValueImplementation = try variable.typeName.smartDefaultValueImplementation(isProperty: true, mockVariablePrefix: mockedVariableName)
                getterImplementation += smartDefaultValueImplementation.getterImplementation
                mockedVariableHandlers += smartDefaultValueImplementation.mockedVariableHandlers
            } else {
                getterImplementation += SourceCode("if let value = \(backingMockedVariableName)") {[
                    SourceCode("return value")
                ]}

                if variable.typeName.hasDefaultValue, let defaultValue = try? variable.typeName.defaultValue() {
                    getterImplementation += SourceCode("return \(defaultValue)")
                } else {
                    getterImplementation += SourceCode("fatalError(\"Either `\(mockedVariableName)GetHandler` or value must be provided!\")")
                }
            }
        }

        var setterImplementation = SourceCode("set")
        if variable.isMutable {
            setterImplementation += "\(backingMockedVariableName) = newValue"
            setterImplementation += "\(mockedVariableName)SetCount += 1"
            setterImplementation += "\(mockedVariableName)SetHandler?(newValue)"

            mockedVariableHandlers += "var \(mockedVariableName)SetCount: Int = 0"
            mockedVariableHandlers += "var \(mockedVariableName)SetHandler: ((_ \(mockedVariableName): \(variable.typeName)) -> ())? = nil"
        }

        var mockedVariableImplementation = SourceCode("var \(variable.name): \(variable.typeName)")
        if !setterImplementation.nested.isEmpty {
            mockedVariableImplementation += getterImplementation
            mockedVariableImplementation += setterImplementation
        } else {
            mockedVariableImplementation += getterImplementation.nested
        }

        if needsBackingVariable {
            mockedVariableHandlers += "var \(backingMockedVariableName): \(variable.unwrappedTypeName)?"
        }

        var result = TopScope()
        result += mockedVariableImplementation
        result += mockedVariableHandlers.nested
        return result.nested
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
