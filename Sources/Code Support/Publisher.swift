//
//  File.swift
//  
//
//  Created by Rinat G. on 13.02.2022.
//

import Combine

extension Publisher where Failure == Never {
    public func assignWeak<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Output>, on root: Root) -> AnyCancellable {
        sink { [weak root] in
            root?[keyPath: keyPath] = $0
        }
    }
}
