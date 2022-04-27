// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Root",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(name: "Core", targets: ["Core"]),
        .library(name: "WidgetCommon", targets: ["WidgetCommon"]),
    ],
    dependencies: [
        .package(url: "https://github.com/YusukeHosonuma/LifeGame", branch: "main"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "8.10.0"),
    ],
    targets: [
        .target(name: "Core", dependencies: [
            "LifeGame",
            .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            .product(name: "FirebaseFirestoreSwift-Beta", package: "firebase-ios-sdk"),
        ]),
        .target(name: "WidgetCommon", dependencies: [
            "Core",
        ]),
    ]
)
