//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Session
import Combine

extension MQTTSession {
    public func subscribe<T: Payload>(topicPath: TopicPath) -> TopicPublisher<T> {
        TopicPublisher(topic: topicPath, session: self)
    }
}

extension Publisher where Output: Payload, Failure == Never {
    
    func write(to token: TopicWriter) -> AnyCancellable {
        return sink { output in
            token.publish(payload: output.mqttValue())
        }
    }
}

public extension Publisher where Output: Payload, Failure == Never {
    
    func write(to binding: WritableBinding<Output>) -> AnyCancellable {
        sink { output in
            binding.wrappedValue = output
        }
    }
    
    func write(to binding: Field<Output>) -> AnyCancellable {
        sink { output in
            binding.wrappedValue = output
        }
    }
}

public extension Publisher where Output == Double, Failure == Never {
    func writeRelative(to relativeSetting: RelativeSetting) -> AnyCancellable {
        sink { output in
            relativeSetting.relativeValue = output
        }
    }
}
