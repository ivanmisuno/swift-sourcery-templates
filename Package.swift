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
      url: "https://github.com/krzysztofzablocki/Sourcery/releases/download/2.2.6/sourcery-2.2.6.artifactbundle.zip",
      checksum: "00ddb01d968cf5a1b9971a997f362553b2cf57ccdd437e7ecde9c7891ee9e4c1"
    ),
    .plugin(
      name: "SourcerySwiftCodegenPlugin",
      capability: .buildTool,
      dependencies: ["sourcery"]
    ),
  ]
)
