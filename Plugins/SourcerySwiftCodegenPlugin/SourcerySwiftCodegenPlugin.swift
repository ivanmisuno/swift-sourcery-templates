import Foundation
import PackagePlugin

@main
struct SourcerySwiftCodegenPlugin: BuildToolPlugin {

  private func locateSourceryExecutable(context: PluginContext) throws -> Path {
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

  private func gitRootDirectory(packageDirectory path: Path) -> String {
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

    Diagnostics.remark("GIT_ROOT=\(output)")
    return output
  }

  func createBuildCommands(context: PluginContext, target: Target) throws -> [Command] {

    let sourcery = try locateSourceryExecutable(context: context)
    Diagnostics.remark("Sourcery executable: '\(sourcery)'")

    let targetDirectory = target.directory
    Diagnostics.remark("Target \"\(target.name)\": processing target directory (\(targetDirectory))")

    let rgSourcery = try! Regex("[^/:]*\\.sourcery([^/:]*)\\.yml$").ignoresCase()

    do {
      let files = try FileManager.default.contentsOfDirectory(atPath: targetDirectory.string)
      let matchingFiles = files.filter { $0.matches(rgSourcery) }
      guard !matchingFiles.isEmpty else {
        return []
      }

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
        "GIT_ROOT": gitRootDirectory(packageDirectory: context.package.directory),
        "SOURCERY_PACKAGE": context.package.directory.string,
        "SOURCERY_OUTPUT_DIR": generatedFilesDir.string,
      ].merging(context.package.targets.flatMap { t in
        [
          ("SOURCERY_TARGET_\(t.name)", t.directory.string)
        ] + t.dependencies.flatMap { (d: TargetDependency) in
          d.dependencyInfoArray.map {
            ("SOURCERY_TARGET_\(t.name)_DEP_\($0.0)", $0.1.string)
          }
        }
      }, uniquingKeysWith: { (a, _) in a })

      return matchingFiles.map { configFileName in
        let configFilePath = target.directory.appending(configFileName)
        let command = Command._prebuildCommand(
          displayName: "Target \(target.name): running Sourcery with config: \(configFileName)",
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

        Diagnostics.remark("\(command)")

        return command
      }

    } catch let e {
      Diagnostics.error("Error: \(e)")
      return []
    }
  }
}

extension String {
  func matches(_ regex: Regex<AnyRegexOutput>) -> Bool {
    guard let m = wholeMatch(of: regex) else { return false }
    return !m.isEmpty
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
