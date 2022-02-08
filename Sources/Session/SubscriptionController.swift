//
//  SubscriptionController.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Connection

private struct WeakContainer<T: AnyObject> {
    weak var object: T?
}

class SubscriptionController {
    
    private typealias TopicWeakContainer = WeakContainer<TopicReader>
    
    private var readers = [TopicPath: [TopicWeakContainer]]()
    private var mqtt: MQTTConnection
    
    internal init(mqtt: MQTTConnection) {
        self.mqtt = mqtt
    }

    func register(reader: TopicReader, for topic: TopicPath) {        
        subscribe(topic: topic)
        
        let container = WeakContainer(object: reader)
        readers[topic, default: []].append(container)
    }
    
    func handleConnected() {
        for topic in readers.keys {
            subscribe(topic: topic)
        }
    }
    
    func handle(message: MQTTMessage) {
        let topic = TopicPath(path: message.topic)
        
        let containers = withoutEmptyContainers(topic: topic)
        readers[topic] = containers
        
        guard !containers.isEmpty else {
            unsubscribe(topic: topic)
            return
        }
        
        let readers = containers.compactMap(\.object)
        
        for reader in readers {
            reader.output?.topicReader(reader, didReceive: message.payload)
            
            if let integer = Int(message.payload) {
                reader.output?.topicReader(reader, didReceive: integer)
            }
        }
    }
    
    private func subscribe(topic: TopicPath) {
        mqtt.subscribe(topic: topic.path)
    }
    
    private func withoutEmptyContainers(topic: TopicPath) -> [TopicWeakContainer] {
        readers[topic, default: []].filter { $0.object != nil }
    }
    
    private func unsubscribe(topic: TopicPath) {
        mqtt.unsubscribe(topic: topic.path)
    }
}
