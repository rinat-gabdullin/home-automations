//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 02.04.2022.
//

import Foundation
import DeviceAreas
import Combine

class BedroomCurtains: Rule<BedroomDevices> {
    override func setup() {
        let left = devices.curtainsLeft.onPressDetect().map { 0 }
        let right = devices.curtainsRight.onPressDetect().map { 50 }
        left
            .merge(with: right)
            .sink { position in
                self.devices.curtain = position
            }
            .store(in: &subscriptions)
    }
}
