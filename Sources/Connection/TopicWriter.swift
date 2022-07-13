//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Combine
import CodeSupport

public class TopicWriter {
    let connection: MQTTConnection
    let topic: TopicPath
    
    internal init(connection: MQTTConnection, topic: TopicPath) {
        self.connection = connection
        self.topic = topic
    }
    
    public func publish(payload: String) {
        connection.publish(message: MQTTMessage(topic: topic.path, payload: payload))
    }
}
