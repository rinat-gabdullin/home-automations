//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Combine

public class TopicWriter {
    let session: MQTTSession
    let topic: TopicPath
    
    internal init(session: MQTTSession, topic: TopicPath) {
        self.session = session
        self.topic = topic
    }
    
    public func publish(payload: String) {
        session.send(payload: payload, topicPath: topic)
    }
}
