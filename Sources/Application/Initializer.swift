//
//  Factory.swift
//  HomeScenarios
//
//  Created by Rinat G. on 29.11.2021.
//

/// Initializes application
public class Initializer {
    
    let homeControl: HomeControl
    
    public init() {
        Assembler().assembly()
        homeControl = HomeControl()
    }
    
    public func initialize() -> Any {
        homeControl.start()
        return homeControl
    }
}
