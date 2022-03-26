//
//  File.swift
//  
//
//  Created by Rinat G. on 13.02.2022.
//

import Foundation
import Combine
import Presentation

enum AutomaticMode {
    case morning
    case day
    case evening
    case night
}

class Rule<Devices> {
    
    internal var subscriptions = [AnyCancellable]()
    unowned var area: Area<Devices>
    let devices: Devices

    internal init(area: Area<Devices>) {
        self.area = area
        self.devices = area.devices
        
        setup()
    }
    
    open func setup() {
        
    }
}

class LightningRule<Devices>: Rule<Devices> {
    
}
