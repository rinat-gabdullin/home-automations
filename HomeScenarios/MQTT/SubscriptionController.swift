//
//  SubscriptionController.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import CocoaMQTT

private struct WeakContainer<T: AnyObject> {
    weak var object: T?
}

class SubscriptionController {
    private typealias TopicWeakContainer = WeakContainer<TopicReader>
    
    private var readers = [Topic: [TopicWeakContainer]]()
    @DI private var mqtt: CocoaMQTT
    
    func register(reader: TopicReader, for topic: Topic) {
        
        subscribe(topic: topic)
        
        let container = WeakContainer(object: reader)
        readers[topic, default: []].append(container)
    }
    
    func handleConnected() {
        for topic in readers.keys {
            subscribe(topic: topic)
        }
    }
    
    func handle(message: CocoaMQTTMessage) {
        let topic = Topic(path: message.topic)
        
        let containers = withoutEmptyContainers(topic: topic)
        readers[topic] = containers
        
        guard !containers.isEmpty else {
            unsubscribe(topic: topic)
            return
        }
        
        let readers = containers.compactMap(\.object)
        
        guard let string = message.string else {
            return
        }
        
        for reader in readers {
            reader.output?.topicReader(reader, didReceive: string)
            
            if let integer = Int(string) {
                reader.output?.topicReader(reader, didReceive: integer)
            }
        }
    }
    
    private func subscribe(topic: Topic) {
        mqtt.subscribe(topic.path)
    }
    
    private func withoutEmptyContainers(topic: Topic) -> [TopicWeakContainer] {
        readers[topic, default: []].filter { $0.object != nil }
    }
    
    private func unsubscribe(topic: Topic) {
        mqtt.unsubscribe(topic.path)
    }
}
