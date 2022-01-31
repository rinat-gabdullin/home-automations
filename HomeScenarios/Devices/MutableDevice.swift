//
//  Switch.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

class MutableDevice<T: Payload>: Device<T> {
    
    private let writer: TopicWriter
    
    init(baseTopic: Topic, setterTopic: Topic) {
        writer = TopicWriter(topic: setterTopic)
        super.init(topic: baseTopic)
    }
    
    func updateValue(to newValue: T) {
        writer.write(value: newValue)
    }
}
