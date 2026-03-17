// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MPCManagerSPM",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "MPCManagerSPM",
            targets: ["MPCManagerSPM"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "MPCManagerSPM",
            url: "https://github.com/codehub-prog/MPCManagerFramework/releases/download/1.0.2/MPCManagerFramework.xcframework.zip",
            checksum: "c61f36fe6a78be364050c24dfcb8ab5a587c9ceb363206e0447d8d3986a1debb"
        )
    ]
)
