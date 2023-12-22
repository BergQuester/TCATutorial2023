// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NavigationModule",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "AddContactFeature", targets: ["AddContactFeature"]),
        .library(name: "ContactDetailFeature", targets: ["ContactDetailFeature"]),
        .library(name: "ContactsFeature", targets: ["ContactsFeature"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.5.6"),
    ],
    targets: [
        .target(
            name: "Models"
        ),    
        .target(
            name: "AddContactFeature",
            dependencies: [
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "ContactDetailFeature",
            dependencies: [
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "ContactDetailFeatureTests",
            dependencies: ["ContactDetailFeature"]
        ),
        .target(
            name: "ContactsFeature",
            dependencies: [
                "Models",
                "AddContactFeature",
                "ContactDetailFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "ContactsFeatureTests",
            dependencies: ["ContactsFeature"]
        ),

    ]
)
