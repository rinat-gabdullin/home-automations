//
//  KitchenTableLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import DeviceAreas

class KitchenTableLighting: LightningRule<MainAreaDevices> {
    
    lazy var sensor = devices.tableSensor
    lazy var pushButton = devices.kitchenButton2
    
    override func setup() {
        
        sensor.configuration.noMotionNotifyPeriod = 60 * 8
        pushButton.detectedActions = [.singleClick, .doubleClick, .longPress]
        
        sensor
            .$state
            .map {
                switch $0 {
                case .motionNotDetectedWarning:
                    return 50
                case .motionDetected:
                    return 100
                case .motionNotDetected:
                    return 0
                }
            }
            .assignWeak(to: \.kitchenTable, on: devices)
            .store(in: &subscriptions)
        
        pushButton
            .longPressPublisher()
            .sink { [weak self] output in
                if output {
                    self?.startAnimating()
                } else {
                    self?.stopAnimating()
                }
            }
            .store(in: &subscriptions)
        
        pushButton
            .onActionDetectedPublisher()
            .sink { [weak self] action in
                switch action {
                case .singleClick: self?.toggle()
                case .doubleClick: self?.sensor.toogleEnabled()
                default: break
                }
            }
            .store(in: &subscriptions)
    }

    func toggle() {
        sensor.disableTemporarily()
        devices.kitchenTable = devices.kitchenTable > 0 ? 0 : 100
    }
    
    var timer: Timer?
    
    func startAnimating() {
        sensor.disableTemporarily()
        timer?.invalidate()
        
        devices.kitchenTable = 100
        
        timer = .scheduledTimer(withTimeInterval: 0.75, repeats: true, block: { [weak devices] timer in
            guard let devices = devices else {
                return
            }
            
            let newValue = devices.kitchenTable * 2/3
            if newValue < 0 {
                devices.kitchenTable = 1
                timer.invalidate()
            } else {
                devices.kitchenTable = newValue
            }
            
        })
    }
    
    func stopAnimating() {
        timer?.invalidate()
    }
}
