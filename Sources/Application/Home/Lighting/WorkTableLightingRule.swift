//
//  WorkTableLighting.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation
import Presentation
import Combine

class WorkTableLightingRule: LightningRule {
    init(lightSwitch: Field<Bool>, hueSwitch: AnyPublisher<HueSwitchAction, Never>) {
        super.init(restorableDisablingDevices: [lightSwitch])
        
        hueSwitch
            .filter { $0 == .onPress }
            .sink(receiveValue: { _ in
                lightSwitch.wrappedValue.toggle()
            })
            .store(in: &subscriptions)
    }
}
