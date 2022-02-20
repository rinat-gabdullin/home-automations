//
//  KitchenTableLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation
import Presentation

class KitchenTableLighting: LightningRule {
    
    @Field private var light: Int
    
    let sensor: ZigbeeSensor
    let pushButton: PushButton

    internal init(light: Field<Int>, sensor: ZigbeeSensor, pushButton: PushButton) {
        self._light = light
        self.sensor = sensor
        self.pushButton = pushButton
        
        super.init(restorableDisablingDevices: [light])
        
        sensor.noMotionNotifyPeriod = 60 * 8
        pushButton.detectedActions = [.singleClick, .longPress]
        
        sensor
            .$state
            .map { $0 == .motionDetected ? 100 : 0 }
            .write(to: light)
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
            .filter { $0 == .singleClick }
            .sink { [weak self] _ in
                self?.toggle()
            }
            .store(in: &subscriptions)
    }

    func toggle() {
        sensor.disableTemporarily()
        light = light > 0 ? 0 : 100
    }
    
    var timer: Timer?
    
    func startAnimating() {
        sensor.disableTemporarily()
        timer?.invalidate()
        
        light = 100
        
        timer = .scheduledTimer(withTimeInterval: 0.75, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                return
            }
            
            let newValue = self.light * 2/3
            if newValue < 0 {
                self.light = 1
                timer.invalidate()
            } else {
                self.light = newValue
            }
            
        })
    }
    
    func stopAnimating() {
        timer?.invalidate()
    }
}
