//
//  WirenboardDevice.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation

class WirenboardDevice {
    internal init(deviceName: String) {
        
        let devicePath = "/devices/\(deviceName)/controls/"
        
        for child in Mirror(reflecting: self).children {
            guard var label = child.label, let topic = child.value as? InitializableByTopicPath else {
                continue
            }
            if label.first == "_" {
                label.removeFirst()
            }
            
            topic.initialize(topicPath: TopicPath(path: devicePath + label))
        }
    }
}
