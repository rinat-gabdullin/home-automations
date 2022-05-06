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
    
    private func zigbeeField<T>(topicPath: String) -> Field<T> where T: Equatable & Payload {
        WritableBinding(session: provider.session,
                        topicPath: .init(path: topicPath),
                        setter: \.set).projectedValue
    }
    
    private func wirenboardField<T>(topicPath: String) -> Field<T> where T: Equatable & Payload {
        WritableBinding(session: provider.session,
                        topicPath: .init(path: topicPath),
                        setter: \.on).projectedValue
    }
    
    public func makeMainAreaDevices() -> MainAreaDevices {

        let session = provider.session
        let kitchenTableSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/kitchen/table-sensor"))
        
        let countertopSensor = ZigbeeSensor(publisher: session.subscribe(topicPath: "/zigbee/kitchen/countertop-sensor"))

        let hueSwitchAction = TopicPublisher<HueSwitchAction>(topic: "/zigbee/switches/action", session: session)
            .removeDuplicates()
            .eraseToAnyPublisher()

        let rightRollet = DoubleRelay(isOn: wirenboardField(topicPath: "/devices/wb-gpio/controls/EXT1_ON3"),
                                directionSwitch: wirenboardField(topicPath: "/devices/wb-gpio/controls/EXT1_DIR3"))
        
        let leftRollet = DoubleRelay(isOn: wirenboardField(topicPath: "/devices/wb-gpio/controls/EXT1_ON2"),
                                directionSwitch: wirenboardField(topicPath: "/devices/wb-gpio/controls/EXT1_DIR2"))
        
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
            lamp: zigbeeField(topicPath: "/zigbee/main/shelf"),
            hueSwitchAction: hueSwitchAction,
            trackLight1: zigbeeField(topicPath: "/zigbee/main/track-1"),
            trackLight2: zigbeeField(topicPath: "/zigbee/main/track-2"),
            trackLight3: zigbeeField(topicPath: "/zigbee/main/track-3"),
            trackLight4: zigbeeField(topicPath: "/zigbee/main/track-4"),
            trackLight5: zigbeeField(topicPath: "/zigbee/main/track-5"),
            shelfLight: provider.relayBig2.$contact3,
            upButton: SimpleButton(publisher: provider.relayBig1.$counter6),
            downButton: SimpleButton(publisher: provider.relayBig1.$counter5),
            leftRollet: leftRollet,
            rightRollet: rightRollet
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
                               sensor: cloakroomSensor,
                               doorbell: PushButton(publisher: provider.input1.$doorbell))
    }
    
    public func makeBedroomDevices() -> BedroomDevices {
        return BedroomDevices(
            leftEnterButton: PushButton(publisher: provider.input1.$sleeping1),
            rightEnterButton: PushButton(publisher: provider.input1.$sleeping2),
            dimmer: provider.dimmer2.$channel1,
            led: provider.led.$channel4,
            curtain: wirenboardField(topicPath: "/devices/dooya_0x0101/controls/Position"),
            lampLeft: zigbeeField(topicPath: "/zigbee/sleeping/bra"),
            lampRight: zigbeeField(topicPath: "/zigbee/sleeping/lamp"),
            bedLeftButton: PushButton(publisher: provider.input1.$bedLeft),
            bedRightButton: PushButton(publisher: provider.input1.$bedRight),
            curtainsLeft: SimpleButton(publisher: provider.relayBig2.$counter5),
            curtainsRight: SimpleButton(publisher: provider.relayBig2.$counter4)
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
