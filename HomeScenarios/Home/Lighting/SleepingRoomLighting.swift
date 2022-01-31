//
//  SleepingRoomLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

class SleepingRoomLighting: PushButtonOutput, RestorableDisableContainer {
    
    var restorableDisablingDevices: [RestorableDisabling] { [dimmer, led] }
    
    private let dimmer = Dimmer(topic: .dimmer2Channel1)
    private let led = Dimmer(topic: .ledChannel4)

    private let button1 = PushButton(topic: "/devices/wb-gpio/controls/sleeping-1")
    private let button2 = PushButton(topic: "/devices/wb-gpio/controls/sleeping-2")

    private var scheme: LightingScheme = .off {
        didSet {
            didSet(scheme: scheme)
        }
    }

    init() {
        [button1, button2].forEach { button in
            button.output = self
            button.detectEvents = [.longPress, .doubleClick, .singleClick]
        }
        
        dimmer.maxValue = 100
    }
    
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
        if pushButton === button1 {
            leftButton(event: event)
        } else if pushButton === button2 {
            rightButton(event: event)
        }

    }
    
    private func leftButton(event: PushButtonEvent) {
        switch event {
        case .singleClick:
            scheme = .lounge
            
        case .doubleClick:
            break
            
        case .longPress:
            scheme = .off
        }
    }
    
    private func rightButton(event: PushButtonEvent) {
        switch event {
        case .singleClick:
            scheme = .auto
            
        case .doubleClick:
            break
            
        case .longPress:
            scheme = .bright
        }
    }

    private func didSet(scheme: LightingScheme) {
        switch scheme {
        case .off:
            led.relativeLevel = 0
            dimmer.relativeLevel = 0
            
        case .lounge:
            led.relativeLevel = 0.1
            dimmer.relativeLevel = 0
            
        case .auto:
            led.relativeLevel = 1
            dimmer.relativeLevel = 0.6
            
        case .bright:
            led.relativeLevel = 1
            dimmer.relativeLevel = 1
        }
    }
}
