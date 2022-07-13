//
//  File.swift
//  
//
//  Created by Rinat G. on 16.02.2022.
//

import Foundation
import Connection
import Combine
import CodeSupport

@propertyWrapper
public struct State: Equatable, Codable {
    public var wrappedValue: Bool
    
    public init(wrappedValue: Bool) {
        self.wrappedValue = wrappedValue
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if wrappedValue {
            try container.encode("ON")
        } else {
            try container.encode("OFF")
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        wrappedValue = string == "ON"
    }
}

public struct ZigbeeOccupancyPayload: Payload, Codable, Equatable {
    public static var initialValue = ZigbeeOccupancyPayload(occupancy: false)
    
    var occupancy: Bool
}

public struct ZigbeeLightPayload: Payload, Codable, Equatable, ProvidingDisabledValue {
    public static let initialValue = ZigbeeLightPayload(brightness: 0, state: false)
    
    public var brightness: Int {
        didSet {
            if brightness > 0 {
                state = true
            }
        }
    }
    
    @State public var state: Bool
    
    public static var disabledValue: ZigbeeLightPayload {
        ZigbeeLightPayload(brightness: 0, state: false)
    }
}

final public class ZigbeeDevice<P: Codable & Payload & Equatable>: Device<P> {
    
    private let writer: TopicWriter
    
    /// - Parameters:
    ///   - session: Session
    ///   - topic: Root device topic
    public init(session: MQTTConnection, topic: TopicPath) {
        self.writer = session.makeWriter(for: topic.set)
        let publisher = TopicPublisher<P>(topic: topic, session: session)
            .catch { _ in Just(P.initialValue) }
            .removeDuplicates()
            .eraseToAnyPublisher()

        super.init(publisher: publisher)
    }
    
    public func update<T>(keyPath: WritableKeyPath<P, T>, to newValue: T) {
        var newPayload = value
        newPayload[keyPath: keyPath] = newValue
        publish(payload: newPayload)
    }
    
    private func publish(payload: P) {
        writer.publish(payload: payload.mqttValue())
    }
}
