//
//  CloakroomLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation
import DeviceAreas

class CloakroomLighting: LightningRule<EntrancyDevices> {
  
    override func setup() {
        
        devices.sensor
            .$state
            .map { $0 == .motionDetected }
            .assignWeak(to: \.lightSwitch, on: devices)
            .store(in: &subscriptions)
        
    }
}
