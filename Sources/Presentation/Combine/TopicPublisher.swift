//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Combine
import Session

public final class TopicPublisher<P: Payload>: Publisher {
    
    public typealias Output = P
    public typealias Failure = Never
    
    let topic: TopicPath
    private let session: MQTTSession
    
    public init(topic: TopicPath, session: MQTTSession) {
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
