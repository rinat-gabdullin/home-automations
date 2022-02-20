//
//  HomeControl.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation
import Presentation
import Combine

class HomeControl {
    
    let lightningRules: [LightningRule]
    private var subscriptions = [AnyCancellable]()
    var restorationTokens = [RestorationToken]()
    
    internal init(lightningRules: [LightningRule], lightsOffSignal: AnyPublisher<Void, Never>) {
        self.lightningRules = lightningRules
        
        lightsOffSignal.sink { [weak self] _ in
            self?.switchLightsEverywhere()
        }
        .store(in: &subscriptions)
    }
    
    func switchLightsEverywhere() {
        if restorationTokens.isEmpty {
            restorationTokens = lightningRules.map { $0.setDisabled() }
            
        } else {
            restorationTokens.forEach { token in
                token.restore()
            }
            restorationTokens = []
        }
    }

}
