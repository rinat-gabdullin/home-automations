//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation

public final class WirenboardInput: WirenboardDevice {
    @Binding("EXT2_IN1") public var doorbell: Bool
    @Binding("EXT2_IN2") public var bedLeft: Bool
    @Binding("EXT2_IN3") public var hallCenter: Bool
    @Binding("EXT2_IN4") public var sleeping1: Bool
    @Binding("EXT2_IN5") public var bedRight: Bool
    @Binding("EXT2_IN6") public var sleeping2: Bool
    @Binding("EXT2_IN7") public var bathroom1: Bool
    @Binding("EXT2_IN8") public var bathroom2: Bool
    @Binding("EXT2_IN9") public var table2: Bool
    @Binding("EXT2_IN10") public var table1: Bool
    @Binding("EXT2_IN11") public var hall2: Bool
    @Binding("EXT2_IN12") public var hall1: Bool
    @Binding("EXT2_IN13") public var enter2: Bool
    @Binding("EXT2_IN14") public var enter1: Bool
}
