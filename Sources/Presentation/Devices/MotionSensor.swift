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
        
    var sensorDisableDuration: TimeInterval = 60*30
    
    public var noMotionNotifyPeriod: TimeInterval = 3*60
    
    private var enabled = true

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
            state = .motionDetected
        } else {
            state = .motionNotDetected
        }
    }
    
    public func statePublisher() -> AnyPublisher<DetectionState, Never> {
        $state.eraseToAnyPublisher()
    }
}
