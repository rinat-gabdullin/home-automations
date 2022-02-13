//
//  File.swift
//  
//
//  Created by Rinat G. on 11.02.2022.
//

import Foundation

/// Representation of WB-MDM3
/// https://wirenboard.com/ru/product/WB-MDM3/
final public class WirenboardMDM3: WirenboardDevice {

    @WritableBinding("Channel 1") public var channel1: Int
    @WritableBinding("Channel 2") public var channel2: Int
    @WritableBinding("Channel 3") public var channel3: Int
    
    override func configure(topicBinding: TopicBinding) {
        (topicBinding as? WritableBinding<Int>)?.maxValue = 100
    }
}
