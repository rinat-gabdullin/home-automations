//
//  File.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import CocoaMQTT
import Foundation

public protocol MQTTConnectionOutput: AnyObject {
    func MQTTConnectionDidConnect(_ connection: MQTTConnection)
    func MQTTConnectionDidReceiveMessage(_ connection: MQTTConnection, message: MQTTMessage)
}

public class MQTTConnection {

    enum Error: Swift.Error {
        case invalidUrl
    }
    
    private let mqtt: CocoaMQTT
    private let listerener = MQTTDelegate()

    public weak var output: MQTTConnectionOutput? {
        didSet {
            listerener.output = output
        }
    }
    
    public init(serverUrl: URL) throws {
        guard
            let host = serverUrl.host,
            let port = serverUrl.port
        else {
            throw Error.invalidUrl
        }
        
        mqtt = CocoaMQTT(clientID: "HomeScenariosApp",
                         host: host,
                         port: UInt16(port))
        
        mqtt.keepAlive = 60
//        mqtt.logLevel = .debug
        mqtt.autoReconnect = true
        mqtt.delegate = listerener
        listerener.connection = self
    }
    
    public func connect() {
        _ = mqtt.connect()
    }
    
    public func publish(message: MQTTMessage) {
        mqtt.publish(message.makeCocoaMQTTMessage())
    }
    
    public func subscribe(topic: String) {
        mqtt.subscribe(topic)
    }
    
    public func unsubscribe(topic: String) {
        mqtt.unsubscribe(topic)
    }
}
