//
//  BathroomLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation
import Presentation

class BathroomLighting: LightningRule {
        
    @Published private var state = LightingState.off
    
    private let leftButton: PushButton
    private let rightButton: PushButton
    private let sensor: MSWMotionSensor
    
    internal init(leftButton: PushButton,
                  rightButton: PushButton,
                  sensor: MSWMotionSensor,
                  dimmer: Field<Int>,
                  led: Field<Int>) {
        
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.sensor = sensor
        
        sensor.noMotionNotifyPeriod = 6 * 10
        
        super.init(restorableDisablingDevices: [dimmer, led])
    
        sensor
            .$state
            .map { detectionState -> (LightingState) in
                switch detectionState {
                case .motionDetected: return .auto
                case .motionNotDetected: return .lounge
                }
            }
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        [leftButton, rightButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }
        
        let onLeftButton = leftButton
            .onActionDetectedPublisher()
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .lounge
                case .doubleClick: return .off
                case .longPress: return .off
                }
            }

        onLeftButton
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        let onRightButton = rightButton
            .onActionDetectedPublisher()
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .auto
                case .longPress: return .bright
                default: return nil
                }
            }
        
        onRightButton
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        onLeftButton
            .merge(with: onRightButton)
            .sink { [weak self] _ in
                self?.sensor.disableTemporarily()
            }
            .store(in: &subscriptions)
        
        $state
            .map { state -> Int in
                switch state {
                case .off:
                    return 0
                case .auto, .lounge:
                    return 50
                case .bright:
                    return 100
                }
            }
            .write(to: led)
            .store(in: &subscriptions)
        
        $state
            .map { state -> Int in
                switch state {
                case .off, .lounge:
                    return 0
                case .auto:
                    return 50
                case .bright:
                    return 100
                }
            }
            .write(to: dimmer)
            .store(in: &subscriptions)
        
    }
}
