// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITDataStore",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITDataStore",
      targets: ["BITDataStore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/hmlongco/Factory", exact: "2.2.0"),
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
  ],
  targets: [
    .target(
      name: "BITDataStore",
      dependencies: [
        .product(name: "Factory", package: "Factory"),
        .product(name: "Spyable", package: "swift-spyable"),
      ],
      resources: [.process("CoreData/Resources")]),
    .testTarget(
      name: "BITDataStoreTests",
      dependencies: ["BITDataStore"]),
  ])
