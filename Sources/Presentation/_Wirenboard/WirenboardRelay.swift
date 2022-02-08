//
//  Relay.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation

class WirenboardRelay: WirenboardDevice {
    @Control("K1") var contact1: Bool
    @Control("K2") var contact2: Bool
    @Control("K3") var contact3: Bool
    @Control("K4") var contact4: Bool
    @Control("K5") var contact5: Bool
    @Control("K6") var contact6: Bool
}
