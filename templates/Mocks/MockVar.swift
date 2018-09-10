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
            || !isComplexTypeWithSmartDefaultValueImplementation
    }

    private var isComplexTypeWithSmartDefaultValueImplementation: Bool {
        return !variable.isMutable
            && variable.typeName.isComplexTypeWithSmartDefaultValueImplementation
    }

    var mockImpl: [SourceCode] {
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

            if isComplexTypeWithSmartDefaultValueImplementation, let smartDefaultValueImplementation = variable.typeName.smartDefaultValueImplementation(mockedVariableName) {
                getterImplementation += smartDefaultValueImplementation.getterImplementation
                mockedVariableHandlers += smartDefaultValueImplementation.mockedVariableHandlers
            } else {
                getterImplementation += SourceCode("if let value = \(backingMockedVariableName)") {[
                    SourceCode("return value")
                ]}

                if let defaultValue = try? variable.typeName.defaultValue() {
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

private extension SourceryRuntime.TypeName {
    var isComplexTypeWithSmartDefaultValueImplementation: Bool {
        guard
            isGeneric,
            let generic = generic,
            generic.name == "Observable" || generic.name == "AnyObserver",
            generic.typeParameters.count == 1
        else {
            return false
        }
        return true
    }

    var smartDefaultValueImplementation: ((String) -> (getterImplementation: SourceCode, mockedVariableHandlers: [SourceCode])?) {
        return { mockedVariableName in
            guard self.isComplexTypeWithSmartDefaultValueImplementation, let generic = self.generic else { return nil }
            switch generic.name {
            case "Observable":
                let getterImplementation = SourceCode("return \(mockedVariableName)Subject.asObservable()")
                let mockedVariableHandlers = [SourceCode("lazy var \(mockedVariableName)Subject = PublishSubject<\(generic.typeParameters[0].typeName.name)>()")]
                return (getterImplementation, mockedVariableHandlers)
            case "AnyObserver":
                let getterImplementation = SourceCode("return AnyObserver { [weak self] event in") { [
                    SourceCode("self?.\(mockedVariableName)CallCount += 1"),
                    SourceCode("self?.\(mockedVariableName)EventHandler?(event)"),
                ]}
                let mockedVariableHandlers = [SourceCode("var \(mockedVariableName)CallCount: Int = 0"),
                                              SourceCode("var \(mockedVariableName)EventHandler = ((Event<\(generic.typeParameters[0].typeName.name)>) -> ())? = nil")]
                return (getterImplementation, mockedVariableHandlers)
            default:
                fatalError("Should not get here.")
            }
        }
    }
}
