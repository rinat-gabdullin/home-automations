//
//  File.swift
//  
//
//  Created by Rinat G. on 13.02.2022.
//

import Foundation
import Combine

@propertyWrapper
public class Field<T: Payload> {
    private let binding: WritableBinding<T>
    
    var maxValue: T {
        binding.maxValue
    }
    
    public var wrappedValue: T {
        get { binding.wrappedValue }
        set { binding.wrappedValue = newValue }
    }
    
    public var projectedValue: AnyPublisher<T, Never> {
        binding.publisher()
    }
    
    internal init(_ binding: WritableBinding<T>) {
        self.binding = binding
    }
    
    private var lastRestorationToken: Restoration? {
        didSet {
            oldValue?.invalidate()
        }
    }
}

extension Field: RelativeSetting where T: BinaryInteger {
    public var relativeValue: Double {
        get {
            assert(maxValue != .initialValue)
            return Double(wrappedValue) / Double(maxValue)
        }
        
        set {
            assert(maxValue != .initialValue)
            wrappedValue = T(Double(maxValue) * newValue)
        }
    }
}

extension Field: RestorableDisabling where T: ProvidingDisabledValue {
    
    public func setDisabled() -> Restoration {
        if wrappedValue == .disabledValue {
            return Restoration(onRestore: nil)
        }
        
        let currentValue = wrappedValue
        
        let token = Restoration { [weak self] in
            self?.wrappedValue = currentValue
        }
        
        wrappedValue = .disabledValue
        lastRestorationToken = token
        return token
    }
}
