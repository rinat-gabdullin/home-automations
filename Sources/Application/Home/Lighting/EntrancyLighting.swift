//
//  EntrancyLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import Presentation
import CodeSupport

class EntrancyLighting: LightningRule {
    
    @Published private var state = LightingState.off 
    
    private let leftButton: PushButton
    private let rightButton: PushButton
    
    init(dimmer: Field<Int>,
         led: Field<Int>,
         mirrorSwitch: Field<Bool>,
         leftButton: PushButton,
         rightButton: PushButton) {
        
        // To retain buttons:
        self.leftButton = leftButton
        self.rightButton = rightButton
        
        [leftButton, rightButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }
        
        super.init(restorableDisablingDevices: [dimmer, led, mirrorSwitch])
        
        // Light control buttons handling:
                
        leftButton
            .onActionDetectedPublisher()
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .lounge
                case .doubleClick: return .off
                case .longPress: return nil
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

        // State handling for mirror backlight:

        $state
            .map { state -> Bool in
                switch state {
                case .off: return false
                default: return true
                }
            }
            .write(to: mirrorSwitch)
            .store(in: &subscriptions)
        
    }
    
    func onTurnOffEverything() -> AnyPublisher<Void, Never> {
        leftButton
            .onActionDetectedPublisher()
            .filter { $0 == .longPress }
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}
