//
//  WorkTableLighting.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation

class WorkTableLighting: HueDimmerSwitchOutput, RestorableDisableContainer {
    
    let lightSwitch = Switch(topic: "/devices/relay-big-1/controls/K3")

    let buttons = HueDimmerSwitch(deviceTopic: "/zigbee/HUE Buttons")
    
    var restorableDisablingDevices: [RestorableDisabling] { [lightSwitch] }
    
    init() {
        buttons.output = self
    }

    func hueDimmerSwitch(_ switch: HueDimmerSwitch, didDetect action: HueDimmerSwitch.Action) {
        if action == .onPress {
            lightSwitch.value.toggle()
        }
    }
}
