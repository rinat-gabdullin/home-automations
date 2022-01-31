//
//  Subscription.swift
//  HomeScenarios
//
//  Created by Rinat G. on 30.11.2021.
//

import Combine

protocol TopicReaderOutput: AnyObject {
    func topicReader(_ reader: TopicReader, didReceive value: Int)
    func topicReader(_ reader: TopicReader, didReceive value: String)
}

extension TopicReaderOutput {
    func topicReader(_ reader: TopicReader, didReceive value: Int) { }
    func topicReader(_ reader: TopicReader, didReceive value: String) { }
}

class TopicReader  {
    weak var output: TopicReaderOutput?
}
