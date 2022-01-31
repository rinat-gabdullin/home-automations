//
//  Topics.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

extension Topic {
    
    //MARK: Dimmer 1
    
    /// Main room ceiling spots lights 1
    static let dimmerChannel1: Self = "/devices/dimmer/controls/Channel 1"
    
    /// Main room ceiling spots lights 2
    static let dimmerChannel2: Self = "/devices/dimmer/controls/Channel 2"
    
    /// Entrancy ceiling spots lights
    static let dimmerChannel3: Self = "/devices/dimmer/controls/Channel 3"
    
    //MARK: Dimmer 2
    
    /// Sleeping room ceiling spots lights
    static let dimmer2Channel1: Self = "/devices/dimmer-2/controls/Channel 1"
    
    /// Bathroom ceiling spots lights
    static let dimmer2Channel2: Self = "/devices/dimmer-2/controls/Channel 2"
    
    ///
    static let dimmer2Channel3: Self = "/devices/dimmer-2/controls/Channel 3"
    
    //MARK: LED Controller
    
    /// Entrancy LED
    static let ledChannel1: Self = "/devices/led/controls/White 1"
    
    /// Kitchen countertop LED
    static let ledChannel2: Self = "/devices/led/controls/White 2"
    
    /// Bathroom LED
    static let ledChannel3: Self = "/devices/led/controls/White 3"
    
    /// Sleeping room LED
    static let ledChannel4: Self = "/devices/led/controls/White 4"
    
    // MARK: - Other
    
    static let doorbell: Self = "/devices/door/controls/doorbell-enabled"
}
