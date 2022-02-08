//
//  TopicPublisher.swift
//  HomeEngine
//
//  Created by Rinat G. on 31.01.2022.
//

import Combine

public enum TopicPublisherError: Swift.Error {
    case invalidType
}

extension TopicPublisher {
    
    final class TopicSubscription<T: Subscriber>: Combine.Subscription, TopicReaderOutput
    where T.Input == Output, T.Failure == Failure {
        
        private var reader: TopicReader?
        private var subscriber: T
        private var demand = Subscribers.Demand.none
        
        internal init(reader: TopicReader? = nil, subscriber: T) {
            self.reader = reader
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            self.demand += demand
        }
        
        func cancel() {
            reader = nil
        }
        
        func topicReader(_ reader: TopicReader, didReceive value: String) {
            guard demand > 0 else {
                return
            }
            
            guard let value = P(value) else {
                subscriber.receive(completion: .failure(.invalidType))
                return
            }
            
            let newDemand = subscriber.receive(value)
            demand += newDemand
        }
    }
}

public final class TopicPublisher<P: Payload>: Publisher {

    public typealias Output = P
    public typealias Failure = TopicPublisherError

    let topic: TopicPath
    private let session: MQTTSession
    
    internal init(topic: TopicPath, session: MQTTSession) {
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
