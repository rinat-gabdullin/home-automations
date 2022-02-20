//
//  File.swift
//  
//
//  Created by Rinat G. on 10.02.2022.
//

import Foundation

/// Representation of WB-MSW v.3
/// https://wirenboard.com/ru/product/wb-msw-v3/
public final class WirenboardMSW: WirenboardDevice {
    
    @Binding("Temperature") var temperature: Double
    @Binding("Humidity") var humidity: Double
    @Binding("CO2") var co2: Int
    @Binding("Air Quality (VOC)") var voc: Int
    @Binding("Sound Level") var soundLevel: Double
    @Binding("Illuminance") var illuminance: Double
    @Binding("Max Motion") var maxMotion: Int
    @Binding("Current Motion") var currentMotion: Int
    @Binding("Buzzer") var buzzer: Bool
    @Binding("Red LED") var redLED: Bool
    @Binding("Green LED") var greenLED: Bool
    @Binding("LED Period (s)") var ledPeriod: Int
    @Binding("LED Glow Duration (ms)") var ledGlowDuration: Int
    
    public var motionSensor: MSWMotionSensor {
        MSWMotionSensor(publisher: $currentMotion)
    }
}
