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
    
    internal init(leftButton: PushButton,
                  rightButton: PushButton,
                  dimmer: Field<Int>,
                  led: Field<Int>) {
        
        self.leftButton = leftButton
        self.rightButton = rightButton
        super.init(restorableDisablingDevices: [dimmer, led])
        
        [leftButton, rightButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }
        
        leftButton
            .onActionDetectedPublisher()
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .lounge
                case .doubleClick: return .off
                case .longPress: return .off
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
