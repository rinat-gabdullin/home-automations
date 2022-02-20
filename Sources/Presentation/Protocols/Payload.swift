//
//  Payload.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

public protocol Payload {
    static var initialValue: Self { get }
    
    func mqttValue() -> String
    
    init?(payloadString: String)
}

public extension Payload where Self: Codable {
    func mqttValue() -> String {
        guard
            let data = try? JSONEncoder().encode(self),
            let string = String(data: data, encoding: .utf8)
        else {
            assertionFailure("Couldn't encode")
            return ""
        }
        
        return string
    }
    
    init?(payloadString: String) {
        guard
            let data = payloadString.data(using: .utf8),
            let model = try? JSONDecoder().decode(Self.self, from: data)
        else {
            return nil
        }
        
        self = model
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
    
    public init?(payloadString: String) {
        switch payloadString {
        case "0", "false": self = false
        case "1", "true": self = true
        default: return nil
        }
    }
}

extension Double: Payload {
    public static var initialValue: Double { 0.0 }
    
    public func mqttValue() -> String {
        formatted()
    }
}
