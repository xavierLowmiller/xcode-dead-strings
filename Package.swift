// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "XcodeDeadStrings",
    platforms: [.macOS(.v10_13)],
    products: [
        .executable(name: "xcode-dead-strings", targets: ["XcodeDeadStringsExecutable"]),
        .library(name: "XcodeDeadStrings", targets: ["XcodeDeadStrings"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .target(name: "XcodeDeadStrings"),
        .target(
            name: "XcodeDeadStringsExecutable",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "XcodeDeadStrings"
            ]),
        .testTarget(
            name: "XcodeDeadStringsTests",
            dependencies: ["XcodeDeadStrings"]),
    ]
)
