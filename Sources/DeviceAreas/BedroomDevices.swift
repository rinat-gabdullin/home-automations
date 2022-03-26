//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import Presentation

final public class BedroomDevices: RestorableDisableContainer {
    public var leftEnterButton: PushButton
    public var rightEnterButton: PushButton
    public var bedLeftButton: PushButton
    public var bedRightButton: PushButton
    
    @Field public var dimmer: Int
    @Field public var led: Int
    @Field public var lampLeft: ZigbeeLightPayload
    @Field public var lampRight: ZigbeeLightPayload
    
    internal init(leftEnterButton: PushButton,
                  rightEnterButton: PushButton,
                  dimmer: Field<Int>,
                  led: Field<Int>,
                  lampLeft: Field<ZigbeeLightPayload>,
                  lampRight: Field<ZigbeeLightPayload>,
                  bedLeftButton: PushButton,
                  bedRightButton: PushButton) {
        
        self.leftEnterButton = leftEnterButton
        self.rightEnterButton = rightEnterButton
        self._dimmer = dimmer
        self._led = led
        self._lampLeft = lampLeft
        self._lampRight = lampRight
        self.bedLeftButton = bedLeftButton
        self.bedRightButton = bedRightButton
    }
    
    public var restorableDisablingDevices: [RestorableDisabling] {
        [_dimmer, _led, _lampLeft, _lampRight]
    }
}
