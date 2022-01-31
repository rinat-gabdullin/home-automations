//
//  Device.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

class Device<T: Payload>: TopicReaderOutput {
    
    private(set) var receivedValue = T.initialValue
    
    let reader: TopicReader
    
    init(topic: Topic) {
        let factory = TopicReaderFactory()
        reader = factory.makeReader(topic: topic)
        reader.output = self
    }
    
    func topicReader(_ reader: TopicReader, didReceive value: String) {
        guard let newValue = value as? T else {
            return
        }
        
        self.receivedValue = newValue
        didChangeValue(to: newValue)
    }
    
    func topicReader(_ reader: TopicReader, didReceive value: Int) {
        guard let newValue = value as? T else {
            return
        }
        
        self.receivedValue = newValue
        didChangeValue(to: newValue)
    }
    
    open func didChangeValue(to newValue: T) {
        
    }
}
