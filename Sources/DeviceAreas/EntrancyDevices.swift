//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import Presentation

final public class EntrancyDevices: RestorableDisableContainer {
    
    @Field public var dimmer: Int
    @Field public var led: Int
    @Field public var mirrorSwitch: Bool
    public var leftButton: PushButton
    public var rightButton: PushButton
    @Field public var lightSwitch: Bool
    public var sensor: ZigbeeSensor
    public var doorbell: PushButton

    init(dimmer: Field<Int>,
         led: Field<Int>,
         mirrorSwitch: Field<Bool>,
         leftButton: PushButton,
         rightButton: PushButton,
         lightSwitch: Field<Bool>,
         sensor: ZigbeeSensor,
         doorbell: PushButton) {
        
        self._dimmer = dimmer
        self._led = led
        self._mirrorSwitch = mirrorSwitch
        self.leftButton = leftButton
        self.rightButton = rightButton
        self._lightSwitch = lightSwitch
        self.sensor  = sensor
        self.doorbell = doorbell
    }
    
    public var restorableDisablingDevices: [RestorableDisabling] {
        [_dimmer, _led, _mirrorSwitch, _lightSwitch]
    }
}
