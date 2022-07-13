//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Connection
import Combine
import CodeSupport

extension MQTTConnection {

    public func subscribe<T: Payload>(topicPath: TopicPath) -> AnyPublisher<T, Never> {
        TopicPublisher(topic: topicPath, session: self)
            .breakpointOnError()
            .catch { _ in Empty(completeImmediately: false) }
            .eraseToAnyPublisher()
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
