//
//  TopicPublisher.swift
//  HomeEngine
//
//  Created by Rinat G. on 31.01.2022.
//

import Combine

enum TopicPublisherError: Swift.Error {
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

final class TopicPublisher<P: Payload>: Publisher {

    typealias Output = P
    typealias Failure = TopicPublisherError

    let topic: TopicPath
    private let factory = TopicReaderFactory()
    
    internal init(topic: TopicPath) {
        self.topic = topic
    }
    
    func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let reader = factory.makeReader(topic: topic)
        let subscription = TopicSubscription(reader: reader, subscriber: subscriber)
        reader.output = subscription
        subscriber.receive(subscription: subscription)
    }
}

extension Publisher where Output: Payload, Failure == Never {
    
    func write(to topic: TopicPath) -> AnyCancellable {
        let writer = TopicWriter(topic: topic)
        return sink { output in
            writer.write(value: output)
        }

    }
}
