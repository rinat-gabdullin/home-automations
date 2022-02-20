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
    
    private var debugDescription = ""
    
    @Published public private(set) var wrappedValue = T.initialValue
    
    private var subscriptions = Set<AnyCancellable>()
    
    public var projectedValue: AnyPublisher<T, Never> {
        $wrappedValue.print(debugDescription).eraseToAnyPublisher()
    }
    
    public init(_ customPathComponent: String? = nil) {
        self.customPathComponent = customPathComponent
    }
    
    func initialize(topicPath: TopicPath, session: MQTTSession) {
        debugDescription = "BINDING: \(customPathComponent ?? "")"
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
