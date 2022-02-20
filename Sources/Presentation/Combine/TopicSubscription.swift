//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Combine
import Session

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
            
            guard let value = P(payloadString: value) else {
                subscriber.receive(completion: .failure(.invalidType))
                return
            }
            
            let newDemand = subscriber.receive(value)
            demand += newDemand
        }
    }
}
