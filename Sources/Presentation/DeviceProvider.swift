//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Connection
import Combine

public final class DeviceProvider {
    
    /// WBIO-DO-HS-8
    /// - Contact 1:
    /// - Contact 2:
    /// - Contact 3: Cooker hood
    /// - Contact 4:
    /// - Contact 5:
    /// - Contact 6:
    /// - Contact 7:
    /// - Contact 8:
    public let wirenboardHS: WirenboardHS
    
    /// WB-MSW v.3
    /// - MQTT identifier: sensor-bathroom
    /// - Modbus identifier: 159
    /// - Location: bathroom
    public let sensorBathroom: WirenboardMSW
    
    /// WB-MSW v.3
    /// - MQTT identifier: sensor-hall
    /// - Modbus identifier: 135
    /// - Location: hall
    public let sensorHall: WirenboardMSW
    
    /// Dimmer
    /// - MQTT identifier: 122
    /// - Modbus identifier: dimmer
    /// - Location: main box
    /// - Contact 1: Main room light spots
    /// - Contact 2: Kitchen table light
    /// - Contact 3: Entrancy light spots
    public let dimmer1: WirenboardMDM3
    
    /// Dimmer in small box
    /// - MQTT identifier: dimmer-2
    /// - Modbus identifier: 183
    /// - Contact 1: Sleeping room light spots
    /// - Contact 2: Bathroom light spots
    /// - Contact 3: Bathroom fan
    public let dimmer2: WirenboardMDM3
    
    /// LED Controller
    /// - MQTT identifier: led
    /// - Modbus identifier: 181
    /// - Location: main box
    /// - Contact 1: Entrancy LED
    /// - Contact 2: Kitchen LED
    /// - Contact 3: Bathroom LED
    /// - Contact 4: Sleeping room LED
    public let led: WirenboardMRGBW
    
    /// Relay
    /// - MQTT identifier: relay-big-1
    /// - Modbus identifier: 11
    /// - Location: main box
    /// - Contact 1:
    /// - Contact 2: Kitchen track light
    /// - Contact 3: Workzone light
    /// - Contact 4:
    /// - Contact 5:
    /// - Contact 6: Cloakroom
    public let relayBig1: WirenboardRelay
    
    /// Relay
    /// - MQTT identifier: relay-big-2
    /// - Modbus identifier: 113
    /// - Location: main box
    /// - Contact 1:
    /// - Contact 2:
    /// - Contact 3: Main room shelf
    /// - Contact 4:
    /// - Contact 5:
    /// - Contact 6:
    /// - Input 1:
    /// - Input 2:
    /// - Input 3:
    /// - Input 4: Bedroom curtain Right
    /// - Input 5: Bedroom curtain Left
    /// - Input 6:
    public let relayBig2: WirenboardRelay
    
    /// Relay
    /// - MQTT identifier: relay-small-1
    /// - Modbus identifier: 12
    /// - Location: small box
    /// - Contact 1: 
    /// - Contact 2:
    /// - Contact 3: Towel Dryer
    /// - Contact 4: Balcony light
    /// - Contact 5: Balcony floor heater
    /// - Contact 6: Bedroom right lamp
    public let relaySmall1: WirenboardRelay
    
    /// Relay
    /// - MQTT identifier: relay-small-2
    /// - Modbus identifier: 230
    /// - Location: small box
    /// - Contact 1: Floor heater 1
    /// - Contact 2: Water control 1
    /// - Contact 3: Water control 2
    /// - Contact 4: Floor heater 2
    /// - Contact 5: Entrancy mirror LED
    /// - Contact 6:
    public let relaySmall2: WirenboardRelay
    
    /// Input module
    /// - Input 1:
    /// - Input 2:
    /// - Input 3:
    /// - Input 4:
    /// - Input 5:
    /// - Input 6:
    /// - Input 7:
    /// - Input 8:
    /// - Input 9:
    /// - Input 10:
    /// - Input 11:
    /// - Input 12:
    /// - Input 13:
    /// - Input 14:
    public let input1: WirenboardInput
    
    public let session: MQTTConnection
    
    public init(serverUrl: URL) throws {
        session = try MQTTConnection(serverUrl: serverUrl)
        session.connect()
        
        wirenboardHS = WirenboardHS(deviceName: "wb-gpio", session: session)
        sensorBathroom = WirenboardMSW(deviceName: "sensor-bathroom", session: session)
        sensorHall = WirenboardMSW(deviceName: "sensor-hall", session: session)
        dimmer1 = WirenboardMDM3(deviceName: "dimmer", session: session)
        dimmer2 = WirenboardMDM3(deviceName: "dimmer-2", session: session)
        led = WirenboardMRGBW(deviceName: "led", session: session)
        relayBig1 = WirenboardRelay(deviceName: "relay-big-1", session: session)
        relayBig2 = WirenboardRelay(deviceName: "relay-big-2", session: session)
        relaySmall1 = WirenboardRelay(deviceName: "relay-small-1", session: session)
        relaySmall2 = WirenboardRelay(deviceName: "relay-small-2", session: session)
        input1 = WirenboardInput(deviceName: "wb-gpio", session: session)                
    }
    
}
