//
//  EntrancyLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import DeviceAreas
import CodeSupport

class EntrancyLighting: LightningRule<EntrancyDevices> {
    
    @Published private var state = LightingState.off 
    
    override func setup() {
        
        let leftButton = devices.leftButton
        let rightButton = devices.rightButton
        
        [leftButton, rightButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }
        
        leftButton
            .onActionDetectedPublisher()
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .lounge
                case .longPress: return .off
                case .doubleClick: return nil
                }
            }
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        
        rightButton
            .onActionDetectedPublisher()
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .auto
                case .longPress: return .bright
                default: return nil
                }
            }
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        // State handling for dimmer and led:

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
            .assign(to: \.led, on: devices)
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
            .assign(to: \.dimmer, on: devices)
            .store(in: &subscriptions)

        // State handling for mirror backlight:

        $state
            .map { state -> Bool in
                switch state {
                case .off: return false
                default: return true
                }
            }
            .assign(to: \.mirrorSwitch, on: devices)
            .store(in: &subscriptions)
        
    }
    
}
