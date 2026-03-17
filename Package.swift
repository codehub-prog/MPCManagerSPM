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
            url: "https://github.com/codehub-prog/MPCManagerFramework/releases/download/1.0.1/MPCManagerFramework.xcframework.zip",
            checksum: "57174317fd23ecd9f091bdcdd82620ed95936e1500104ffbc7b71911570022f0"
        )
    ]
)
