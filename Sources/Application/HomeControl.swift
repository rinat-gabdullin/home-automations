//
//  HomeControl.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation

class HomeControl {
    
    let mqttConnector = Connector()
    let handler = MQTTListener()
    
    let homeState = HomeState()
    
    func start() {
        mqttConnector.connect(delegate: handler)
        
    }
}
