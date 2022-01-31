//
//  EntrancyLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine

class EntrancyLighting: PushButtonOutput, RestorableDisableContainer {

    weak var homeEventsHandler: HomeEvents?
    
    let dimmer = Dimmer(topic: .dimmerChannel3)
    let led = Dimmer(topic: .ledChannel1)

    private var subscriptions = Set<AnyCancellable>()

    private let enterButton1 = PushButton(topic: "/devices/wb-gpio/controls/enter-1")
    private let enterButton2 = PushButton(topic: "/devices/wb-gpio/controls/enter-2")

    var restorableDisablingDevices: [RestorableDisabling] { [dimmer, led] }
    
    init() {
        [enterButton1, enterButton2].forEach { button in
            button.output = self
            button.detectEvents = [.longPress, .doubleClick, .singleClick]
        }
        
        dimmer.maxValue = 100
        
        TopicPublisher(topic: .ledChannel1)
            .compactMap(Int.init)
            .map { $0 > 50 ? "1" : "0" }
            .write(to: .entrancyMirror.on)
            .store(in: &subscriptions)
    }
    
    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
        if pushButton === enterButton1 {
            leftButton(event: event)
        } else if pushButton === enterButton2 {
            rightButton(event: event)
        }
    }
    
    private func leftButton(event: PushButtonEvent) {
        switch event {
        case .singleClick:
            dimmer.relativeLevel = 0
            led.relativeLevel = 1
            
        case .doubleClick:
            dimmer.relativeLevel = 0
            led.relativeLevel = 0.1
            
        case .longPress:
            offEverywhere()
        }
    }
    
    private func rightButton(event: PushButtonEvent) {
        switch event {
        case .singleClick:
            dimmer.relativeLevel = 0.5
            led.relativeLevel = 1
            
        case .doubleClick:
            break
            
        case .longPress:
            dimmer.relativeLevel = 1
            led.relativeLevel = 1
        }
    }

    private func offEverywhere() {
        homeEventsHandler?.switchLightsEverywhere()
    }
}
