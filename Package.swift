// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let shouldBuildForEmbedded = Context.environment["JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM"].flatMap(Bool.init) ?? false

let package = Package(
    name: "ExternalTermFormat",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ExternalTermFormat",
            targets: ["ExternalTermFormat"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ExternalTermFormat",
            cSettings: shouldBuildForEmbedded
                ? [
                    .unsafeFlags(["-fdeclspec"])
                ]
                : nil,
            swiftSettings: shouldBuildForEmbedded
                ? [
                    .enableExperimentalFeature("Embedded"),
                    .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"])
                ] : nil
        ),
        .testTarget(
            name: "ExternalTermFormatTests",
            dependencies: ["ExternalTermFormat"]
        ),
    ]
)
