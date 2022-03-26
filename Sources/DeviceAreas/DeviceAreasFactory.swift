//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import Presentation
import Combine
import Foundation

final public class DeviceAreasFactory {

    let provider: DeviceProvider
    
    public init(serverUrl: URL) throws {
        self.provider = try DeviceProvider(serverUrl: serverUrl)
    }
    
    private func field<T>(topicPath: String) -> Field<T> where T: Equatable & Payload {
        WritableBinding(session: provider.session,
                        zigbeeDeviceTopicPath: .init(path: topicPath)).projectedValue
    }
    
    public func makeMainAreaDevices() -> MainAreaDevices {

        let session = provider.session
        let kitchenTableSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/kitchen/table-sensor"))
        
        let countertopSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/kitchen/countertop-sensor"))

        let hueSwitchAction = TopicPublisher<HueSwitchAction>(topic: "/zigbee/switches/action", session: session)
            .removeDuplicates()
            .eraseToAnyPublisher()

        return MainAreaDevices(
            leftButton: PushButton(publisher: provider.input1.$hall1),
            rightButton: PushButton(publisher: provider.input1.$hall2),
            centerButton: PushButton(publisher: provider.input1.$hallCenter),
            kitchenTable: provider.dimmer1.$channel2,
            tableSensor: kitchenTableSensor,
            kitchenButton1: PushButton(publisher: provider.input1.$table1),
            kitchenButton2: PushButton(publisher: provider.input1.$table2),
            led: provider.led.$channel2,
            trackKitchen: provider.relayBig1.$contact2,
            cookerHood: provider.wirenboardHS.$contact3,
            countertopSensor: countertopSensor,
            ceiling: provider.dimmer1.$channel1,
            workingTable: provider.relayBig1.$contact3,
            lamp: field(topicPath: "/zigbee/main/shelf"),
            hueSwitchAction: hueSwitchAction,
            trackLight1: field(topicPath: "/zigbee/main/track-1"),
            trackLight2: field(topicPath: "/zigbee/main/track-2"),
            trackLight3: field(topicPath: "/zigbee/main/track-3"),
            trackLight4: field(topicPath: "/zigbee/main/track-4"),
            trackLight5: field(topicPath: "/zigbee/main/track-5")
        )
        
    }
    
    public func makeEntrancyDevices() -> EntrancyDevices {
        let cloakroomSensor = ZigbeeSensor(publisher: provider.session.subscribe(topicPath: "/zigbee/enter/cloakroom-sensor"))
        
        return EntrancyDevices(dimmer: provider.dimmer1.$channel3,
                               led: provider.led.$channel1,
                               mirrorSwitch: provider.relaySmall2.$contact5,
                               leftButton: PushButton(publisher: provider.input1.$enter1),
                               rightButton: PushButton(publisher: provider.input1.$enter2),
                               lightSwitch: provider.relayBig1.$contact6,
                               sensor: cloakroomSensor)
    }
    
    public func makeBedroomDevices() -> BedroomDevices {
        return BedroomDevices(
            leftEnterButton: PushButton(publisher: provider.input1.$sleeping1),
            rightEnterButton: PushButton(publisher: provider.input1.$sleeping2),
            dimmer: provider.dimmer2.$channel1,
            led: provider.led.$channel4,
            lampLeft: field(topicPath: "/zigbee/sleeping/bra"),
            lampRight: field(topicPath: "/zigbee/sleeping/lamp"),
            bedLeftButton: PushButton(publisher: provider.input1.$bedLeft),
            bedRightButton: PushButton(publisher: provider.input1.$bedRight)
        )
    }
    
    public func makeBathroomDevices() -> BathroomDevices {

        let simpleButton1 = SimpleButton(publisher: provider.relaySmall1.$counter5)
        let simpleButton2 = SimpleButton(publisher: provider.relaySmall1.$counter6)
        
        return BathroomDevices(leftButton: PushButton(publisher: provider.input1.$bathroom1),
                               rightButton: PushButton(publisher: provider.input1.$bathroom2),
                               internalButton1: simpleButton1,
                               internalButton2: simpleButton2,
                               sensor: provider.sensorBathroom.motionSensor,
                               dimmer: provider.dimmer2.$channel2,
                               led: provider.led.$channel3,
                               towelDryer: provider.relaySmall1.$contact3,
                               fan: provider.dimmer2.$contact3)
    }
}
