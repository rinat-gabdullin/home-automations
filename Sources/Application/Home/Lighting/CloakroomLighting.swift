//
//  CloakroomLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation
import Presentation

class CloakroomLighting: LightningRule {
        
    let lightSwitch: Field<Bool>
    let sensor: ZigbeeSensor
    
    internal init(lightSwitch: Field<Bool>, sensor: ZigbeeSensor) {
        self.lightSwitch = lightSwitch
        self.sensor = sensor
        
        super.init(restorableDisablingDevices: [lightSwitch])
        
        sensor
            .$state
            .map { $0 == .motionDetected }
            .assignWeak(to: \.lightSwitch.wrappedValue, on: self)
            .store(in: &subscriptions)
        
    }
}
