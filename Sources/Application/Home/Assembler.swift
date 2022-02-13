//
//  Assembler.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation
import Presentation

public final class Assembler {
    enum Error: Swift.Error {
        case invalidUrl
    }
    
    public static func assembly() throws -> Any {
        
        guard let url = URL(string: "mqtt://192.168.0.2:1883") else {
            throw Error.invalidUrl
        }
        
        let provider = try PresentationProvider(serverUrl: url)
        
        let entrancyLighting =
            EntrancyLighting(dimmer: provider.dimmer1.$channel3,
                             led: provider.led.$channel1,
                             mirrorSwitch: provider.relaySmall2.$contact5,
                             leftButton: PushButton(publisher: provider.input1.$enter1),
                             rightButton: PushButton(publisher: provider.input1.$enter2))
        
        let workTableLightingRule = WorkTableLightingRule(lightSwitch: provider.relayBig1.$contact3,
                                                          hueSwitch: provider.hueSwitchAction)
        
        let homeControl = HomeControl(rules: [entrancyLighting, workTableLightingRule])
        return (homeControl, provider)
        
    }
}
