//
//  EntrancyLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

class EntrancyLighting: PushButtonOutput, RestorableDisableContainer {

    weak var homeEventsHandler: HomeEvents?
    
    let dimmer = Dimmer(topic: .dimmerChannel3)
    let led = Dimmer(topic: .ledChannel1)
    let mirror = Switch(topic: "/devices/relay-small-2/controls/K5")

    private let enterButton1 = PushButton(topic: "/devices/wb-gpio/controls/enter-1")
    private let enterButton2 = PushButton(topic: "/devices/wb-gpio/controls/enter-2")

    var restorableDisablingDevices: [RestorableDisabling] { [dimmer, led, mirror] }
    
    init() {
        [enterButton1, enterButton2].forEach { button in
            button.output = self
            button.detectEvents = [.longPress, .doubleClick, .singleClick]
        }
        
        dimmer.maxValue = 100
    }
    
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
        if pushButton === enterButton1 {
            leftButton(event: event)
        } else if pushButton === enterButton2 {
            rightButton(event: event)
        }
    }
    
    private func leftButton(event: PushButtonEvent) {
        switch event {
        case .singleClick:
            dimmer.relativeLevel = 0
            led.relativeLevel = 1
            mirror.value = true
            
        case .doubleClick:
            dimmer.relativeLevel = 0
            led.relativeLevel = 1
            mirror.value = false
            
            break
            
        case .longPress:
            offEverywhere()
        }
    }
    
    private func rightButton(event: PushButtonEvent) {
        switch event {
        case .singleClick:
            dimmer.relativeLevel = 0.5
            led.relativeLevel = 1
            mirror.value = true
            
        case .doubleClick:
            break
            
        case .longPress:
            dimmer.relativeLevel = 1
            led.relativeLevel = 1
            mirror.value = true
            break
        }
    }

    private func offEverywhere() {
        homeEventsHandler?.switchLightsEverywhere()
    }
}
