//
//  File.swift
//  
//
//  Created by Rinat G. on 10.02.2022.
//

import Foundation
import Combine
import CodeSupport
import Connection

/// Read-only MQTT-topic
@propertyWrapper
public class Binding<T: Payload>: TopicBinding {
    
    var customPathComponent: String?
    
    @Published public private(set) var wrappedValue = T.initialValue
    
    private var subscriptions = Set<AnyCancellable>()
    
    public var projectedValue: AnyPublisher<T, Never> {
        $wrappedValue.eraseToAnyPublisher()
    }
    
    public init(_ customPathComponent: String? = nil) {
        self.customPathComponent = customPathComponent
    }
    
    func initialize(topicPath: TopicPath, session: MQTTConnection) {
        var topicPath = topicPath
        
        if let customPathComponent = customPathComponent {
            topicPath = topicPath.byReplacingLastPathComponent(to: customPathComponent)
        }
        
        session
            .subscribe(topicPath: topicPath)
            .breakpointOnError()
            .assignWeak(to: \.wrappedValue, on: self)
            .store(in: &subscriptions)
    }
    
}
