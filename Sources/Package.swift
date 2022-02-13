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
        .package(url: "https://github.com/emqx/CocoaMQTT", from: "2.0.2"),
    ],
    targets: [

        /// In *Application* devices interact with each other (e.g. lights with switches) by scenarios
        .target(
            name: "Application",
            dependencies: [.targetItem(name: "Presentation", condition: .none), .codeSupport],
            path: "Application"),
        
        /// *Presentation* layer describes devices exposed over MQTT
        .target(
            name: "Presentation",
            dependencies: [.targetItem(name: "Session", condition: .none), .codeSupport],
            path: "Presentation"),
        
        /// *Session* level is responsible for more convenient interaction with lower level
        .target(
            name: "Session",
            dependencies: [.targetItem(name: "Connection", condition: .none), .codeSupport],
            path: "Session"),
        
        /// *Connection* is low-level layer that estabilishes connection to MQTT-broker using CocoaMQTT library
        /// CocoaMQTT will be replaced with some cross-platform implemetation in order to launch this daemon in linux
        .target(
            name: "Connection",
            dependencies: [.byName(name: "CocoaMQTT"), .codeSupport],
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
 
