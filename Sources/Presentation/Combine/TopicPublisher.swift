//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Combine
import Connection
import CodeSupport

public final class TopicPublisher<P: Payload>: Publisher {
    
    public typealias Output = P
    public typealias Failure = Never
    
    let topic: TopicPath
    private let session: MQTTConnection
    
    public init(topic: TopicPath, session: MQTTConnection) {
        self.topic = topic
        self.session = session
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let reader = session.makeReader(for: topic)
        let subscription = TopicSubscription(reader: reader, subscriber: subscriber)
        reader.output = subscription
        subscriber.receive(subscription: subscription)
    }
}
