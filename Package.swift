// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "JustTweak",
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
    targets: [
        .target(
            name: "JustTweak",
            path: "JustTweak"
        ),
        .testTarget(
            name: "JustTweakTests",
            dependencies: ["JustTweak"],
            path: "Tests"
        )
    ]
)
