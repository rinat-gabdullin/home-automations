//
//  Payload.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

protocol Payload: LosslessStringConvertible {
    static var initialValue: Self { get }
    
    func mqttValue() -> String
}

extension Payload {
    func mqttValue() -> String {
        description
    }
}

extension Int: Payload {
    static var initialValue: Int { -1 }
    
}

extension String: Payload {
    static var initialValue: String { "" }
}

extension Bool: Payload {
    static var initialValue = false
    
    func mqttValue() -> String {
        self ? "1" : "0"
    }
}
