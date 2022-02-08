//
//  Switchable.swift
//  HomeScenarios
//
//  Created by Rinat G. on 23.01.2022.
//

import Foundation

class Restoration {
    
    private var onRestore: (() -> Void)?
    
    internal init(onRestore: (() -> Void)? = nil) {
        self.onRestore = onRestore
    }
    
    func invalidate() {
        onRestore = nil
    }
    
    func restore() {
        onRestore?()
        invalidate()
    }
}

protocol RestorableDisabling {
    /// Disabled the device and return one-time state restoration token.
    /// Only one token on moment of time is valid, when receivent new one, older token is invalidated.
    /// Does nothing if device already disabled
    func setDisabled() -> Restoration
}

protocol RestorableDisableContainer: RestorableDisabling {
    var restorableDisablingDevices: [RestorableDisabling] { get }
}

extension RestorableDisableContainer {
    func setDisabled() -> Restoration {
        let childTokens = restorableDisablingDevices.map { $0.setDisabled() }
        return Restoration {
            childTokens.forEach { token in
                token.restore()
            }
        }
    }
}
