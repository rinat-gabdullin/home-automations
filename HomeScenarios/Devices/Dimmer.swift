//
//  Dimmer.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

class Dimmer: Lightning, RestorableDisabling {
    
    private var device: MutableDevice<Int>
    
    internal init(topic: Topic) {
        let setterTopic = topic.makeSetter()
        self.device = MutableDevice(baseTopic: topic, setterTopic: setterTopic)
    }
    
    var maxValue = 255
    
    var relativeLevel: Float {
        get {
            Float(device.receivedValue) / Float(maxValue)
        }
        
        set {
            lastRestorationToken?.invalidate()
            let value = Int(Float(maxValue) * newValue)
            device.updateValue(to: value)
        }
    }
    
    private var lastRestorationToken: Restoration? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    func setDisabled() -> Restoration {
        let currentLevel = relativeLevel
        
        if currentLevel == 0 {
            return Restoration(onRestore: nil)
        }
        
        let token = Restoration { [weak self] in
            self?.relativeLevel = currentLevel
        }
        
        relativeLevel = 0
        lastRestorationToken = token
        return token
    }
}
