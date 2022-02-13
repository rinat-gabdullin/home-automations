////
////  HomeLighting.swift
////  HomeEngine
////
////  Created by Rinat G. on 25.01.2022.
////
//
//import Foundation
//import Presentation
//
//class HomeLighting {
//    
//    let mainRoomLighting = MainRoomLighting()
//    let kitchenLighting = KitchenTableLighting()
//    let countertopLighting = CountertopLighting()
//    let cloakroomLighting = CloakroomLighting()
//    let entrancyLighting = EntrancyLighting()
//    let bathroomLighting = BathroomLighting()
//    let sleepingRoomLighting = SleepingRoomLighting()
//    let workTableLighting = WorkTableLightingRule()
//    
//    var restorationTokens = [Restoration]()
//    
//    init(homeEventsHandler: HomeEvents) {
//        entrancyLighting.homeEventsHandler = homeEventsHandler
//    }
//    
//    func switchLightsEverywhere() {
//        if restorationTokens.isEmpty {
//            let lightings: [RestorableDisabling] = [
//                mainRoomLighting,
//                kitchenLighting,
//                cloakroomLighting,
//                countertopLighting,
//                bathroomLighting,
//                sleepingRoomLighting,
//                workTableLighting,
//                entrancyLighting]
//            
//            restorationTokens = lightings.map { $0.setDisabled() }
//            
//        } else {
//            
//            restorationTokens.forEach { token in
//                token.restore()
//            }
//            restorationTokens = []
//        }
//    }
//}
