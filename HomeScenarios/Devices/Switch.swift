//
//  Switch.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

class NewDevice {
    let topic: Control<Bool>

    internal init(topic: KeyPath<Box, Control<Bool>>) {
        self.topic = Box.shared[keyPath: topic]
    }

}

class NewSwitch: NewDevice, RestorableDisabling {

    var value: Bool {
        get {
            topic.wrappedValue
        }
        
        set {
            lastRestorationToken?.invalidate()
            topic.wrappedValue = newValue
        }
    }
    
    
    private var lastRestorationToken: Restoration? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    func setDisabled() -> Restoration {
        if !value {
            return Restoration(onRestore: nil)
        }
        
        let token = Restoration { [weak self] in
            self?.value = true
        }
        
        value = false
        lastRestorationToken = token
        return token
    }

}

class Switch: RestorableDisabling {
    
    var value: Bool {
        get {
            device.receivedValue == 1
        }
        set {
            let value = newValue ? 1 : 0
            lastRestorationToken?.invalidate()
            device.updateValue(to: value)
        }
    }
    
    private let device: MutableDevice<Int>
    
    init(topic: TopicPath, setter: TopicPath? = nil) {
        let setter = setter ?? topic.on
        device = MutableDevice(baseTopic: topic, setterTopic: setter)
    }
    
    private var lastRestorationToken: Restoration? {
        didSet {
            oldValue?.invalidate()
        }
    }
    
    func setDisabled() -> Restoration {
        if !value {
            return Restoration(onRestore: nil)
        }
        
        let token = Restoration { [weak self] in
            self?.value = true
        }
        
        value = false
        lastRestorationToken = token
        return token
    }

}
