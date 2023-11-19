# swift-sourcery-templates

Advanced Protocol Mock and Type Erasure Code-generation templates for Swift language (using Sourcery).

This repository contains two code-generation templates (to be used along with [Sourcery](https://github.com/krzysztofzablocki/Sourcery) engine):

1. `Mocks.swifttemplate` — to generate advanced protocol mock classes that can be used as [test doubles](https://martinfowler.com/bliki/TestDouble.html) in place of object dependencies for unit-testing;
2. `TypeErase.swifttemplate` — to generate advanced [type erasures](https://www.bignerdranch.com/blog/breaking-down-type-erasure-in-swift/).

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

### Swift Package Manager (SPM) prebuild plugin

A [prebuild SPM plugin](https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md#build-tool-plugins)
runs before the project is built, allowing to generate code based on the project source files.

1. To add the plugin to your project, add the plugin dependency to your `Package.swift`:

```swift
// Package.swift
// swift-tools-version: 5.9 // The minimum supported swift-tools version is 5.6
import PackageDescription

let package = Package(
  name: "YourPackageName",
  products: [
    // ...
  ],
  dependencies: [
    // ...
    .package(url: "https://github.com/ivanmisuno/swift-sourcery-templates.git", from: "0.2.2"),
  ],
  targets: [
    .target(
      name: "YourTarget",
      dependencies: [
        // ...
      ],
      plugins: [
        .plugin(name: "SourcerySwiftCodegenPlugin", package: "swift-sourcery-templates")
      ]
    ),
    .testTarget(
      name: "YourTargetTests",
      dependencies: [
        // ...
        .target(name: "ExampleProjectSpm"),
      ],
      plugins: [
        .plugin(name: "SourcerySwiftCodegenPlugin", package: "swift-sourcery-templates")
      ]
    ),
  ]
)
```

The `SourcerySwiftCodegenPlugin` depends on the binary distribution of the Sourcery CLI.
The first time it is invoked, Xcode/build system would ask for a permission to run the plugin.

You might also get an unverified developer warning when the plugin tries to invoke Sourcery for the first time.
To fix it, please use the [woraround](https://github.com/krzysztofzablocki/Sourcery/#issues) for removing Sourcery from quarantine:

```
xattr -dr com.apple.quarantine <...Derived Data Folder>/SourcePackages/checkouts/swift-sourcery-templates/Plugins/Sourcery/sourcery.artifactbundle/sourcery/bin/sourcery
```

2. Configuring code generation

The codegeneration is configured per target in an SPM project. Put a `*.sourcery.yml` config file in the target's source folder
(refer to the [example project](Examples/ExampleProjectSpm/)):

<img src="/docs/img/sourcery_target_config.png" alt="Sourcery config files per target" style="height: 332px;"/>

Here, `ExampleProjectSpm` and `ExampleProjectSpmTests` are product targets, for which we want to enable code generation.
We want to generate type erasures and interface mocks. Type erasure classes should be available for use in the main target,
while mocks should be available in the test target.

Here is caveat: Some mock classes should be generated for interfaces that are declared in external packages (e.g. for the `RIBs` package).
We need to (a) include the external package sources in the config file:

```
# .Sourcery.Mocks.yml
sources:
  - ${SOURCERY_TARGET_ExampleProjectSpm}
  - ${SOURCERY_TARGET_ExampleProjectSpmTests}/SourceryAnnotations
  - ${SOURCERY_TARGET_ExampleProjectSpm_DEP_RIBs_MODULE_RIBs}
```

We're doing a little trickery here to work around an issue with Sourcery — when invoked from a build tool SPM plugin,
Sourcery cannot analyze the package structure, so the plugin exports the package structure via environment variables.
In the excample above:

- `SOURCERY_TARGET_ExampleProjectSpm` refers to the `ExampleProjectSpm` target source location;
- `SOURCERY_TARGET_ExampleProjectSpmTests` refers to the `ExampleProjectSpmTests` target source location;
- `SOURCERY_TARGET_ExampleProjectSpm_DEP_RIBs_MODULE_RIBs` refers to the `RIBs` module source location (`RIBs` is the dependency of the `ExampleProjectSpm` target).

The plugin exports all package dependencies' source locations via environment variable similarly:

- `SOURCERY_TARGET_<target_name>_DEP_<dependecy_module>_MODULE_RIBs`
- `SOURCERY_TARGET_<target_name>_DEP_<dependecy_target>_TARGET_RIBs`

> [!NOTE]
> For the complete Sourcery config file reference, please refer to the [official documentation](https://krzysztofzablocki.github.io/Sourcery/).

3. Finding the generated files

The above might seem tricky at first. The plugin helps debug setup issues by emitting invocation and debug logs to the build log:

<img src="/docs/img/command_invocation_log.png" alt="Command invocation log" style="height: 260px;"/>

The invocation log also contains all exported environment variables for the dependencies.

### Podfile

_Following examples refer to the [tutorial project](https://github.com/ivanmisuno/Tutorial_RIBs_CodeGeneration) (WIP),
please feel free to clone and see its workings. Accompanying blog post is coming._

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
   output: Tutorial_RIBs_CodeGenerationTests/Mocks
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
