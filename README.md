# swift-sourcery-templates (Beta)

Advanced Protocol Mock and Type Erasure Code-generation templates for Swift language.

This repository contains two code-generation templates (to be used along with [Sourcery](https://github.com/krzysztofzablocki/Sourcery) engine):
1. `Mocks.swifttemplate` — to generate advanced protocol mock classes that can be used as [test doubles](https://martinfowler.com/bliki/TestDouble.html) in place of object dependencies for unit-testing;
2. `TypeErase.swifttemplate` — to generate advanced [type erasures](https://www.bignerdranch.com/blog/breaking-down-type-erasures-in-swift/).

Both templates support protocols with associated types and generic functions (with constraints on generic types),
provide reasonable default values for primitive types, and support advanced types and use cases typically found in projects
that use [RxSwift](https://github.com/ReactiveX/RxSwift), and, in particular, User's [RIBs](https://github.com/uber/RIBs) frameworks.

## Rationale

Code-generation is an extremely powerful technique to improve the developer team's productivity by eliminating time-consuming
manual tasks, and ensuring consistency between different parts of the codebase. Typical examples include generating API wrappers
for database and network services, data structure representations as native types in a specific programming language, generating
test doubles and mocks for unit-testing, etc.

Due to Swift language's static nature and a (very) limited runtime reflection capabilities, it's arguably [the only modern language
with no mocking framework](https://blog.pragmaticengineer.com/swift-the-only-modern-language-with-no-mocking-framework/),
which makes it hard for development teams to apply patterns typical for more dynamic languages when writing unit-tests.

The common approach to improving developer's productivity has been to write tools that parse the source code of the program,
and automatically generate mock class definitions that can be later used in place of actual object's dependencies in unit tests,
to be able to instantiate the object in isolation from the rest of the system and test its behavior by analyzing side effects it
performs on dependencies. There are tools like [Sourcery](https://github.com/krzysztofzablocki/Sourcery),
[SwiftyMocky](https://github.com/MakeAWishFoundation/SwiftyMocky), [Cuckoo](https://github.com/Brightify/Cuckoo),
there's even a [plug-in](https://plugins.jetbrains.com/plugin/9601-swift-mock-generator-for-appcode) for the JetBrain's AppCode.
These tools and plug-ins are capable of auto-generating mock class definitions based on reading source type declarations,
however, I was personally struggling to find a comprehensive solution so far, that would cover some advanced coding patterns,
in particular, typical for programs that combine `RxSwift` and Uber's `RIBs` frameworks.


## Usage

_Following examples refer to the [tutorial project](https://github.com/ivanmisuno/Tutorial_RIBs_CodeGeneration) (WIP),
please feel free to clone and see its workings. Accompanying blog post is coming._

* Podfile

1. Add `SwiftMockTemplates` Pod to your projects's Test target:
    ```Podfile
    pod 'SwiftMockTemplates', :git => 'https://github.com/ivanmisuno/swift-sourcery-templates.git', :tag => '0.1.0'
    ```
    (I'll release it as a public Podspec once I complete unit-tests).

2. Add `.sourcery-mocks.yml` config file to the project's root:
    ```yml
    sources:
      - Tutorial_RIBs_CodeGeneration
      - Tutorial_RIBs_CodeGenerationTests/Mocks/AnnotatedRIBsProtocols.swift
      - Pods/RIBs
    templates:
      - Pods/SwiftMockTemplates/templates/Mocks.swifttemplate
    output:
      Tutorial_RIBs_CodeGenerationTests/Mocks
    args:
      testable:
        - Tutorial_RIBs_CodeGeneration
      import:
        - RIBs
        - RxSwift
        - RxTest
      excludedSwiftLintRules:
        - force_cast
        - function_body_length
        - line_length
        - vertical_whitespace
    ```

3. Add `codegen.sh` script that will run `Sourcery` with the above config file:
    ```sh
    #!/bin/bash

    # the directory of the script. all locations are relative to the $DIR
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    PARENT_DIR="$DIR/.."

    SOURCERY_DIR="$PARENT_DIR/Pods/Sourcery"
    SOURCERY="$SOURCERY_DIR/bin/sourcery"

    "$SOURCERY" --config "$PARENT_DIR"/.sourcery-mocks.yml $1 $2
    ```
    Note that `sourcery` executable is installed in `Pods` folder.

4. Annotate protocols in your code for which you'd like to generate mock classes with the following annotation:
    ```Swift
    /// sourcery: CreateMock
    ```
    There are more advanced use cases, the documentation is coming.

5. Run following command to generate mock classes:
    ```sh
    scripts $ ./codegen.sh [--disableCache]
    ```
    This command will generate `Mocks.generated.swift` file in the `output` folder as specified in the config file.

6. Add the generated file to the test target in the Xcode project.


# License

    Copyright 2018 Ivan Misuno

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
