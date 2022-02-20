//
//  CountertopLightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import Foundation
import Presentation

class CountertopLighting: LightningRule {
    
    let led: Field<Int>
    let sensor: ZigbeeSensor
    let pushButton: PushButton
    let trackLight: Field<Bool>
    let cookerHood: Field<Bool>
    
    internal init(led: Field<Int>, sensor: ZigbeeSensor, pushButton: PushButton, trackLight: Field<Bool>, cookerHood: Field<Bool>) {
        
        self.led = led
        self.sensor = sensor
        self.pushButton = pushButton
        self.trackLight = trackLight
        self.cookerHood = cookerHood
        
        super.init(restorableDisablingDevices: [led, trackLight, cookerHood])
        
        let signal = led.projectedValue
            .compactMap(Int.init)
            .map { $0 > 50 ? true : false }
        
        signal
            .write(to: cookerHood)
            .store(in: &subscriptions)
        
        signal
            .write(to: trackLight)
            .store(in: &subscriptions)
        
        sensor
            .$state
            .map { $0 == .motionDetected ? 100 : 0 }
            .write(to: led)
            .store(in: &subscriptions)
        
        pushButton
            .onActionDetectedPublisher()
            .sink { [weak self] _ in
                self?.toggle()
            }
            .store(in: &subscriptions)
    }
    
    func toggle() {
        sensor.disableTemporarily()
        led.wrappedValue = led.wrappedValue > 0 ? 0 : 100
    }
        
}
