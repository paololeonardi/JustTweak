// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "JustTweak",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "JustTweak",
            targets: ["JustTweak"]),
    ],
    targets: [
        .target(
            name: "JustTweak",
            path: "JustTweak/"
        )
    ]
)
