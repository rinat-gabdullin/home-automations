//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import DeviceAreas
import Foundation

class BathroomAccessoires: Rule<BathroomDevices> {
    
    override func setup() {
        
        // Initially off:
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
            self.devices.towelDryer = false
            self.devices.fan = false
        }
        
        // Switching/enabling
        
        devices
            .internalButton1
            .onPressDetect()
            .sink { _ in
                self.devices.fan.toggle()
            }
            .store(in: &subscriptions)
        
        
        devices
            .internalButton2
            .onPressDetect()
            .sink { _ in
                self.devices.towelDryer = true
            }
            .store(in: &subscriptions)
        
        // Disable towel dryer in 60 mins:
        
        devices.$towelDryer
            .debounce(for: .seconds(60 * 60), scheduler: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                self.devices.towelDryer = false
            }
            .store(in: &subscriptions)
        
        // Disable toilet fan in 5 mins:
        
        devices.$fan
            .debounce(for: .seconds(60 * 5), scheduler: DispatchQueue.main)
            .filter { $0 }
            .sink { _ in
                self.devices.fan = false
            }
            .store(in: &subscriptions)
    }
}
