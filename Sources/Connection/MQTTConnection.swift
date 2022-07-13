//
//  File.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import MQTTNIO
import Foundation
import CodeSupport

public struct MQTTMessage {
    public var topic: String
    public var payload: String

    public init(topic: String, payload: String) {
        self.topic = topic
        self.payload = payload
    }
}

public class MQTTConnection {

    enum Error: Swift.Error {
        case invalidUrl
    }
    
    private let mqtt: MQTTClient
    
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
    
    public func makeReader(for topicPath: TopicPath) -> TopicReader {
        let reader = TopicReader()
        mqtt.subscribe(to: topicPath.path)
        mqtt.whenMessage(forTopic: topicPath.path) { [weak reader] message in
            if let reader = reader {
                DispatchQueue.main.async {
                    reader.output?.topicReader(reader, didReceive: message.payload.string ?? "")                    
                }
            }
        }
        
        return reader
    }
    
    public func makeWriter(for topicPath: TopicPath) -> TopicWriter {
        TopicWriter(connection: self, topic: topicPath)
    }

}
