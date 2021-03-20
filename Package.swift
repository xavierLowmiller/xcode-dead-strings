// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "DeadStrings",
//    products: [
//        .executable(name: "DadStrings", targets: ["DeadStrings"]),
//        .library(name: "DeadStrings", targets: ["DeadStrings"])
//    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "DeadStrings",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]),
        .testTarget(
            name: "DeadStringsTests",
            dependencies: ["DeadStrings"]),
    ]
)
