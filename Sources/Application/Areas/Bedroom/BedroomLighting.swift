//
//  SleepingRoomLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation
import DeviceAreas
import Combine

class BedroomLighting: LightningRule<BedroomDevices> {
    
    @Published private var state = LightingState.off
    
    private var producer = PassthroughSubject<Void, Never>()

    public var onHomeLightsOffSignal: AnyPublisher<Void, Never> {
        producer.eraseToAnyPublisher()
    }

    override func setup() {
        
        let leftEnterButton = devices.leftEnterButton
        let rightEnterButton = devices.rightEnterButton
        
        [leftEnterButton, rightEnterButton, devices.bedRightButton, devices.bedLeftButton].forEach { button in
            button.detectedActions = [.longPress, .doubleClick, .singleClick]
        }
        
        devices
            .bedLeftButton
            .onActionDetectedPublisher()
            .merge(with: devices.bedRightButton.onActionDetectedPublisher())
            .sink { action in
                switch action {
                case .singleClick: self.toogle(to: .lounge)
                case .doubleClick: return self.producer.send()
                case .longPress: self.toogle(to: .auto)
                }
            }
            .store(in: &subscriptions)

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
            .sink(receiveValue: { [weak devices] output in
                devices?.lampRight.brightness = output
                devices?.lampLeft.brightness = output
            })
            .store(in: &subscriptions)
    }
    
    private func toogle(to state: LightingState) {
        if self.state == state {
            self.state = .off
        } else {
            self.state = state
        }
    }

}
