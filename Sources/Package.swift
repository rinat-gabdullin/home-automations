// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "home-automations",
    platforms: [.macOS(.v12)],
    products: [
        .library(
            name: "HomeAutomations",
            targets: ["Application"]),
    ],
    dependencies: [
        .package(url: "https://github.com/sroebert/mqtt-nio", from: "2.6.2"),
    ],
    targets: [
        
        /// In *Application* devices interact with each other (e.g. lights with switches) by scenarios
        .target(
            name: "Application",
            dependencies: [.targetItem(name: "DeviceAreas", condition: .none), .codeSupport],
            path: "Application"),
        
        .target(
            name: "DeviceAreas",
            dependencies: [.targetItem(name: "Presentation", condition: .none), .codeSupport],
            path: "DeviceAreas"),
        
        /// *Presentation* layer describes devices exposed over MQTT
        .target(
            name: "Presentation",
            dependencies: [.targetItem(name: "Connection", condition: .none), .codeSupport],
            path: "Presentation"),
        
        /// *Connection* is low-level layer that estabilishes connection to MQTT-broker using CocoaMQTT library
        /// CocoaMQTT will be replaced with some cross-platform implemetation in order to launch this daemon in linux
            .target(
                name: "Connection",
                dependencies: [.product(name: "MQTTNIO", package: "mqtt-nio"), .codeSupport],
                path: "Connection"),
        
            .target(
                name: "CodeSupport",
                path: "Code Support"),
        
        
    ]
)

extension Target.Dependency {
    static var codeSupport: Self {
        .targetItem(name: "CodeSupport", condition: nil)
    }
}
 
