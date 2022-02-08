// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "home-automations",
    platforms: [.macOS(.v10_15)],
    products: [
        .library(
            name: "HomeAutomations",
            targets: ["Application"]),
    ],
    dependencies: [
        .package(url: "https://github.com/emqx/CocoaMQTT", from: "2.0.2"),
    ],
    targets: [
        .target(
            name: "Application",
            dependencies: [.targetItem(name: "Presentation", condition: .none)],
            path: "Sources/Application"),
        .target(
            name: "CodeSupport",
            path: "Sources/Code Support"),
        .target(
            name: "Presentation",
            dependencies: [.targetItem(name: "Session", condition: .none)],
            path: "Sources/Presentation"),
        .target(
            name: "Session",
            dependencies: [.targetItem(name: "Connection", condition: .none)],
            path: "Sources/Session"),
        .target(
            name: "Connection",
            dependencies: [.byName(name: "CocoaMQTT")],
            path: "Sources/Connection"),
        
    ]
)
