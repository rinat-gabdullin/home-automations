//
//  Button.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Combine

public enum PushButtonEvent {
    case singleClick
    case doubleClick
    case longPress
}

public final class PushButton: Device<Bool> {
    
    @Published private(set) public var lastEvent = PushButtonEvent.singleClick
    
    public var detectEvents: [PushButtonEvent] = [.singleClick]

    private weak var longPressTimer: Timer?
    private weak var singlePressTimer: Timer?

    private var lastClick = Date.distantPast
    
    private var longPressDuration: TimeInterval = 0.5
    private var doubleClickDuration: TimeInterval = 0.25
    
    /// Useful in two cases:
    /// - 1. To skip startup zero value
    /// - 2. To ignore events after long press
    private var skipHoldUpEvents = true
    
    override public func didSetValue(oldValue: Bool) {
        if value {
            holdDown()
        } else {
            holdUp()
        }
    }
    
    private func holdDown() {
        singlePressTimer?.invalidate()
        longPressTimer?.invalidate()
        skipHoldUpEvents = false
        
        longPressTimer = Timer.scheduledTimer(withTimeInterval: longPressDuration,
                                              repeats: false) { [weak self] _ in
            self?.didDetectLongPress()
        }
        
        if detectEvents == [.singleClick] {
            didDetectSingleClick()
        }
    }
    
    private func singlePressTimerFire() {
        didDetectSingleClick()
    }

    private func holdUp() {
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
            
        } else if detectEvents != [.singleClick] {
            singlePressTimer = Timer.scheduledTimer(withTimeInterval: doubleClickDuration,
                                                    repeats: false) { [weak self] _ in
                self?.singlePressTimerFire()
            }
        }
    }
    
    private func didDetectSingleClick() {
        if detectEvents.contains(.singleClick) {
            lastEvent = .singleClick
        }
    }
    
    private func didDetectDoubleClick() {
        if detectEvents.contains(.doubleClick) {
            lastEvent = .doubleClick
        }
    }
    
    private func didDetectLongPress() {
        skipHoldUpEvents = true
        if detectEvents.contains(.longPress) {
            lastEvent = .longPress
        }
    }
}
