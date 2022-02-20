//
//  File.swift
//  
//
//  Created by Rinat G. on 13.02.2022.
//

import Foundation

/// WB-MRGBW-D
/// https://wirenboard.com/ru/product/WB-MRGBW-D/
///
public final class WirenboardMRGBW: WirenboardDevice {
    @WritableBinding("Channel 1 (B) Brightness") public var channel1: Int
    @WritableBinding("Channel 2 (R) Brightness") public var channel2: Int
    @WritableBinding("Channel 3 (G) Brightness") public var channel3: Int
    @WritableBinding("Channel 4 (W) Brightness") public var channel4: Int
}
