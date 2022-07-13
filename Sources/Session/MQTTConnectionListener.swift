//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Connection
import Foundation

class MQTTConnectionListener: MQTTConnectionOutput {
    weak var session: MQTTSession?
    
    func didReceiveMQTTMessage(_ message: MQTTMessage) {
        DispatchQueue.main.sync {
            self.session?.subscriptionController.handle(message: message)            
        }
    }
}
