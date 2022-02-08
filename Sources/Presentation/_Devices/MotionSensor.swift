//
//  MotionSensor.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

protocol MotionSensorOutput: AnyObject {
    func motionSensorDidDetectMotion(_ sensor: MotionSensor)
    func motionSensorDidntDetectMotionForPeriod(_ sensor: MotionSensor)
}

class MotionSensor: Device<String> {
    
    weak var output: MotionSensorOutput?
        
    var sensorDisableDuration: TimeInterval = 60*30
    
    var noMotionNotifyPeriod: TimeInterval = 3*60
    
    private var enabled = true

    weak private var sensorDisableTimer: Timer?
    
    private var motionDetected = false
    
    private var noMotionTimer: Timer?
    
    private var minimumMotionThresthold = 100
    
    override func didChangeValue(to newValue: String) {

        guard
            newValue == "true" || // if topic contains Bool
            (Int(newValue) ?? 0) > minimumMotionThresthold // if topic contains "motion amount"
        else {
            return
        }
        motionDetected = true
        
        if enabled {
            output?.motionSensorDidDetectMotion(self)
        }
        
        noMotionTimer?.invalidate()
        noMotionTimer = Timer.scheduledTimer(withTimeInterval: noMotionNotifyPeriod,
                                             repeats: false) { [weak self] _ in
            self?.noMotionTimerDidFire()
        }
    }
    
    private func noMotionTimerDidFire() {
        motionDetected = false
        
        if enabled {
            output?.motionSensorDidntDetectMotionForPeriod(self)
        }
    }
    
    func disableTemporarily() {
        enabled = false
        sensorDisableTimer?.invalidate()
        sensorDisableTimer = Timer.scheduledTimer(withTimeInterval: sensorDisableDuration,
                                                  repeats: false) { [weak self] _ in
            self?.disableTemporarilyTimerDidFire()
        }
    }
    
    private func disableTemporarilyTimerDidFire() {
        enabled = true
        
        if motionDetected {
            output?.motionSensorDidDetectMotion(self)
        } else {
            output?.motionSensorDidntDetectMotionForPeriod(self)
        }
    }
}
