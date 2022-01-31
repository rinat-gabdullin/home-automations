//
//  CountertopLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import Foundation

class CountertopLighting: MotionSensorOutput, PushButtonOutput, RestorableDisableContainer {
    
    let lightDimmer = Dimmer(topic: .ledChannel2)
    let sensor = MotionSensor(topic: "/zigbee/kitchen/countertop-sensor/occupancy")
    let pushButton = PushButton(topic: "/devices/wb-gpio/controls/table-1")
    
    private var subscriptions = Set<AnyCancellable>()
    
    weak private var sensorDisableTimer: Timer?
    
    var restorableDisablingDevices: [RestorableDisabling] { [lightDimmer] }
    
    init() {
        sensor.output = self
        pushButton.output = self
        
        TopicPublisher(topic: .ledChannel2)
            .compactMap(Int.init)
            .map { $0 > 50 ? "1" : "0" }
            .write(to: .cookerHood)
            .store(in: &subscriptions)
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
    }
}
