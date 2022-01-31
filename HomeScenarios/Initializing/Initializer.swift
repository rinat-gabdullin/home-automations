//
//  Factory.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

/// Initializes application
class Initializer {
    
    func initialize() -> HomeControl {
        Assembler().assembly()
        return HomeControl()
    }
}
