//
//  Assembler.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

import Foundation
import CocoaMQTT

class Assembler {
    func assembly() {
        let assembly = Assembly()
        
        let parameters = Parameters.current
        let mqtt = CocoaMQTT(clientID: parameters.clientID, host: parameters.host, port: UInt16(parameters.port))
        
        assembly.register(object: mqtt)
        assembly.register(object: SubscriptionController())
        assembly.enable()
    }
}
