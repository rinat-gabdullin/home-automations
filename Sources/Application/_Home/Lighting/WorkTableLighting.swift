//
//  WorkTableLighting.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation

class WorkTableLighting: HueDimmerSwitchOutput, RestorableDisableContainer {
    
    let lightSwitch = NewSwitch(topic: \.relayBig1.$contact3)

    let buttons = HueDimmerSwitch(deviceTopic: "/zigbee/switches")
    
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
