////
////  Assemby.swift
////  HomeScenarios
////
////  Created by Rinat G. on 29.11.2021.
////
//
//import Foundation
//
//fileprivate var defaultAssembly: Assembly!
//
//@propertyWrapper struct DI<T> {
//    var wrappedValue: T {
//        defaultAssembly.resolve(T.self)!
//    }
//}
//
//class Assembly {    
//    private var storage = [Key: Any]()
//    
//    func enable() {
//        defaultAssembly = self
//    }
//    
//    func register<T>(object: T) {
//        let key = Key(serviceType: T.self)
//        storage[key] = object
//    }
//    
//    func resolve<T>(_ class: T.Type) -> T? {
//        return storage[Key(serviceType: T.self)] as? T
//    }
//}
//
//struct Key: Hashable {
//    let serviceType: Any.Type
//    
//    func hash(into hasher: inout Hasher) {
//        ObjectIdentifier(serviceType).hash(into: &hasher)
//    }
//}
//
//func == (lhs: Key, rhs: Key) -> Bool {
//    return lhs.serviceType == rhs.serviceType
//}
