//
//  Button.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

enum PushButtonEvent {
    case singleClick
    case doubleClick
    case longPress
}

protocol PushButtonOutput: AnyObject {
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent)
}

class PushButton: Device<Int> {
    weak var output: PushButtonOutput?
    var detectEvents: [PushButtonEvent] = [.singleClick]

    private weak var longPressTimer: Timer?
    private weak var singlePressTimer: Timer?

    private var lastClick = Date.distantPast
    
    private var longPressDuration: TimeInterval = 0.5
    private var doubleClickDuration: TimeInterval = 0.25
    
    /// Useful in two cases:
    /// - 1. To skip startup zero value
    /// - 2. To ignore events after long press
    private var skipHoldUpEvents = true
    
    override func didChangeValue(to newValue: Int) {
        if newValue == 1 {
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
            output?.pushButton(pushButton: self, didFire: .singleClick)
        }
    }
    
    private func didDetectDoubleClick() {
        if detectEvents.contains(.doubleClick) {
            output?.pushButton(pushButton: self, didFire: .doubleClick)
        }
    }
    
    private func didDetectLongPress() {
        skipHoldUpEvents = true
        if detectEvents.contains(.longPress) {
            output?.pushButton(pushButton: self, didFire: .longPress)
        }
    }
}
