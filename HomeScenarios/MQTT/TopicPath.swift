//
//  Topic.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

/// MQTT Topic
struct TopicPath: Hashable, ExpressibleByStringLiteral {
    let path: String
    
    init(path value: String) {
        path = value
    }

    init(stringLiteral value: String) {
        path = value
    }
    
    var on: TopicPath {
        assert(!path.hasSuffix("/on"))
        return TopicPath(path: path + "/on")
    }
    
    mutating func byReplacingLastPathComponent(to newComponent: String) -> TopicPath {
        var path = path
        let components = path.components(separatedBy: "/")
        guard let last = components.last, let range = path.range(of: last, options: .backwards) else {
            return self
        }
        
        path.replaceSubrange(range, with: newComponent)
        return TopicPath(path: path)
    }
}
