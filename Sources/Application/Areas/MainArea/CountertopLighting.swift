//
//  CountertopLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import DeviceAreas
import CodeSupport

class CountertopLighting: LightningRule<MainAreaDevices> {

    override func setup() {
       
        devices.kitchenButton1.detectedActions = [.doubleClick, .singleClick]
        
        let signal = devices.$led
            .compactMap(Int.init)
            .map { $0 > 50 ? true : false }
        
        signal
            .assign(to: \.cookerHood, on: devices)
            .store(in: &subscriptions)
        
        signal
            .assign(to: \.trackKitchen, on: devices)
            .store(in: &subscriptions)
        
        devices.countertopSensor
            .$state
            .map { state in
                if state == .motionDetected {
                    if Solar().isDaytime {
                        return 100
                    } else {
                        return 50
                    }
                }
                return 0 }
            .assign(to: \.led, on: devices)
            .store(in: &subscriptions)
        
        devices.kitchenButton1
            .onActionDetectedPublisher()
            .sink { [weak self] action in
                switch action {
                case .singleClick: self?.toggle()
                case .doubleClick: self?.devices.countertopSensor.toogleEnabled()
                default: break
                }
            }
            .store(in: &subscriptions)
    }
    
    func toggle() {
        devices.countertopSensor.disableTemporarily()
        devices.led = devices.led > 0 ? 0 : 100
    }
        
}
