//
//  LightLevelProvider.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Combine
import DeviceAreas

class MainRoomLighting: LightningRule<MainAreaDevices> {
    
    @Published private var state = LightingState.off
    
    lazy var leftButton = devices.leftButton
    lazy var rightButton = devices.rightButton
    
    override func setup() {
        
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
                case .off, .lounge:
                    return 0
                case .auto:
                    return 50
                case .bright:
                    return 100
                }
            }
            .assignWeak(to: \.ceiling, on: devices)
            .store(in: &subscriptions)

        $state
            .map { state -> Bool in
                state != .off
            }
            .assignWeak(to: \.shelfLight, on: devices)
            .store(in: &subscriptions)

        $state
            .map { state -> Int in
                switch state {
                case .off:
                    return 0
                case .lounge:
                    return 10
                case .auto:
                    return 100
                case .bright:
                    return 255
                }
            }
            .sink(receiveValue: { [weak devices] output in
                devices?.trackLight1.brightness = output
                devices?.trackLight2.brightness = output
                devices?.trackLight3.brightness = output
                devices?.trackLight4.brightness = output
                devices?.trackLight5.brightness = output
                devices?.lamp.brightness = output
                
            })
            .store(in: &subscriptions)

        $state
            .filter { $0 == .off }
            .sink { [weak devices] _ in
                devices?.led = 0
                devices?.kitchenTable = 0
            }
            .store(in: &subscriptions)
        
        $state
            .compactMap {
                switch $0 {
                case .off: return false
                case .bright: return true
                default: return nil
                }
            }
            .sink { [weak devices] state in
                devices?.workingTable = state
            }
            .store(in: &subscriptions)
    }
}
