//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 01.05.2022.
//

import Foundation

public class DoubleRelay {
    @Field var isOn: Bool
    @Field var directionSwitch: Bool
    
    public init(isOn: Field<Bool>, directionSwitch: Field<Bool>) {
        _isOn = isOn
        _directionSwitch = directionSwitch
    }
    
    public func startStop(direction: Bool) {
        if direction == directionSwitch {
            isOn = false
        } else {
            isOn = true
            directionSwitch = direction
        }
    }
}
