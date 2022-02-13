//
//  HueDimmerSwitch.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation

public enum HueSwitchAction: String, Equatable {
    case unknown = ""
    
    case onPress = "on_press"
    case onHold = "on_hold"
    case onPressRelease = "on_press_release"
    case onHoldRelease = "on_hold_release"
    case upPress = "up_press"
    case upHold = "up_hold"
    case upHoldRelease = "up_hold_release"
    case downPress = "down_press"
    case downHold = "down_hold"
    case downHoldRelease = "down_hold_release"
    case offPress = "off_press"
    case offHold = "off_hold"
    case offHoldRelease = "off_hold_release"
    
}

final public class HueDimmerSwitch: Device<HueSwitchAction> {
    
}

extension HueSwitchAction: Payload {
    
    public func mqttValue() -> String { rawValue }
    
    public static var initialValue: Self { .unknown }
    
    public var description: String {
        rawValue
    }
    
    public init?(_ description: String) {
        self.init(rawValue: description)
    }
}
