//
//  TopicReaderFactory.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

class TopicReaderFactory {
    @DI private var subscriptionController: SubscriptionController
    
    func makeReader(topic: TopicPath) -> TopicReader {
        let reader = TopicReader()
        subscriptionController.register(reader: reader, for: topic)
        return reader
    }
}
