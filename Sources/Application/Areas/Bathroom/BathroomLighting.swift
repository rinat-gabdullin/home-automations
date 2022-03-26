//
//  BathroomLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation
import DeviceAreas

class BathroomLighting: LightningRule<BathroomDevices> {
        
    @Published private var state = LightingState.off
    
    override func setup() {
        
        let sensor = devices.sensor
        let leftButton = devices.leftButton
        let rightButton = devices.rightButton
        
        sensor.noMotionNotifyPeriod = 6 * 10 * 10
        
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
            .sink { _ in
                sensor.disableTemporarily()
            }
            .store(in: &subscriptions)
        
        $state
            .map { state -> Int in
                switch state {
                case .off:
                    return 0
                case .lounge:
                    return 30
                case .auto:
                    return 100
                case .bright:
                    return 100
                }
            }
            .assignWeak(to: \.led, on: devices)
            .store(in: &subscriptions)
        
        $state
            .map { state -> Int in
                switch state {
                case .off, .lounge:
                    return 0
                case .auto:
                    return 80
                case .bright:
                    return 100
                }
            }
            .assignWeak(to: \.dimmer, on: devices)
            .store(in: &subscriptions)
        
    }
}
