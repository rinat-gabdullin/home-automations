//
//  CountertopLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

class CountertopLighting: MotionSensorOutput, PushButtonOutput, RestorableDisableContainer {
    
    let lightDimmer = Dimmer(topic: .ledChannel2)
    let cookerHood = Switch(topic: "/devices/wb-gpio/controls/EXT3_HS3")
    let sensor = MotionSensor(topic: "/zigbee/kitchen/countertop-sensor/occupancy")
    let pushButton = PushButton(topic: "/devices/wb-gpio/controls/table-1")
    
    weak private var sensorDisableTimer: Timer?
    
    var restorableDisablingDevices: [RestorableDisabling] { [lightDimmer, cookerHood] }
    
    init() {
        sensor.output = self
        pushButton.output = self
    }
    
    func motionSensorDidDetectMotion(_ sensor: MotionSensor) {
        set(enabled: true)
    }
    
    func motionSensorDidntDetectMotionForPeriod(_ sensor: MotionSensor) {
        set(enabled: false)
    }
    
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
        if lightDimmer.relativeLevel == 0 {
            set(enabled: true)
        } else {
            set(enabled: false)
        }
        
        sensor.disableTemporarily()
    }
    
    private func set(enabled: Bool) {
        lightDimmer.relativeLevel = enabled ? 1 : 0
        cookerHood.value = enabled
    }
}
