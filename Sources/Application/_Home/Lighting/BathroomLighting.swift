//
//  BathroomLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

class BathroomLighting: PushButtonOutput, RestorableDisableContainer, MotionSensorOutput {
        
    private var scheme: LightingScheme = .off {
        didSet {
            didSet(scheme: scheme)
        }
    }
    
    private let dimmer = Dimmer(topic: .dimmer2Channel2)
    private let led = Dimmer(topic: .ledChannel3)
    
    private let button1 = PushButton(topic: "/devices/wb-gpio/controls/bathroom-1")
    private let button2 = PushButton(topic: "/devices/wb-gpio/controls/bathroom-2")
    
    private let sensor = MotionSensor(topic: "/devices/sensor-bathroom/controls/Current Motion")
    
    var restorableDisablingDevices: [RestorableDisabling] { [dimmer, led] }
    
    init() {
        [button1, button2].forEach { button in
            button.output = self
            button.detectEvents = [.longPress, .doubleClick, .singleClick]
        }
        
        sensor.noMotionNotifyPeriod = 60 * 10
        dimmer.maxValue = 100
        sensor.output = self
    }
    
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
        sensor.disableTemporarily()
        
        if pushButton === button1 {
            leftButton(event: event)
        } else if pushButton === button2 {
            rightButton(event: event)
        }
    }
    
    func motionSensorDidDetectMotion(_ sensor: MotionSensor) {
        scheme = .auto
    }
    
    func motionSensorDidntDetectMotionForPeriod(_ sensor: MotionSensor) {
        scheme = .lounge
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
    
}
