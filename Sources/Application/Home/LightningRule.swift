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

class LightningRule: RestorableDisableContainer {
    internal var subscriptions = [AnyCancellable]()
    
    @Published var automaticMode = AutomaticMode.day
    
    let restorableDisablingDevices: [RestorableDisabling]

    init(restorableDisablingDevices: [RestorableDisabling]) {
        self.restorableDisablingDevices = restorableDisablingDevices
    }
}
