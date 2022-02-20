//
//  File.swift
//  
//
//  Created by Rinat G. on 20.02.2022.
//

import Foundation

public final class WirenboardHS: WirenboardDevice {
    @WritableBinding("EXT3_HS1") public var contact1: Bool
    @WritableBinding("EXT3_HS2") public var contact2: Bool
    @WritableBinding("EXT3_HS3") public var contact3: Bool
    @WritableBinding("EXT3_HS4") public var contact4: Bool
    @WritableBinding("EXT3_HS5") public var contact5: Bool
    @WritableBinding("EXT3_HS6") public var contact6: Bool
    @WritableBinding("EXT3_HS7") public var contact7: Bool
    @WritableBinding("EXT3_HS8") public var contact8: Bool
}
