//
//  Lightning.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

protocol Lightning: AnyObject, RestorableDisabling {
    var relativeLevel: Float { get set }
}
