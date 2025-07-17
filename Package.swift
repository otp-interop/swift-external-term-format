// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExternalTermFormat",
    platforms: [.macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ExternalTermFormat",
            targets: [
                "ExternalTermFormat"
            ]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-binary-parsing.git", branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ExternalTermFormat",
            dependencies: [.product(name: "BinaryParsing", package: "swift-binary-parsing")],
            swiftSettings: [
                .enableExperimentalFeature("Span"),
                .enableExperimentalFeature("ValueGenerics"),
                .enableExperimentalFeature("LifetimeDependence"),
            ]
        ),
        .executableTarget(
            name: "ExternalTermFormatBenchmarks",
            dependencies: ["ExternalTermFormat"]
        ),
        .testTarget(
            name: "ExternalTermFormatTests",
            dependencies: [.target(name: "ExternalTermFormat")],
            swiftSettings: [
                .enableExperimentalFeature("Span"),
                .enableExperimentalFeature("ValueGenerics"),
                .enableExperimentalFeature("LifetimeDependence"),
            ]
        ),
    ]
)
