//
//  Button.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Combine

public enum Action: Equatable {
    case singleClick
    case doubleClick
    case longPress
}

public final class PushButton: Device<Bool> {
    
    @Published private var lastAction: Action?
    @Published private var longPressDetected = false

    public var detectedActions: [Action] = [.singleClick]

    private weak var longPressTimer: Timer?
    private weak var singlePressTimer: Timer?

    private var lastClick = Date.distantPast
    
    private var longPressDuration: TimeInterval = 0.3
    private var doubleClickDuration: TimeInterval = 0.25
    
    /// Useful in two cases:
    /// - 1. To skip startup zero value
    /// - 2. To ignore events after long press
    private var skipHoldUpEvents = true
    
    override public func didSetValue(oldValue: Bool) {
        guard !isInitialValue else {
            return
        }
        
        if value {
            holdDown()
        } else {
            holdUp()
        }
    }
    
    public func onActionDetectedPublisher() -> AnyPublisher<Action, Never> {
        $lastAction
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    public func longPressPublisher() -> AnyPublisher<Bool, Never> {
        $longPressDetected
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    private func holdDown() {
        singlePressTimer?.invalidate()
        longPressTimer?.invalidate()
        skipHoldUpEvents = false
        
        longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressDuration,
                                              repeats: false) { [weak self] _ in
            self?.didDetectLongPress()
        }
        
        if detectedActions == [.singleClick] {
            didDetectSingleClick()
        }
    }
    
    private func singlePressTimerFire() {
        didDetectSingleClick()
    }

    private func holdUp() {
        longPressDetected = false
        singlePressTimer?.invalidate()
        longPressTimer?.invalidate()
 
        defer {
            lastClick = Date()
        }
        
        if skipHoldUpEvents {
            skipHoldUpEvents = false
            return
        }
        
        if lastClick.distance(to: Date()) < doubleClickDuration {
            singlePressTimer?.invalidate()
            didDetectDoubleClick()
            
        } else if detectedActions != [.singleClick] {
            singlePressTimer = Timer.scheduledTimer(withTimeInterval: doubleClickDuration,
                                                    repeats: false) { [weak self] _ in
                self?.singlePressTimerFire()
            }
        }
    }
    
    private func didDetectSingleClick() {
        if detectedActions.contains(.singleClick) {
            lastAction = .singleClick
        }
    }
    
    private func didDetectDoubleClick() {
        if detectedActions.contains(.doubleClick) {
            lastAction = .doubleClick
        }
    }
    
    private func didDetectLongPress() {
        longPressDetected = true
        skipHoldUpEvents = true
        if detectedActions.contains(.longPress) {
            lastAction = .longPress
        }
    }
}
