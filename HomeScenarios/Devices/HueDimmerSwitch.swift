//
//  HueDimmerSwitch.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation

protocol HueDimmerSwitchOutput: AnyObject {
    func hueDimmerSwitch(_ switch: HueDimmerSwitch, didDetect action: HueDimmerSwitch.Action)
}

class HueDimmerSwitch: TopicReaderOutput {
    enum Action: String {
        case onPress = "on_press"
        case onHold = "on_hold"
        case onHoldRelease = "on_hold_release"
        case upPress = "up_press"
        case upHold = "up_hold"
        case upHoldRelease = "up_hold_release"
        case downPress = "down_press"
        case downHold = "down_hold"
        case downHoldRelease = "down_hold_release"
        case offPress = "off_press"
        case offHold = "off_hold"
        case offHoldRelease = "off_hold_release"
    }
    
    weak var output: HueDimmerSwitchOutput?
    
    private let actionReader: TopicReader
    
    init(deviceTopic: Topic) {
        let actionPath = deviceTopic.path + "/action"
        let factory = TopicReaderFactory()
        let actionTopic = Topic(path: actionPath)
        actionReader = factory.makeReader(topic: actionTopic)
        actionReader.output = self
    }
    
    func topicReader(_ reader: TopicReader, didReceive value: String) {
        guard let action = Action(rawValue: value) else {
            return
        }
        
        output?.hueDimmerSwitch(self, didDetect: action)
    }
}
