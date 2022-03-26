//
//  Assembler.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation
import DeviceAreas

public final class Assembler {
    enum Error: Swift.Error {
        case invalidUrl
    }
    
    public static func assembly() throws -> Any {
        
        guard let url = URL(string: "mqtt://192.168.0.2:1883") else {
            throw Error.invalidUrl
        }
        
        let devicesFactory = try DeviceAreasFactory(serverUrl: url)
        
        let home = Home(mainArea: Area(devices: devicesFactory.makeMainAreaDevices()),
                        sleepingArea: Area(devices: devicesFactory.makeBedroomDevices()),
                        entrancyArea: Area(devices: devicesFactory.makeEntrancyDevices()),
                        bathroomArea: Area(devices: devicesFactory.makeBathroomDevices()))
                        
        return (home, devicesFactory)
        
    }
}
