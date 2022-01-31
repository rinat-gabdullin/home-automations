//
//  KitchenTableLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

class KitchenTableLighting: MotionSensorOutput, PushButtonOutput, RestorableDisableContainer {

    let lightSwitch = Switch(topic: "/devices/relay-big-1/controls/K4")
    let sensor = MotionSensor(topic: "/zigbee/kitchen/table-sensor/occupancy")
    let pushButton = PushButton(topic: "/devices/wb-gpio/controls/table-2")
    
    var restorableDisablingDevices: [RestorableDisabling] { [lightSwitch] }

    init() {
        sensor.output = self
        sensor.noMotionNotifyPeriod = 60 * 8
        pushButton.output = self
    }
    
    func motionSensorDidDetectMotion(_ sensor: MotionSensor) {
        lightSwitch.value = true
    }
    
    func motionSensorDidntDetectMotionForPeriod(_ sensor: MotionSensor) {
        lightSwitch.value = false
    }
    
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
        lightSwitch.value.toggle()
        sensor.disableTemporarily()        
    }
}
