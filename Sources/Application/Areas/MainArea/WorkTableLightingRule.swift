//
//  WorkTableLighting.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation
import DeviceAreas
import Combine

class WorkTableLightingRule: LightningRule<MainAreaDevices> {

    override func setup() {
        
        devices.hueSwitchAction
            .filter { $0 == .onPress }
            .sink(receiveValue: { [weak self] _ in
                self?.devices.workingTable.toggle()
            })
            .store(in: &subscriptions)
    }
}
