//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation

class WirenboardInput: WirenboardDevice {
    @Control("enter-2") var enter2: Bool
    @Control("enter-1") var enter1: Bool
    
    
    
    @Control("hall-1") var hall1: Bool
    @Control("hall-2") var hall2: Bool
    @Control("hall-down") var hallDown: Bool
    @Control("hall-up") var hallUp: Bool
    @Control("hall-center") var hallCenter: Bool
    @Control("table-1") var table1: Bool
    @Control("table-2") var table2: Bool
    @Control("sleeping-1") var sleeping1: Bool
    @Control("sleeping-2") var sleeping2: Bool
    @Control("bathroom-1") var bathroom1: Bool
    @Control("bathroom-2") var bathroom2: Bool
}
