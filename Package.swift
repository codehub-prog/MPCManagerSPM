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
            url: "https://github.com/codehub-prog/MPCManagerFramework/releases/download/1.0.5/MPCManagerFramework.xcframework.zip",
            checksum: "2a7c07a254f2dc49acf7a096dca7a881e91440b4cf7689ae526a7947a1fb36cd"
        )
    ]
)
