//
//  Topic.swift
//  HomeScenarios
//
//  Created by Rinat G. on 22.01.2022.
//

import Foundation

/// MQTT Topic
public struct TopicPath: Hashable, ExpressibleByStringLiteral {
    let path: String
    
    public init(path value: String) {
        path = value
//        print(value)
    }

    public init(stringLiteral value: String) {
        path = value
//        print(value)
    }
    
    public var on: TopicPath {
        assert(!path.hasSuffix("/on"))
        return TopicPath(path: path + "/on")
    }
    
    public var set: TopicPath {
        assert(!path.hasSuffix("/set"))
        return TopicPath(path: path + "/set")
    }
    
    public mutating func byReplacingLastPathComponent(to newComponent: String) -> TopicPath {
        var path = path
        let components = path.components(separatedBy: "/")
        guard let last = components.last, let range = path.range(of: last, options: .backwards) else {
            return self
        }
        
        path.replaceSubrange(range, with: newComponent)
        return TopicPath(path: path)
    }
}
