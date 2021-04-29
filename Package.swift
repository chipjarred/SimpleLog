// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SimpleLog",
    platforms: [.macOS(.v10_15), .iOS(.v14)],
    products: [ .library(name: "SimpleLog", targets: ["SimpleLog"]) ],
    dependencies:
    [
        .package(url: "https://github.com/chipjarred/NIX.git", .branch("main")),
    ],
    targets:
    [
        .target(
            name: "SimpleLog",
            dependencies: ["NIX"]),
        .testTarget(
            name: "SimpleLogTests",
            dependencies: ["SimpleLog"]),
    ]
)
