////
////  LightLevelProvider.swift
////  HomeScenarios
////
////  Created by Rinat G. on 22.01.2022.
////
//
//import Foundation
//import Presentation
//
//class MainRoomLighting: PushButtonOutput, RestorableDisableContainer {
//    
//    private var scheme: LightingScheme = .off {
//        didSet {
//            didSet(scheme: scheme)
//        }
//    }
//    
//    let lightings: [Lightning]
//    
//    private let hall1 = PushButton(topic: "/devices/wb-gpio/controls/hall-1")
//    private let hall2 = PushButton(topic: "/devices/wb-gpio/controls/hall-2")
//    
//    var restorableDisablingDevices: [RestorableDisabling] { lightings }
//    
//    init() {
//        let dimmerHall1 = Dimmer(topic: .dimmerChannel1)
//        let dimmerHall2 = Dimmer(topic: .dimmerChannel2)
//
//        dimmerHall1.maxValue = 100
//        dimmerHall2.maxValue = 100
//        
//        lightings = [dimmerHall1, dimmerHall2]
//        
//        hall1.output = self
//        hall2.output = self
//        hall1.detectEvents = [.singleClick, .doubleClick, .longPress]
//        hall2.detectEvents = [.singleClick, .doubleClick, .longPress]
//    }
//    
//    func pushButton(pushButton: PushButton, didFire event: PushButtonEvent) {
//        if pushButton === hall1 {
//            leftButton(event: event)
//        } else if pushButton === hall2 {
//            rightButton(event: event)
//        }
//    }
//    
//    private func leftButton(event: PushButtonEvent) {
//        switch event {
//        case .singleClick:
//            scheme = .lounge
//            
//        case .doubleClick:
//            break
//            
//        case .longPress:
//            scheme = .off
//        }
//    }
//    
//    private func rightButton(event: PushButtonEvent) {
//        switch event {
//        case .singleClick:
//            scheme = .auto
//            
//        case .doubleClick:
//            break
//            
//        case .longPress:
//            scheme = .bright
//        }
//    }
//    
//    private func didSet(scheme: LightingScheme) {
//        let level = self.level(for: scheme)
//        lightings.forEach { lightning in
//            lightning.relativeLevel = level
//        }
//    }
//    
//    private func level(for scheme: LightingScheme) -> Float {
//        switch scheme {
//        case .off:
//            return 0
//        case .lounge:
//            return 0.1
//        case .auto:
//            return 0.5
//        case .bright:
//            return 1
//        }
//    }
//}
