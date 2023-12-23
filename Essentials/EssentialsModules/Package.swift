// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EssentialsModules",
    platforms: [
        .iOS(.v17),
    ],
    products: [
        .library(name: "CounterFeature", targets: ["CounterFeature"]),
        .library(name: "NumberFactClient", targets: ["NumberFactClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", branch: "observation-beta"),
    ],
    targets: [
        .target(
            name: "CounterFeature",
            dependencies:[
                "NumberFactClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "CounterFeatureTests",
            dependencies: ["CounterFeature"]),
        .target(
            name: "NumberFactClient",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .testTarget(
            name: "NumberFactClientTests",
            dependencies: ["NumberFactClient"]),
    ]
)
