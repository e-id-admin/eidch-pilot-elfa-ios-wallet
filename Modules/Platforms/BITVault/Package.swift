// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BITVault",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v15),
  ],
  products: [
    .library(
      name: "BITVault",
      targets: ["BITVault"]),
  ],
  dependencies: [
    .package(url: "https://github.com/Matejkob/swift-spyable", revision: "8f78f36989bde9f06cc5a5254a6748c23c16b045"),
    .package(path: "../../Platforms/BITLocalAuthentication"),
  ],
  targets: [
    .target(
      name: "BITVault",
      dependencies: [
        .product(name: "Spyable", package: "swift-spyable"),
        .product(name: "BITLocalAuthentication", package: "BITLocalAuthentication"),
      ]),
    .testTarget(
      name: "BITVaultTests",
      dependencies: ["BITVault"]),
  ])
