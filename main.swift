//
//  main.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Application
import Foundation

let object: Any

do {
    object = try Assembler.assembly()
} catch {
    assertionFailure(error.localizedDescription)
    exit(1)
}

RunLoop.main.run()
