//
//  ScenarioService.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation
import CocoaMQTT

class MQTTDelegate: CocoaMQTTDelegate {
    
    weak var output: MQTTConnectionOutput?
    weak var connection: MQTTConnection?
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        if let connection = connection {
            output?.MQTTConnectionDidConnect(connection)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16) {
        if let connection = connection, let message = MQTTMessage(message: message) {
            output?.MQTTConnectionDidReceiveMessage(connection, message: message)
        }
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        
    }
    
    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        
    }
    
    func mqttDidPing(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        
    }
    
    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        mqtt.autoReconnectTimeInterval = 1 // to avoid increasing of the value
    }
}
