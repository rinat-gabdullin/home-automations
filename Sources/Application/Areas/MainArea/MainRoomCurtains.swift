//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 01.05.2022.
//

import Combine
import DeviceAreas

class MainRoomCurtains: LightningRule<MainAreaDevices> {
        
    override func setup() {
        devices.upButton.$value.sink { [devices] _ in
            devices.leftRollet.startStop(direction: true)
            devices.rightRollet.startStop(direction: true)
        }.store(in: &subscriptions)
        
        devices.downButton.$value.sink { [devices] _ in
            devices.leftRollet.startStop(direction: false)
            devices.rightRollet.startStop(direction: false)
        }.store(in: &subscriptions)
        
        
    }
}
