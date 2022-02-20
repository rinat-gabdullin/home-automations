//
//  Relay.swift
//  HomeEngine
//
//  Created by Rinat G. on 03.02.2022.
//

import Foundation

final public class WirenboardRelay: WirenboardDevice {
    @WritableBinding("K1") public var contact1: Bool
    @WritableBinding("K2") public var contact2: Bool
    @WritableBinding("K3") public var contact3: Bool
    @WritableBinding("K4") public var contact4: Bool
    @WritableBinding("K5") public var contact5: Bool
    @WritableBinding("K6") public var contact6: Bool
}
