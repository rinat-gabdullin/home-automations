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
        
        let bedroomLightingRule =
        BedroomLighting(leftEnterButton: PushButton(publisher: provider.input1.$sleeping1),
                        rightEnterButton: PushButton(publisher: provider.input1.$sleeping2),
                        dimmer: provider.dimmer2.$channel1,
                        led: provider.led.$channel4,
                        lampLeft: provider.bedroomBedLight1,
                        lampRight: provider.bedroomBedLight2)
        
        
        let bathLightingRule =
        BathroomLighting(leftButton: PushButton(publisher: provider.input1.$bathroom1),
                         rightButton: PushButton(publisher: provider.input1.$bathroom2),
                         dimmer: provider.dimmer2.$channel2,
                         led: provider.led.$channel3)
        
        let mainRoomRule = MainRoomLighting(dimmer: provider.dimmer1.$channel1,
                                            trackLight1: provider.mainTrackLight1,
                                            trackLight2: provider.mainTrackLight2,
                                            trackLight3: provider.mainTrackLight3,
                                            trackLight4: provider.mainTrackLight4,
                                            trackLight5: provider.mainTrackLight5,
                                            lamp: provider.mainLamp,
                                            leftButton: PushButton(publisher: provider.input1.$hall1),
                                            rightButton: PushButton(publisher: provider.input1.$hall2))
        
        let countertop = CountertopLighting(led: provider.led.$channel2,
                                            sensor: provider.countertopSensor,
                                            pushButton: PushButton(publisher: provider.input1.$table1),
                                            trackLight: provider.relayBig1.$contact2,
                                            cookerHood: provider.wirenboardHS.$contact3)
        
        let cloakroom = CloakroomLighting(lightSwitch: provider.relayBig1.$contact6, sensor: provider.cloakroomSensor)
        
        let kitchenTable = KitchenTableLighting(light: provider.dimmer1.$channel2,
                                                sensor: provider.kitchenTableSensor,
                                                pushButton: PushButton(publisher: provider.input1.$table2))
        
        let homeControl = HomeControl(lightningRules: [entrancyLighting,
                                                       workTableLightingRule,
                                                       bathLightingRule,
                                                       mainRoomRule,
                                                       cloakroom,
                                                       kitchenTable,
                                                       bedroomLightingRule,
                                                       countertop],
                                      lightsOffSignal: entrancyLighting.onTurnOffEverything())
        return (homeControl, provider)
        
    }
}
