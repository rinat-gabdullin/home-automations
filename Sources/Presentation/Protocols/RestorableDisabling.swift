//
//  Switchable.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

public class RestorationToken {
    
    private var onRestore: (() -> Void)?
    
    internal init(onRestore: (() -> Void)? = nil) {
        self.onRestore = onRestore
    }
    
    func invalidate() {
        onRestore = nil
    }
    
    public func restore() {
        onRestore?()
        invalidate()
    }
}

public protocol RestorableDisabling {
    /// Disabled the device and return one-time state restoration token.
    /// Only one token on moment of time is valid, when receivent new one, older token is invalidated.
    /// Does nothing if device already disabled
    func setDisabled() -> RestorationToken
}

public protocol RestorableDisableContainer: RestorableDisabling {
    var restorableDisablingDevices: [RestorableDisabling] { get }
}

public extension RestorableDisableContainer {
    func setDisabled() -> RestorationToken {
        let childTokens = restorableDisablingDevices.map { $0.setDisabled() }
        return RestorationToken {
            childTokens.forEach { token in
                token.restore()
            }
        }
    }
}
