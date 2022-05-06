//
//  MotionSensor.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Combine

public enum DetectionState: Equatable {
    case motionDetected
    case motionNotDetected
}

public protocol MotionDetection {
    func statePublisher() -> AnyPublisher<DetectionState, Never>
    func disableTemporarily()
}

public class ZigbeeSensor: MotionSensor<ZigbeeOccupancyPayload> {
    public override func didSetValue(oldValue: ZigbeeOccupancyPayload) {
        if value.occupancy {
            didDetectMotion()
        }
    }
}

public class MSWMotionSensor: MotionSensor<Int> {
    
    private var minimumMotionThresthold = 100
    
    override public func didSetValue(oldValue: Int) {
        if value > minimumMotionThresthold {
            didDetectMotion()
        }
    }
}

public class MotionSensor<T: Payload>: Device<T>, MotionDetection {
    
    @Published private(set) public var state = DetectionState.motionNotDetected
        
    var sensorDisableDuration: TimeInterval = 60*40
    
    public var noMotionNotifyPeriod: TimeInterval = 3*60
    
    public private(set) var enabled = true

    weak private var sensorDisableTimer: Timer?
    
    private var motionDetected = false
    
    private var noMotionTimer: Timer?
    
    internal func didDetectMotion() {
        
        self.motionDetected = true
        
        if enabled {
            state = .motionDetected
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
            state = .motionNotDetected
        }
    }
    
    public func disableTemporarily() {
        disableTemporarily(for: nil)
    }
        
    public func disableTemporarily(for time: TimeInterval? = nil) {
        enabled = false
        sensorDisableTimer?.invalidate()
        sensorDisableTimer = Timer.scheduledTimer(withTimeInterval: time ?? sensorDisableDuration,
                                                  repeats: false) { [weak self] _ in
            self?.disableTemporarilyTimerDidFire()
        }
    }
    
    private func disableTemporarilyTimerDidFire() {
        enable()
    }
    
    private func enable() {
        enabled = true
        sensorDisableTimer?.invalidate()
        
        if motionDetected {
            state = .motionDetected
        } else {
            state = .motionNotDetected
        }
    }
    
    public func toogleEnabled() {
        if enabled {
            disableTemporarily(for: 60*60*5) // 5 hours
        } else {
            enable()
        }
    }
    
    public func statePublisher() -> AnyPublisher<DetectionState, Never> {
        $state.eraseToAnyPublisher()
    }
}
