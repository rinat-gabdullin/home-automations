//
//  Subscription.swift
//  HomeScenarios
//
//  Created by Rinat G. on 30.11.2021.
//

import Combine

public protocol TopicReaderOutput: AnyObject {
    func topicReader(_ reader: TopicReader, didReceive value: String)
}

public class TopicReader  {
    weak public var output: TopicReaderOutput?
}
