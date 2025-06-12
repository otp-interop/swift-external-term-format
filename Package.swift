// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ExternalTermFormat",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ExternalTermFormat",
            targets: [
                "ExternalTermFormat"
            ]),
    ],
    traits: ["Embedded"],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ExternalTermFormat",
            cSettings: [
                .unsafeFlags(["-fdeclspec"], .when(traits: ["Embedded"]))
            ],
            swiftSettings: [
                .enableExperimentalFeature("Embedded", .when(traits: ["Embedded"])),
                .unsafeFlags(["-Xfrontend", "-emit-empty-object-file"], .when(traits: ["Embedded"]))
            ]
        ),
        .testTarget(
            name: "ExternalTermFormatTests",
            dependencies: ["ExternalTermFormat"]
        ),
    ]
)
