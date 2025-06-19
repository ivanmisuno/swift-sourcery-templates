// swift-tools-version:5.9
import PackageDescription

let package = Package(
  name: "SourcerySwiftCodegen",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    .plugin(name: "SourcerySwiftCodegenPlugin", targets: ["SourcerySwiftCodegenPlugin"])
  ],
  targets: [
    .binaryTarget(
      name: "sourcery",
      url: "https://github.com/krzysztofzablocki/Sourcery/releases/download/2.2.7/sourcery-2.2.7.artifactbundle.zip",
      checksum: "33f4590a657cc3d6631d81cd557b9ac47594e709623f3e61baa254334e950da6"
    ),
    .plugin(
      name: "SourcerySwiftCodegenPlugin",
      capability: .buildTool,
      dependencies: ["sourcery"]
    ),
  ]
)
