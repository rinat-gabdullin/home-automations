//
//  MotionSensor.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Combine
import CodeSupport

public enum DetectionState: Equatable {
    case motionDetected
    case motionNotDetected
    case motionNotDetectedWarning
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

protocol CancellableTask {
    func cancel()
}

extension Task: CancellableTask {
    
}

extension MotionSensor {
    public struct Configuration {
        public var sensorDisableDuration: Int = 60*40
        public var noMotionNotifyPeriod: Int = 3*60
        public var warningTimeout: Int = 10
    }
}

public class MotionSensor<T: Payload>: Device<T>, MotionDetection {
    
    @Published private(set) public var state = DetectionState.motionNotDetected
        
    public var configuration = Configuration()

    // State
    
    public private(set) var enabled = true
    private var motionDetected = false

    // Timers:
    
    weak private var sensorDisableTimer: Timer?
    
    var noMotion: CancellableTask? {
        didSet { oldValue?.cancel() }
    }
    
    internal func didDetectMotion() {
        
        self.motionDetected = true
        
        if enabled {
            state = .motionDetected
        }
        
        let period = configuration.noMotionNotifyPeriod - configuration.warningTimeout
        
        noMotion = Task {
            try await Task.sleep(seconds: period)
            
            if enabled {
                state = .motionNotDetectedWarning
            }
            
            try await Task.sleep(seconds: configuration.warningTimeout)
            noMotionTimerDidFire()
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
        sensorDisableTimer = Timer.scheduledTimer(withTimeInterval: time ?? TimeInterval(configuration.sensorDisableDuration),
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
