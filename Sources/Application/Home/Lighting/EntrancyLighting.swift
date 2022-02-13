//
//  EntrancyLighting.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Combine
import Presentation
import CodeSupport

class EntrancyLighting: Rule {
    
    @Published var state = LightingState.off
    
    private let leftButton: PushButton
    private let rightButton: PushButton
    
    init(dimmer: Field<Int>,
         led: Field<Int>,
         mirrorSwitch: Field<Bool>,
         leftButton: PushButton,
         rightButton: PushButton) {
        
        // To retain buttons:
        self.leftButton = leftButton
        self.rightButton = rightButton
        
        [leftButton, rightButton].forEach { button in
            button.detectEvents = [.longPress, .doubleClick, .singleClick]
        }
        
        super.init(restorableDisablingDevices: [dimmer, led])
        
        // Light control buttons handling:
                
        leftButton
            .$lastEvent
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .lounge
                case .doubleClick: return .off
                case .longPress: return .off
                }
            }
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        
        rightButton
            .$lastEvent
            .compactMap { (event) -> (LightingState?) in
                switch event {
                case .singleClick: return .auto
                case .longPress: return .bright
                default: return nil
                }
            }
            .assignWeak(to: \.state, on: self)
            .store(in: &subscriptions)
        
        // State handling for dimmer:
        
        $state
            .map { state -> Double in
                switch state {
                case .off, .lounge:
                    return 0
                case .auto:
                    return 0.5
                case .bright:
                    return 1
                }
            }
            .writeRelative(to: dimmer)
            .store(in: &subscriptions)

        // State handling for mirror backlight:

        $state
            .map { state -> Bool in
                switch state {
                case .off: return false
                default: return true
                }
            }
            .write(to: mirrorSwitch)
            .store(in: &subscriptions)
    }
    
    func onTurnOffEverything() -> AnyPublisher<Void, Never> {
        leftButton
            .$lastEvent
            .removeDuplicates()
            .filter { $0 == .doubleClick }
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
    
    /*
    weak var homeEventsHandler: HomeEvents?
    
    let dimmer = Dimmer(topic: .dimmerChannel3)
    let led = Dimmer(topic: .ledChannel1)

    private var subscriptions = Set<AnyCancellable>()

    private let enterButton1 = PushButton(topic: "/devices/wb-gpio/controls/enter-1")
    private let enterButton2 = PushButton(topic: "/devices/wb-gpio/controls/enter-2")

    var restorableDisablingDevices: [RestorableDisabling] { [dimmer, led] }
    
    init() {
        
        dimmer.maxValue = 100
        
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
    
    */
}
