////
////  CloakroomLighting.swift
////  HomeScenarios
////
////  Created by Rinat G. on 23.01.2022.
////
//
//import Foundation
//import Presentation
//
//class CloakroomLighting: MotionSensorOutput, RestorableDisableContainer {
//    
//    let lightSwitch = Switch(topic: "/devices/relay-big-1/controls/K6")
//    let sensor = MotionSensor(topic: "/zigbee/enter/cloakroom-sensor/occupancy")
//    
//    var restorableDisablingDevices: [RestorableDisabling] { [lightSwitch] }
//    
//    init() {
//        sensor.output = self
//    }
//    
//    func motionSensorDidDetectMotion(_ sensor: MotionSensor) {
//        lightSwitch.value = true
//    }
//    
//    func motionSensorDidntDetectMotionForPeriod(_ sensor: MotionSensor) {
//        lightSwitch.value = false
//    }
//}
