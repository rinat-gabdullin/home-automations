//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import Presentation
import Combine

final public class MainAreaDevices: RestorableDisableContainer {
    
    internal init(leftButton: PushButton, rightButton: PushButton, centerButton: PushButton, kitchenTable: Field<Int>, tableSensor: ZigbeeSensor, kitchenButton1: PushButton, kitchenButton2: PushButton, led: Field<Int>, trackKitchen: Field<Bool>, cookerHood: Field<Bool>, countertopSensor: ZigbeeSensor, ceiling: Field<Int>, workingTable: Field<Bool>, lamp: Field<ZigbeeLightPayload>, hueSwitchAction: AnyPublisher<HueSwitchAction, Never>, trackLight1: Field<ZigbeeLightPayload>, trackLight2: Field<ZigbeeLightPayload>, trackLight3: Field<ZigbeeLightPayload>, trackLight4: Field<ZigbeeLightPayload>, trackLight5: Field<ZigbeeLightPayload>, shelfLight: Field<Bool>) {
        
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.centerButton = centerButton
        self._kitchenTable = kitchenTable
        self.tableSensor = tableSensor
        self.kitchenButton1 = kitchenButton1
        self.kitchenButton2 = kitchenButton2
        self._led = led
        self._trackKitchen = trackKitchen
        self._cookerHood = cookerHood
        self.countertopSensor = countertopSensor
        self._ceiling = ceiling
        self._workingTable = workingTable
        self._lamp = lamp
        self.hueSwitchAction = hueSwitchAction
        self._trackLight1 = trackLight1
        self._trackLight2 = trackLight2
        self._trackLight3 = trackLight3
        self._trackLight4 = trackLight4
        self._trackLight5 = trackLight5
        self._shelfLight = shelfLight
    }
       
    // Шкаф
    @Field public var shelfLight: Bool
    
    // Около входа:
    public let leftButton: PushButton
    public let rightButton: PushButton
    
    // По центру комнаты
    public let centerButton: PushButton
//    public let upButton: PushButton
//    public let downButton: PushButton
    
    // Около кухонного стола
    @Field public var kitchenTable: Int
    public let tableSensor: ZigbeeSensor
    public let kitchenButton1: PushButton
    public let kitchenButton2: PushButton
    
    // Столешница
    @Field public var led: Int
    @Field public var trackKitchen: Bool
    @Field public var cookerHood: Bool
    public let countertopSensor: ZigbeeSensor

    // Потолок
    @Field public var ceiling: Int

    // Около рабочей зоны
    @Field public var workingTable: Bool
    @Field public var lamp: ZigbeeLightPayload
    public let hueSwitchAction: AnyPublisher<HueSwitchAction, Never>
    
    // Над диваном
    @Field public var trackLight1: ZigbeeLightPayload
    @Field public var trackLight2: ZigbeeLightPayload
    @Field public var trackLight3: ZigbeeLightPayload
    @Field public var trackLight4: ZigbeeLightPayload
    @Field public var trackLight5: ZigbeeLightPayload
    
    public var restorableDisablingDevices: [RestorableDisabling] {
        [_kitchenTable, _led, _trackKitchen, _ceiling, _workingTable, _lamp, _trackLight1, _trackLight2, _trackLight3, _trackLight4, _trackLight5]
    }
}
