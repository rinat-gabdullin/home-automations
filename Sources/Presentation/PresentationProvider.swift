//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Session
import Combine

public final class PresentationProvider {
    
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
    /// - Contact 3:
    /// - Contact 4:
    /// - Contact 5:
    /// - Contact 6:
    public let relayBig2: WirenboardRelay
    
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
    public let relaySmall1: WirenboardRelay
    
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
    public let relaySmall2: WirenboardRelay
    
    public let input1: WirenboardInput
    
    public let hueSwitchAction: AnyPublisher<HueSwitchAction, Never>
    
    public let bedroomBedLight1: Field<ZigbeeLightPayload>
    public let bedroomBedLight2: Field<ZigbeeLightPayload>
    
    public let mainTrackLight1: Field<ZigbeeLightPayload>
    public let mainTrackLight2: Field<ZigbeeLightPayload>
    public let mainTrackLight3: Field<ZigbeeLightPayload>
    public let mainTrackLight4: Field<ZigbeeLightPayload>
    public let mainTrackLight5: Field<ZigbeeLightPayload>
    
    public let mainLamp: Field<ZigbeeLightPayload>
    
    public let countertopSensor: ZigbeeSensor
    public let cloakroomSensor: ZigbeeSensor
    public let kitchenTableSensor: ZigbeeSensor
    
    public init(serverUrl: URL) throws {
        let session = try MQTTSession(serverUrl: serverUrl)

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
        
        hueSwitchAction = TopicPublisher(topic: "/zigbee/switches/action", session: session)
            .catch { _ in Empty(completeImmediately: false) }
            .removeDuplicates()
            .eraseToAnyPublisher()
        
        bedroomBedLight1 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/sleeping/bra").projectedValue
        bedroomBedLight2 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/sleeping/lamp").projectedValue

        mainTrackLight1 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/main/track-1").projectedValue
        mainTrackLight2 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/main/track-2").projectedValue
        mainTrackLight3 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/main/track-3").projectedValue
        mainTrackLight4 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/main/track-4").projectedValue
        mainTrackLight5 = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/main/track-5").projectedValue

        mainLamp = WritableBinding(session: session, zigbeeDeviceTopicPath: "/zigbee/main/shelf").projectedValue

        countertopSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/kitchen/countertop-sensor"))
        kitchenTableSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/kitchen/table-sensor"))
        cloakroomSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/enter/cloakroom-sensor"))
    }
}
