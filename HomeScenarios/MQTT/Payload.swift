//
//  Payload.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

protocol Payload {
    static var initialValue: Self { get }
    var payloadBytes: [UInt8] { get }
}

extension Int: Payload {
    static var initialValue: Int { -1 }
    
    var payloadBytes: [UInt8] {
        String(self).payloadBytes
    }
}

extension String: Payload {
    static var initialValue: String { "" }
    
    var payloadBytes: [UInt8] {
        [UInt8](self.utf8)
    }
}
