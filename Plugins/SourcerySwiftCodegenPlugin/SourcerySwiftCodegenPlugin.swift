import Foundation
import PackagePlugin

protocol CodegenPluginContext {
  var rootDirectory: PackagePlugin.Path { get }
  var pluginWorkDirectory: PackagePlugin.Path { get }
  func tool(named name: String) throws -> PackagePlugin.PluginContext.Tool
  var environmentVars: [String: String] { get }
}

protocol CodegenPluginTarget {
  var name: String { get }
  func sourceryConfigFileLocations(rootDirectory: Path) -> Set<Path>
}

private func gitRootDirectory(_ path: Path) -> String {
  let task = Process()
  task.launchPath = "/usr/bin/env"
  task.currentDirectoryURL = URL(filePath: path.string)
  task.arguments = ["git", "rev-parse", "--show-toplevel"]

  let outputPipe = Pipe()
  let errorPipe = Pipe()
  task.standardOutput = outputPipe
  task.standardError = errorPipe
  let outHandle = outputPipe.fileHandleForReading
  let errorHandle = errorPipe.fileHandleForReading

  task.launch()

  let outputData = outHandle.readDataToEndOfFile()
  let errorData = errorHandle.readDataToEndOfFile()
  outHandle.closeFile()
  errorHandle.closeFile()

  task.waitUntilExit()

  let output = String(data: outputData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
  let error = String(data: errorData, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

  guard task.terminationStatus == 0 else {
    Diagnostics.warning("Error running git command: \(task.terminationStatus): \(error)")
    return ""
  }

  return output
}

private func locateSourceryExecutable(_ context: CodegenPluginContext) throws -> Path {
  let sourcery = try context.tool(named: "sourcery").path
  if sourcery.fileExists && !sourcery.isDirectory && sourcery.isExecutable {
    return sourcery
  }

  // If artifactsbundle is zipped incorrectly, the execuitable ends up one nesting level deeper than needed.
  let sourceryNestedDirectory = sourcery.appending("bin", "sourcery")
  if sourceryNestedDirectory.fileExists && !sourceryNestedDirectory.isDirectory && sourceryNestedDirectory.isExecutable {
    return sourceryNestedDirectory
  }

  throw "Could not locate Sourcery executable in the tool path \(sourcery)"
}

@main
struct SourcerySwiftCodegenPlugin {
  func _createBuildCommands(context: CodegenPluginContext, target: CodegenPluginTarget) throws -> [Command] {

    let sourcery = try locateSourceryExecutable(context)
    Diagnostics.remark("Sourcery executable: '\(sourcery)'")

    let sourceryConfigFileLocations = target.sourceryConfigFileLocations(rootDirectory: context.rootDirectory)
    let sourceryConfigFilePaths = sourceryConfigFileLocations.flatMap { location in
      do {
        let files = try FileManager.default.contentsOfDirectory(atPath: location.string)
        return files.filter { $0.matches(rgSourcery) }.map { location.appending($0) }
      } catch let e {
        Diagnostics.error("\(e)")
        return []
      }
    }
    Diagnostics.remark("Target \"\(target.name)\"\n - looking for Sourcery configs in: \(sourceryConfigFileLocations)\n - found configs: \(sourceryConfigFilePaths.map { $0.lastComponent })")

    // Write caches "SourceryCaches" subdirectory of the plugin work directory
    // (which is unique for each plugin and target).
    let perTargetCachesFilesDir = context.pluginWorkDirectory.appending(".sourceryCaches")
    try FileManager.default.createDirectory(atPath: perTargetCachesFilesDir.string, withIntermediateDirectories: true)

    // Per-target build directory
    // (which is unique for each plugin and target).
    let perTargetBuildDir = context.pluginWorkDirectory.appending(".sourceryBuild")
    try FileManager.default.createDirectory(atPath: perTargetBuildDir.string, withIntermediateDirectories: true)

    // Write generated files to the "GeneratedFiles" subdirectory of the plugin work directory
    // (which is unique for each plugin and target).
    let generatedFilesDir = context.pluginWorkDirectory.appending(".generatedFiles")
    try FileManager.default.createDirectory(atPath: generatedFilesDir.string, withIntermediateDirectories: true)

    let environmentVars = [
      "SOURCERY_OUTPUT_DIR": generatedFilesDir.string
    ].merging(context.environmentVars, uniquingKeysWith: { k, _ in k })

    return sourceryConfigFilePaths.map { configFilePath in
      let command = Self._createCommand(
        context: context,
        target: target,
        configFilePath: configFilePath,
        sourcery: sourcery,
        perTargetCachesFilesDir: perTargetCachesFilesDir,
        perTargetBuildDir: perTargetBuildDir,
        environmentVars: environmentVars,
        generatedFilesDir: generatedFilesDir)

      Diagnostics.remark("\(command)")

      return command
    }
  }

#if compiler(>=6.0)
  private static func _createCommand(
    context: CodegenPluginContext,
    target: CodegenPluginTarget,
    configFilePath: Path,
    sourcery: Path,
    perTargetCachesFilesDir: Path,
    perTargetBuildDir: Path,
    environmentVars: [String: String],
    generatedFilesDir: Path
  ) -> Command {
    Command.prebuildCommand(
      displayName: "Target \(target.name): running Sourcery with config: \(configFilePath.lastComponent)",
      executable: sourcery,
      arguments: [
        "--config",
        configFilePath.string,
        "--cacheBasePath",
        perTargetCachesFilesDir.string,
        "--buildPath",
        perTargetBuildDir.string,
        "--verbose",
      ],
      environment: environmentVars,
      outputFilesDirectory: generatedFilesDir
    )
  }
#else
  private static func _createCommand(
    context: CodegenPluginContext,
    target: CodegenPluginTarget,
    configFilePath: Path,
    sourcery: Path,
    perTargetCachesFilesDir: Path,
    perTargetBuildDir: Path,
    environmentVars: [String: String],
    generatedFilesDir: Path
  ) -> Command {
    Command._prebuildCommand(
      displayName: "Target \(target.name): running Sourcery with config: \(configFilePath.lastComponent)",
      executable: sourcery,
      arguments: [
        "--config",
        configFilePath.string,
        "--cacheBasePath",
        perTargetCachesFilesDir.string,
        "--buildPath",
        perTargetBuildDir.string,
        "--verbose",
      ],
      environment: environmentVars,
      workingDirectory: context.pluginWorkDirectory,
      outputFilesDirectory: generatedFilesDir
    )
  }
#endif
}

// MARK: - BuildToolPlugin

let rgSourcery = try! Regex("[^/:]*\\.sourcery([^/:]*)\\.yml$").ignoresCase()

func wrap(_ target: PackagePlugin.Target) -> TargetWrapper {
  TargetWrapper(target)
}

extension PackagePlugin.PluginContext: CodegenPluginContext {
  var rootDirectory: PackagePlugin.Path { `package`.directory }

  var environmentVars: [String : String] {
    let environmentVars =
    [
      "GIT_ROOT": gitRootDirectory(rootDirectory),
      "SOURCERY_PACKAGE": rootDirectory.string, // For SPM packages
    ].merging(`package`.targets.flatMap { t in
        [
          ("SOURCERY_TARGET_\(t.name)", t.directory.string)
        ] + t.dependencies.flatMap { (d: TargetDependency) in
          d.dependencyInfoArray.map {
            ("SOURCERY_TARGET_\(t.name)_DEP_\($0.0)", $0.1.string)
          }
        }
      }, uniquingKeysWith: { (a, _) in a })

    return environmentVars
  }
}

extension TargetDependency {
  var dependencyInfoArray: [(String, Path)] {
    switch self {
    case let .target(target):
      return [(target.name, target.directory)]

    case let .product(product):
      return product.sourceModules.map {
        ("\(product.name)_MODULE_\($0.moduleName)", $0.directory)
      } + product.targets.map {
        ("\(product.name)_TARGET_\($0.name)", $0.directory)
      }

    @unknown default:
      fatalError("Unknown TargetDependency value: \(self)")
    }
  }
}

struct TargetWrapper: CodegenPluginTarget {
  let wrapped: PackagePlugin.Target
  init(_ target: PackagePlugin.Target) { self.wrapped = target }

  var name: String { wrapped.name }
  func sourceryConfigFileLocations(rootDirectory: PackagePlugin.Path) -> Set<Path> {
    [wrapped.directory]
  }
}

extension SourcerySwiftCodegenPlugin: PackagePlugin.BuildToolPlugin {
  func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) throws -> [Command] {
    return try _createBuildCommands(context: context, target: wrap(target))
  }
}

// MARK: - XcodeProjectPlugin

#if canImport(XcodeProjectPlugin)

import XcodeProjectPlugin

extension XcodeProjectPlugin.XcodePluginContext: CodegenPluginContext {
  var rootDirectory: PackagePlugin.Path { xcodeProject.directory }

  var environmentVars: [String : String] {
    let environmentVars =
    [
      "GIT_ROOT": gitRootDirectory(rootDirectory),
      "SOURCERY_PROJECT": rootDirectory.string,
    ].merging(xcodeProject.targets.flatMap { t in
      // Diagnostics.warning("### Target '\(t.name)' dependencies: \(t.dependencies)")
      return t.dependencies.flatMap { (d: XcodeTargetDependency) in
        d.dependencyInfoArray.map {
          ("SOURCERY_TARGET_\(t.name)_DEP_\($0.0)", $0.1.string)
        }
      }
    }, uniquingKeysWith: { (a, _) in a })

    return environmentVars
  }
}

extension XcodeTargetDependency {
  var dependencyInfoArray: [(String, Path)] {
    switch self {
    case .target(_):
      // Diagnostics.warning("### Dependency target: \(target.name)")
      return []

    case let .product(product):
      // Diagnostics.warning("### Dependency product: \(product.name)")
      return product.sourceModules.map {
        ("\(product.name)_MODULE_\($0.moduleName)", $0.directory)
      } + product.targets.map {
        ("\(product.name)_TARGET_\($0.name)", $0.directory)
      }

    @unknown default:
      fatalError("Unknown TargetDependency value: \(self)")
    }
  }
}

extension XcodeProjectPlugin.XcodeTarget: CodegenPluginTarget {
  var name: String { displayName }
  func sourceryConfigFileLocations(rootDirectory: PackagePlugin.Path) -> Set<Path> {
    let rootDirectoryComponents = rootDirectory.components
    // return one level deep locations relative to the rootDirectory
    let inputLocations = Set(inputFiles.map { $0.path.removingLastComponent() })
    return Set(inputLocations.flatMap { path -> [Path] in
      let components = path.components
      guard components.starts(with: rootDirectoryComponents) else {
        return []
      }

      var res: [Path] = []
      if components.count > rootDirectoryComponents.count {
        res.append(rootDirectory.appending(components[rootDirectoryComponents.count]))
      }
      return res
    })
  }
}

extension PackagePlugin.Path {
  var components: [String] {
    let prev = removingLastComponent()
    guard !prev.string.isEmpty && prev.string != "/" else { return [lastComponent] }
    return prev.components + [lastComponent]
  }
}

extension SourcerySwiftCodegenPlugin: XcodeBuildToolPlugin {
  func createBuildCommands(context: XcodeProjectPlugin.XcodePluginContext, target: XcodeProjectPlugin.XcodeTarget) throws -> [Command] {
    return try _createBuildCommands(context: context, target: target)
  }
}

#endif

// MARK: - Internal

extension String {
  func matches(_ regex: Regex<AnyRegexOutput>) -> Bool {
    guard let m = wholeMatch(of: regex) else { return false }
    return !m.isEmpty
  }
}

extension String: LocalizedError {
}

extension Path {
  var fileExists: Bool {
    FileManager.default.fileExists(atPath: string)
  }

  var isDirectory: Bool {
    var result: ObjCBool = false
    FileManager.default.fileExists(atPath: string, isDirectory: &result)
    return result.boolValue
  }

  var isExecutable: Bool {
    FileManager.default.isExecutableFile(atPath: string)
  }
}
