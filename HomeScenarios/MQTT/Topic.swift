//
//  Topic.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

/// MQTT Topic
struct Topic: Hashable, ExpressibleByStringLiteral {
    let path: String
    
    init(path value: String) {
        path = value
    }

    init(stringLiteral value: String) {
        path = value
    }
    
    func makeSetter() -> Topic {
        assert(!path.hasSuffix("/on"))
        return Topic(path: path + "/on")
    }
}
