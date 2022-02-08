//
//  Shield.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

/**
 Template:
 
 /// Device model
 /// - MQTT identifier:
 /// - Modbus identifier:
 */

import Foundation
import Session

final class WirenboardHardware {
    
    private let session: MQTTSession
    
    internal init(session: MQTTSession) {
        self.session = session
    }
    
    /*
     
    /// WB-MSW v.3
    /// - MQTT identifier: sensor-bathroom
    /// - Modbus identifier: 159
    /// - Location: bathroom
    
    /// WB-MSW v.3
    /// - MQTT identifier: sensor-hall
    /// - Modbus identifier: 135
    /// - Location: hall
    
    /// Dimmer
    /// - MQTT identifier: 122
    /// - Modbus identifier: dimmer
    /// - Location: main box
    /// - Contact 1: Main room light spots
    /// - Contact 2: Kitchen table light
    /// - Contact 3: Entrancy light spots

    /// Dimmer in small box
    /// - MQTT identifier: dimmer-2
    /// - Modbus identifier: 183
    /// - Contact 1: Sleeping room light spots
    /// - Contact 2: Bathroom light spots
    /// - Contact 3: Bathroom fan

    /// LED Controller
    /// - MQTT identifier: led
    /// - Modbus identifier: 181
    /// - Location: main box
    /// - Contact 1: Entrancy LED
    /// - Contact 2: Kitchen LED
    /// - Contact 3: Bathroom LED
    /// - Contact 4: Sleeping room LED
     
     */
    
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
    lazy private(set) var relayBig1 = WirenboardRelay(deviceName: "relay-big-1", session: session)
    
    /// Relay
    /// - MQTT identifier: relay-big-2
    /// - Modbus identifier: 113
    /// - Location: main box
    /// - Contact 1:
    /// - Contact 2:
    /// - Contact 3:
    /// - Contact 4:
    /// - Contact 5:
    /// - Contact 6:
    lazy private(set) var relayBig2 = WirenboardRelay(deviceName: "relay-big-2", session: session)
    
    /// Relay
    /// - MQTT identifier: relay-small-1
    /// - Modbus identifier: 1
    /// - Location: small box
    /// - Contact 1:
    /// - Contact 2:
    /// - Contact 3:
    /// - Contact 4: Balcony light
    /// - Contact 5:
    /// - Contact 6: Bedroom right lamp
    lazy private(set) var relaySmall1 = WirenboardRelay(deviceName: "relay-small-1", session: session)
    
    /// Relay
    /// - MQTT identifier: relay-small-2
    /// - Modbus identifier: 230
    /// - Location: small box
    /// - Contact 1: Floor heater 1
    /// - Contact 2: Water control 1 (not sure!)
    /// - Contact 3: Water control 2 (not sure!)
    /// - Contact 4: Floor heater 2
    /// - Contact 5: Entrancy mirror LED
    /// - Contact 6:
    lazy private(set) var relaySmall2 = WirenboardRelay(deviceName: "relay-small-2", session: session)
}
