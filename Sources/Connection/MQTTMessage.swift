//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import CocoaMQTT

public struct MQTTMessage {
    public var topic: String
    
    public var payload: String
    
    init?(message: CocoaMQTTMessage) {
        topic = message.topic
        if let string = message.string {
            payload = string
        } else {
            return nil
        }
    }
    
    public init(topic: String, payload: String) {
        self.topic = topic
        self.payload = payload
    }
    
    func makeCocoaMQTTMessage() -> CocoaMQTTMessage {
        CocoaMQTTMessage(topic: topic, payload: [UInt8](payload.utf8))
    }
}

