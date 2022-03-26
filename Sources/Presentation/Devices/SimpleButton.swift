//
//  File.swift
//  
//
//  Created by Rinat Gabdullin on 26.03.2022.
//

import Combine

public class SimpleButton: Device<Int> {
    
    public func onPressDetect() -> AnyPublisher<Void, Never> {
        $value
            .dropFirst(2) // drop -1 and current
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}
