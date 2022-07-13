//
//  File.swift
//  
//
//  Created by Rinat G. on 11.02.2022.
//

import Foundation
import Session
import Combine
import CodeSupport

public class Device<T: Payload> {
    
    private(set) var isInitialValue = true
    
    @Published internal(set) public var value = T.initialValue {
        didSet {
            didSetValue(oldValue: oldValue)
            isInitialValue = false
        }
    }
    
    private var subscription: Any?
    
    public init(publisher: AnyPublisher<T, Never>) {
        subscription = publisher
            .assignWeak(to: \.value, on: self)
    }
    
    open func didSetValue(oldValue: T) {
        
    }
}
