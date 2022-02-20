//
//  SleepingRoomLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation
import Presentation

class BedroomLighting: LightningRule {
    
    @Published private var state = LightingState.off
    
    private let leftEnterButton: PushButton
    private let rightEnterButton: PushButton
    
    internal init(leftEnterButton: PushButton,
                  rightEnterButton: PushButton,
                  dimmer: Field<Int>,
                  led: Field<Int>,
                  lampLeft: Field<ZigbeeLightPayload>,
                  lampRight: Field<ZigbeeLightPayload>) {
        
        self.leftEnterButton = leftEnterButton
        self.rightEnterButton = rightEnterButton
        super.init(restorableDisablingDevices: [dimmer, led, lampRight, lampLeft])
        
        [leftEnterButton, rightEnterButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }

        leftEnterButton
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
        
        
        rightEnterButton
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
                
        $state
            .map { state -> Int in
                switch state {
                case .off:
                    return 0
                case .lounge:
                    return 1
                case .auto:
                    return 100
                case .bright:
                    return 255
                }
            }
            .sink(receiveValue: { [weak lampRight, weak lampLeft] output in
                lampRight?.wrappedValue.brightness = output
                lampLeft?.wrappedValue.brightness = output
            })
            .store(in: &subscriptions)
    }

}
