//
//  LightLevelProvider.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Presentation

class MainRoomLighting: LightningRule {
    
    @Published private var state = LightingState.off
    
    private let leftButton: PushButton
    private let rightButton: PushButton
    
    init(dimmer: Field<Int>,
         trackLight1: Field<ZigbeeLightPayload>,
         trackLight2: Field<ZigbeeLightPayload>,
         trackLight3: Field<ZigbeeLightPayload>,
         trackLight4: Field<ZigbeeLightPayload>,
         trackLight5: Field<ZigbeeLightPayload>,
         lamp: Field<ZigbeeLightPayload>,

         leftButton: PushButton,
         rightButton: PushButton) {
        
        // To retain buttons:
        self.leftButton = leftButton
        self.rightButton = rightButton
        
        [leftButton, rightButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }
        
        super.init(restorableDisablingDevices: [dimmer, trackLight1, trackLight2, trackLight3, trackLight4, trackLight5, lamp])
        
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
            .sink(receiveValue: { [weak trackLight1, weak trackLight2, weak trackLight3, weak trackLight4, weak trackLight5, weak lamp] output in
                trackLight1?.wrappedValue.brightness = output
                trackLight2?.wrappedValue.brightness = output
                trackLight3?.wrappedValue.brightness = output
                trackLight4?.wrappedValue.brightness = output
                trackLight5?.wrappedValue.brightness = output
                lamp?.wrappedValue.brightness = output
                
            })
            .store(in: &subscriptions)

    }
}
