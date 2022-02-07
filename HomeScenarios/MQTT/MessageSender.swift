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
    
    init(topic: TopicPath, payload: Payload) {
        let string = payload.mqttValue()
        let bytes = [UInt8](string.utf8)
        underlyingObject = .init(topic: topic.path, payload: bytes)
    }
}

class MessageSender {
    @DI private var mqtt: CocoaMQTT
    
    func send(message: Message) {
        mqtt.publish(message.underlyingObject)
    }
}
