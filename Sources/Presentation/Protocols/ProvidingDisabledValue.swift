//
//  File.swift
//  
//
//  Created by Rinat G. on 10.02.2022.
//

import Foundation

public protocol ProvidingDisabledValue: Equatable {
    static var disabledValue: Self { get }
}

extension Bool: ProvidingDisabledValue {
    public static var disabledValue: Bool { false }
}

extension Int: ProvidingDisabledValue {
    public static var disabledValue: Int { 0 }
}
