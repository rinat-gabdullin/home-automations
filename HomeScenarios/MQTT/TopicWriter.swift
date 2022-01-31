//
//  TopicWriter.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

class TopicWriter {    
    let topic: Topic
    private var sender = MessageSender()
    
    internal init(topic: Topic) {
        self.topic = topic
    }
    
    func write(value: Payload) {
        let message = Message(topic: topic, payload: value)
        sender.send(message: message)
    }
}
