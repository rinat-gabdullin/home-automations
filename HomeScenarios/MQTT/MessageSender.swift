//
//  MessageIO.swift
//  HomeScenarios
//
//  Created by Rinat G. on 30.11.2021.
//

import CocoaMQTT

struct Message {
    /// To unwire from CocoaMQTT library
    let underlyingObject: CocoaMQTTMessage
    
    init(topic: Topic, payload: Payload) {
        underlyingObject = .init(topic: topic.path, payload: payload.payloadBytes)
    }
}

class MessageSender {
    @DI private var mqtt: CocoaMQTT
    
    func send(message: Message) {
        mqtt.publish(message.underlyingObject)
    }
}
