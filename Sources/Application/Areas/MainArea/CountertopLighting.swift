//
//  CountertopLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import DeviceAreas

class CountertopLighting: LightningRule<MainAreaDevices> {

    override func setup() {
        
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
            .map { $0 == .motionDetected ? 100 : 0 }
            .assign(to: \.led, on: devices)
            .store(in: &subscriptions)
        
        devices.kitchenButton1
            .onActionDetectedPublisher()
            .sink { [weak self] _ in
                self?.toggle()
            }
            .store(in: &subscriptions)
    }
    
    func toggle() {
        devices.countertopSensor.disableTemporarily()
        devices.led = devices.led > 0 ? 0 : 100
    }
        
}
