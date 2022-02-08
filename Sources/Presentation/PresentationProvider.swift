//
//  File.swift
//  
//
//  Created by Rinat G. on 08.02.2022.
//

import Foundation
import Session

typealias WirenboardControl<T: Payload> = KeyPath<WirenboardHardware, Control<T>>

class PresentationProvider {
    let wirenboard: WirenboardHardware
    
    init(serverUrl: URL) throws {
        let session = try MQTTSession(serverUrl: serverUrl)
        wirenboard = WirenboardHardware(session: session)
    }
    
    func control(at keyPath: WirenboardControl<String>) -> Control<String> {
        wirenboard[keyPath: keyPath]
    }
}
