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
    
    public func publish<T: Payload>(value: T) {
        session.send(payload: value.mqttValue(), topicPath: topic)
    }
}

extension Publisher where Output: Payload, Failure == Never {

    func write(to token: TopicWriter) -> AnyCancellable {
        return sink { output in
            token.publish(value: output.mqttValue())
        }

    }
}
