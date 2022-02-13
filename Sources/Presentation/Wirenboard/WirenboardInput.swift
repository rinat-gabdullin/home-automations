//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation

public final class WirenboardInput: WirenboardDevice {
    @Binding("enter-1") public var enter1: Bool
    @Binding("enter-2") public var enter2: Bool
    @Binding("hall-1") public var hall1: Bool
    @Binding("hall-2") public var hall2: Bool
    @Binding("hall-down") public var hallDown: Bool
    @Binding("hall-up") public var hallUp: Bool
    @Binding("hall-center") public var hallCenter: Bool
    @Binding("table-1") public var table1: Bool
    @Binding("table-2") public var table2: Bool
    @Binding("sleeping-1") public var sleeping1: Bool
    @Binding("sleeping-2") public var sleeping2: Bool
    @Binding("bathroom-1") public var bathroom1: Bool
    @Binding("bathroom-2") public var bathroom2: Bool
}
