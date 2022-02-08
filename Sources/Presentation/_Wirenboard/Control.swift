//
//  Topic.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation
import Combine
import Session

protocol DeviceControl {
    func initialize(topicPath: TopicPath, session: MQTTSession)
}

@propertyWrapper
class Control<T: Payload>: DeviceControl {
    
    var customPathComponent: String?
    
    var wrappedValue: T {
        get {
            return internalValue
        }
        
        set {
            writer?.publish(value: newValue)
            internalValue = newValue
        }
    }
    
    private var writer: TopicWriter?
    
    private var internalValue = T.initialValue
    
    var projectedValue: Control<T> {
        return self
    }
    
    private var subscriptions = Set<AnyCancellable>()
    
    init(_ customPathComponent: String? = nil) {
        self.customPathComponent = customPathComponent
    }
    
    func initialize(topicPath: TopicPath, session: MQTTSession) {
        var topicPath = topicPath
        
        if let customPathComponent = customPathComponent {
            topicPath = topicPath.byReplacingLastPathComponent(to: customPathComponent)
        }
        
        writer = session.makeWriter(for: topicPath)
        
        session
            .subscribe(topicPath: topicPath)
            .catch { _ in Empty<T, Never>(completeImmediately: false) }
            .assign(to: \.internalValue, on: self)
            .store(in: &subscriptions)
    }
    
}
