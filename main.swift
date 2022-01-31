//
//  main.swift
//  HomeEngine
//
//  Created by Rinat G. on 24.01.2022.
//

import Foundation

let initializer = Initializer()
let homeControl = initializer.initialize()
homeControl.start()

RunLoop.main.run()
