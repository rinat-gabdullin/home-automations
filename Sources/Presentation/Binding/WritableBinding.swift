//
//  Topic.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation
import Combine
import Connection
import CodeSupport

protocol TopicBinding {
    func initialize(topicPath: TopicPath, session: MQTTConnection)
}

/// Writable MQTT-topic
@propertyWrapper
public class WritableBinding<T: Payload>: TopicBinding {
    
    var customPathComponent: String?
    
    public var wrappedValue: T {
        get {
            return internalValue
        }
        
        set {
            writer?.publish(payload: newValue.mqttValue())
            internalValue = newValue
        }
    }
    
    private var writer: TopicWriter?
    
    @Published private var internalValue = T.initialValue
    
    public var projectedValue: Field<T> {
        Field(self)
    }

    func publisher() -> AnyPublisher<T, Never> {
        $internalValue.eraseToAnyPublisher()
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    public init(_ customPathComponent: String? = nil) {
        self.customPathComponent = customPathComponent
    }
    
    public init(session: MQTTConnection, topicPath: TopicPath, setter: KeyPath<TopicPath, TopicPath> = \.set) where T: Equatable {
        
        self.writer = session.makeWriter(for: topicPath[keyPath: setter])
        
        TopicPublisher<T>(topic: topicPath, session: session)
            .assignWeak(to: \.internalValue, on: self)
            .store(in: &subscriptions)
    }
    
    internal func initialize(topicPath: TopicPath, session: MQTTConnection) {
        var topicPath = topicPath
        
        if let customPathComponent = customPathComponent {
            topicPath = topicPath.byReplacingLastPathComponent(to: customPathComponent)
        }
        
        writer = session.makeWriter(for: topicPath.on)
        
        session
            .subscribe(topicPath: topicPath)
            .assignWeak(to: \.internalValue, on: self)
            .store(in: &subscriptions)
    }    
}

