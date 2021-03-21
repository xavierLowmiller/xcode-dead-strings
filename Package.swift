// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DeadStrings",
    products: [
        .executable(name: "dead-strings", targets: ["DeadStringsExecutable"]),
        .library(name: "DeadStrings", targets: ["DeadStrings"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .target(name: "DeadStrings"),
        .target(
            name: "DeadStringsExecutable",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "DeadStrings"
            ]),
        .testTarget(
            name: "DeadStringsTests",
            dependencies: ["DeadStrings"]),
    ]
)
