// swift-tools-version: 5.8
import PackageDescription

let package = Package(
  name: "BITCore",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITCore",
      targets: ["BITCore"]),
    .library(
      name: "BITTestingCore",
      targets: ["BITTestingCore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(url: "https://github.com/Flight-School/AnyCodable", exact: "0.6.7"),
  ],
  targets: [
    .target(
      name: "BITCore",
      dependencies: [
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "Factory", package: "Factory"),
        .product(name: "AnyCodable", package: "AnyCodable"),
      ],
      resources: [
        .process("Resources"),
      ]),
    .target(
      name: "BITTestingCore",
      dependencies: ["BITCore"]),
    .testTarget(
      name: "BITCoreTests",
      dependencies: ["BITCore", "BITTestingCore"]),
  ])
