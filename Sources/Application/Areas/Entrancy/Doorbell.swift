//
//  Doorbell.swift
//  HomeEngine
//
//  Created by Rinat G. on 25.01.2022.
//

import Foundation
import DeviceAreas
import AppKit

class Doorbell: Rule<EntrancyDevices> {

    override func setup() {
        devices.doorbell.detectedActions = [.singleClick]
        
        devices
            .doorbell
            .onActionDetectedPublisher()
            .sink { [weak self] _ in
                self?.ding()
            }
            .store(in: &subscriptions)
    }
    
    func ding() {
        DispatchQueue.global(qos: .default).async {
            for _ in 0..<10 {
                NSSound.beep()
                usleep(150000)
            }
        }
    }
}
