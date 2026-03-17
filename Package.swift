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
            url: "https://github.com/codehub-prog/MPCManagerFramework/releases/download/1.0.3/MPCManagerFramework.xcframework.zip",
            checksum: "2d74c5c808fddfbee552344cccf9506ff1d2afeeb9d1df9b3fcd3fa80e185c10"
        )
    ]
)
