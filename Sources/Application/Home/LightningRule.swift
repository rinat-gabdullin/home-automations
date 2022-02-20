//
//  File.swift
//  
//
//  Created by Rinat G. on 13.02.2022.
//

import Foundation
import Combine
import Presentation

class LightningRule: RestorableDisableContainer {
    internal var subscriptions = [AnyCancellable]()
    
    let restorableDisablingDevices: [RestorableDisabling]

    init(restorableDisablingDevices: [RestorableDisabling]) {
        self.restorableDisablingDevices = restorableDisablingDevices
    }
}
