//
//  Task.swift
//  HomeEngine
//
//  Created by Rinat G. on 25.01.2022.
//

import Foundation

typealias SimpleTask = Task<(), Error>

public extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Int) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
