// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "JustTweak",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
        .tvOS(.v14),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "JustTweak",
            targets: ["JustTweak"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "JustTweak",
            dependencies: [],
            path: "JustTweak",
            resources: [
                .process("Assets/TweakAccessorGenerator.bundle")
            ]),
        .testTarget(
            name: "JustTweakTests",
            dependencies: ["JustTweak"],
            path: "Tests"),
    ]
)
