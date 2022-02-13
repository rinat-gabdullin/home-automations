//
//  Payload.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

public protocol Payload: LosslessStringConvertible, Codable {
    static var initialValue: Self { get }
    
    func mqttValue() -> String
}

extension Payload {
    public func mqttValue() -> String {
        description
    }
}

extension Int: Payload {
    public static var initialValue: Int { -1 }
    
}

extension String: Payload {
    public static var initialValue: String { "" }
}

extension Bool: Payload {
    public static var initialValue = false
    
    public func mqttValue() -> String {
        self ? "1" : "0"
    }
}

extension Double: Payload {
    public static var initialValue: Double { 0.0 }
    
    public func mqttValue() -> String {
        formatted()
    }
}
