//
//  Topic.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation
import Combine

protocol InitializableByTopicPath {
    func initialize(topicPath: TopicPath)
}

@propertyWrapper
class Control<T: Payload>: InitializableByTopicPath {
    
    var customPathComponent: String?
    
    var wrappedValue: T {
        get {
            return internalValue
        }
        
        set {
            writer?.write(value: newValue)
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
    
    func initialize(topicPath: TopicPath) {
        var topicPath = topicPath
        
        if let customPathComponent = customPathComponent {
            topicPath = topicPath.byReplacingLastPathComponent(to: customPathComponent)
        }
        
        writer = TopicWriter(topic: topicPath.on)
        
        TopicPublisher<T>(topic: topicPath)
            .catch { _ in Empty<T, Never>(completeImmediately: false) }
            .assign(to: \.internalValue, on: self)
            .store(in: &subscriptions)
    }
    
}
