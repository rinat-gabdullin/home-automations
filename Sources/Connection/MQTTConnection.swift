//
//  File.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import MQTTNIO
import Foundation

public struct MQTTMessage {
    public var topic: String
    public var payload: String

    public init(topic: String, payload: String) {
        self.topic = topic
        self.payload = payload
    }
    
}

public protocol MQTTConnectionOutput: AnyObject {
    func didReceiveMQTTMessage(_ message: MQTTMessage)
}

public class MQTTConnection {

    enum Error: Swift.Error {
        case invalidUrl
    }
    
    private let mqtt: MQTTClient

    public weak var output: MQTTConnectionOutput?
    
    public init(serverUrl: URL) throws {
        guard
            let host = serverUrl.host,
            let port = serverUrl.port
        else {
            throw Error.invalidUrl
        }
        
        mqtt = MQTTClient(configuration: .init(target: .host(host, port: port),
                                               protocolVersion: .version3_1_1,
                                               connectionTimeoutInterval: .seconds(1),
                                               reconnectMode: .retry(minimumDelay: .seconds(1), maximumDelay: .seconds(10)),
                                               connectRequestTimeoutInterval: .seconds(1)))
    }
    
    public func connect() {
        _ = try? mqtt.connect().wait()
        
        mqtt.whenMessage { [weak output] message in
            let message = MQTTMessage(topic: message.topic,
                                      payload: message.payload.string ?? "")
            output?.didReceiveMQTTMessage(message)
        }
    }
    
    public func publish(message: MQTTMessage) {
        mqtt.publish(message.payload, to: message.topic)
    }
    
    public func subscribe(topic: String) {
        mqtt.subscribe(to: topic)
    }
    
    public func unsubscribe(topic: String) {
        mqtt.unsubscribe(from: topic)
    }
}
