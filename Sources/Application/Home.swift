//
//  HomeControl.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation
import DeviceAreas
import Combine
import Presentation

class Home {
    internal init(mainArea: Area<MainAreaDevices>, sleepingArea: Area<BedroomDevices>, entrancyArea: Area<EntrancyDevices>, bathroomArea: Area<BathroomDevices>) {
        
        self.mainArea = mainArea
        self.sleepingArea = sleepingArea
        self.entrancyArea = entrancyArea
        self.bathroomArea = bathroomArea
        
        setup()
    }    
    
    let mainArea: Area<MainAreaDevices>
    let sleepingArea: Area<BedroomDevices>
    let entrancyArea: Area<EntrancyDevices>
    let bathroomArea: Area<BathroomDevices>
    
    private var subscriptions = [AnyCancellable]()
    @Published var restorationTokens = [RestorationToken]()
    
    func setup() {
        mainArea.add(rule: CountertopLighting(area: mainArea))
        mainArea.add(rule: KitchenTableLighting(area: mainArea))
        mainArea.add(rule: MainRoomLighting(area: mainArea))
        mainArea.add(rule: WorkTableLightingRule(area: mainArea))
        entrancyArea.add(rule: EntrancyLighting(area: entrancyArea))
        entrancyArea.add(rule: CloakroomLighting(area: entrancyArea))
        bathroomArea.add(rule: BathroomLighting(area: bathroomArea))
        bathroomArea.add(rule: BathroomAccessoires(area: bathroomArea))
        entrancyArea.add(rule: Doorbell(area: entrancyArea))
        sleepingArea.add(rule: BedroomCurtains(area: sleepingArea))
        
        let rule = BedroomLighting(area: sleepingArea)
        sleepingArea.add(rule: rule)
        
        entrancyArea.devices.leftButton
            .onActionDetectedPublisher()
            .filter { $0 == .doubleClick }
            .map { _ in Void() }
            .merge(with: rule.onHomeLightsOffSignal)
            .sink { [weak self] _ in
                self?.switchLightsEverywhere()
            }
            .store(in: &subscriptions)
        
        $restorationTokens
            .filter(\.isEmpty.inversed)
            .debounce(for: .seconds(5 * 60), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.restorationTokens = []
            }
            .store(in: &subscriptions)
    }
    
    func switchLightsEverywhere() {
        
        let toDisable: [RestorableDisabling] = [mainArea.devices, sleepingArea.devices, entrancyArea.devices, bathroomArea.devices]
        
        if restorationTokens.isEmpty {
            restorationTokens = toDisable.map { $0.setDisabled() }
            
        } else {
            restorationTokens.forEach { token in
                token.restore()
            }
            restorationTokens = []
        }
    }

}
