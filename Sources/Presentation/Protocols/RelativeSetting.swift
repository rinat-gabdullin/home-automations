//
//  Lightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

/// Ability to configure value from `Double { 0...1 }`
/// Depends on binding's `maxValue` property
public protocol RelativeSetting: AnyObject {
    var relativeValue: Double { get set }
}
