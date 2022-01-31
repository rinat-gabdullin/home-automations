//
//  File.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import CocoaMQTT

class Connector {
    @DI private var mqtt: CocoaMQTT

    init() {
        mqtt.logLevel = .info
        mqtt.keepAlive = 60
        mqtt.clientID = "command-line"
    }
    
    func connect(delegate: CocoaMQTTDelegate) {
        mqtt.delegate = delegate
//        mqtt.logLevel = .debug
        mqtt.autoReconnect = true
        _ = mqtt.connect()
    }
}
