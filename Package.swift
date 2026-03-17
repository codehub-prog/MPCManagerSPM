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
            url: "https://github.com/codehub-prog/MPCManagerFramework/releases/download/1.0.6/MPCManagerFramework.xcframework.zip",
            checksum: "931e898621105bb137f9436203d4ff27545df6a942db10e158c040a7ca63e049"
        )
    ]
)
