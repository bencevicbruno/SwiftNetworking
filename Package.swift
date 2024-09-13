// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "SwiftNetworking",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SwiftNetworking",
            targets: ["SwiftNetworking"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "SwiftNetworking",
            dependencies: []),
        .testTarget(
            name: "SwiftNetworkingTests",
            dependencies: ["SwiftNetworking"]),
    ]
)
