//
//  File.swift
//  
//
//  Created by Rinat G. on 10.02.2022.
//

import Foundation
import Combine
import Session

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
    
    func initialize(topicPath: TopicPath, session: MQTTSession) {
        var topicPath = topicPath
        
        if let customPathComponent = customPathComponent {
            topicPath = topicPath.byReplacingLastPathComponent(to: customPathComponent)
        }
        
        session
            .subscribe(topicPath: topicPath)
            .catch { _ in Empty<T, Never>(completeImmediately: false) }
            .sink(receiveValue: { [weak self] newValue in
                self?.wrappedValue = newValue
            })
            .store(in: &subscriptions)
    }
    
}
