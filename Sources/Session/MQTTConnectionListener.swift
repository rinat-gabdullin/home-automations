//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Connection

class MQTTConnectionListener: MQTTConnectionOutput {
    weak var session: MQTTSession?
    
    func MQTTConnectionDidConnect(_ connection: MQTTConnection) {
        session?.subscriptionController.handleConnected()
    }
    
    func MQTTConnectionDidReceiveMessage(_ connection: MQTTConnection, message: MQTTMessage) {
        session?.subscriptionController.handle(message: message)
    }
}
