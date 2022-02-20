//
//  Topic.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation
import Combine
import Session
import CodeSupport

protocol TopicBinding {
    func initialize(topicPath: TopicPath, session: MQTTSession)
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
    
    public init(session: MQTTSession, zigbeeDeviceTopicPath: TopicPath) where T: Equatable {

        self.writer = session.makeWriter(for: zigbeeDeviceTopicPath.set)
        
        TopicPublisher<T>(topic: zigbeeDeviceTopicPath, session: session)
            .catch { _ in Just(T.initialValue) }
            .removeDuplicates()
            .assignWeak(to: \.internalValue, on: self)
            .store(in: &subscriptions)
    }
    
    internal func initialize(topicPath: TopicPath, session: MQTTSession) {
        var topicPath = topicPath
        
        if let customPathComponent = customPathComponent {
            topicPath = topicPath.byReplacingLastPathComponent(to: customPathComponent).on
        }
        
        writer = session.makeWriter(for: topicPath)
        
        session
            .subscribe(topicPath: topicPath)
            .assignWeak(to: \.internalValue, on: self)
            .store(in: &subscriptions)
    }    
}
