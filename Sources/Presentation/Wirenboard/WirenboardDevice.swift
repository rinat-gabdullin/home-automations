//
//  WirenboardDevice.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation
import Connection
import CodeSupport

public class WirenboardDevice {
    internal init(deviceName: String, session: MQTTConnection) {
        
        let devicePath = "/devices/\(deviceName)/controls/"
        
        var titles = [String]()
        
        for child in Mirror(reflecting: self).children {
            guard var label = child.label, let binding = child.value as? TopicBinding else {
                continue
            }
            if label.first == "_" {
                label.removeFirst()
            } else {
                return
            }
            titles.append(label)
            configure(topicBinding: binding)
            binding.initialize(topicPath: TopicPath(path: devicePath + label), session: session)
        }
        
    }
    
    func configure(topicBinding: TopicBinding) {
        
    }
}
