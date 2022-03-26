//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import Presentation

final public class BathroomDevices: RestorableDisableContainer {
    
    internal init(leftButton: PushButton,
                  rightButton: PushButton,
                  internalButton1: SimpleButton,
                  internalButton2: SimpleButton,
                  sensor: MSWMotionSensor,
                  dimmer: Field<Int>,
                  led: Field<Int>,
                  towelDryer: Field<Bool>,
                  fan: Field<Bool>) {
        self.leftButton = leftButton
        self.rightButton = rightButton
        self.internalButton1 = internalButton1
        self.internalButton2 = internalButton2
        self.sensor = sensor
        
        _dimmer = dimmer
        _led = led
        _towelDryer = towelDryer
        _fan = fan
    }
    
    public let leftButton: PushButton
    public let rightButton: PushButton
    
    public let internalButton1: SimpleButton
    public let internalButton2: SimpleButton
    
    public let sensor: MSWMotionSensor
    
    @Field public var dimmer: Int
    @Field public var led: Int

    @Field public var towelDryer: Bool
    @Field public var fan: Bool
    
    public var restorableDisablingDevices: [RestorableDisabling] {
        [_dimmer, _led]
    }
}
