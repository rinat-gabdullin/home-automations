//
//  Doorbell.swift
//  HomeEngine
//
//  Created by Rinat G. on 25.01.2022.
//

import Foundation
/*
class Doorbell: Device<Int> {
    
    private let doorbell = Switch(topic: .doorbell, setter: .doorbell)
    private let buzzer = Switch(topic: "/devices/buzzer/controls/enabled")
    
    init() {
        super.init(topic: "/devices/relay-big-2/controls/Input 6 counter")
    }
    
    var task: SimpleTask? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private var lastValue: Int?
    
    override func topicReader(_ reader: TopicReader, didReceive value: Int) {

        defer {
            lastValue = value
        }

        guard let lastValue = lastValue, value > lastValue else {
            return
        }

        doorbell.value = true
        buzzer.value = true

        task = Task {
            try await Task.sleep(seconds: 3)
            doorbell.value = false
            buzzer.value = false
        }
    }
}
*/
