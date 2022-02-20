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
    
    private var lastRestorationToken: RestorationToken? {
        didSet {
            oldValue?.invalidate()
        }
    }

}

extension Field: RestorableDisabling where T: ProvidingDisabledValue {
    
    public func setDisabled() -> RestorationToken {
        if wrappedValue == .disabledValue {
            return RestorationToken(onRestore: nil)
        }
        
        let currentValue = wrappedValue
        
        let token = RestorationToken { [weak self] in
            self?.wrappedValue = currentValue
        }
        
        wrappedValue = .disabledValue
        lastRestorationToken = token
        return token
    }
}
