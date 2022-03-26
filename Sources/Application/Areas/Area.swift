//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import DeviceAreas

class Area<Devices> {
    
    typealias AreaRule = Rule<Devices>
    
    var devices: Devices
    private var rules = [AreaRule]()

    internal init(devices: Devices) {
        self.devices = devices
    }
    
    func add(rule: AreaRule) {
        rules.append(rule)
    }
}
