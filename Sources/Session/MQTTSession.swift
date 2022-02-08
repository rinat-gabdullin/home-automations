//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Connection

public class MQTTSession {
    
    internal let connection: MQTTConnection
    internal let subscriptionController: SubscriptionController
    
    private let listener = MQTTConnectionListener()
    
    public init(serverUrl: URL) throws {
        let connection = try MQTTConnection(serverUrl: serverUrl)
        self.connection = connection
        subscriptionController = SubscriptionController(mqtt: connection)
        connection.output = listener
        
        //TODO: here?
        connection.connect()
    }
    
    public func send(payload: String, topicPath: TopicPath) {
        connection.publish(message: MQTTMessage(topic: topicPath.path, payload: payload) )
    }
    
    public func subscribe<T: Payload>(topicPath: TopicPath) -> TopicPublisher<T> {
        TopicPublisher(topic: topicPath, session: self)
    }
    
    func makeReader(for topicPath: TopicPath) -> TopicReader {
        let reader = TopicReader()
        subscriptionController.register(reader: reader, for: topicPath)
        return reader
    }
    
    public func makeWriter(for topicPath: TopicPath) -> TopicWriter {
        TopicWriter(session: self, topic: topicPath)
    }
}
