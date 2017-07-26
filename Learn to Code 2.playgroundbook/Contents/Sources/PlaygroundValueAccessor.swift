
//
//  PlaygroundValueAccessor.swift
//
//

import Foundation
import PlaygroundSupport

protocol PlaygroundValueAccessor {
    subscript(key: String) -> PlaygroundValue? { get }
}

extension PlaygroundKeyValueStore: PlaygroundValueAccessor {}

extension PlaygroundValue {
    func associatedType<T: Any>(_ t: T.Type) -> T? {
        switch self {
        case let .array(val): return val as? T
        case let .dictionary(val): return val as? T
        case let .string(val): return val as? T
        case let .data(val): return val as? T
        case let .date(val): return val as? T
        case let .integer(val): return val as? T
        case let .floatingPoint(val): return val as? T
        case let .boolean(val): return val as? T
        }
    }
}

extension PlaygroundValueAccessor {
    
    func type<T: Any>(_ t: T.Type, forKey key: String) -> T? {
        guard let value = self[key] else { return nil }
        
        return value.associatedType(t)
    }
    
    // MARK: Type Accessors
    
    func array(forKey key: String) -> [PlaygroundValue]? {
        return type(Array<PlaygroundValue>.self, forKey: key)
    }
    
    func dictionary(forKey key: String) -> [String: PlaygroundValue]? {
        return type(Dictionary<String, PlaygroundValue>.self, forKey: key)
    }
    
    func string(forKey key: String) -> String? {
        return type(String.self, forKey: key)
    }
    
    func data(forKey key: String) -> Data? {
        return type(Data.self, forKey: key)
    }
    
    func date(forKey key: String) -> Date? {
        return type(Date.self, forKey: key)
    }
    
    func integer(forKey key: String) -> Int? {
        return type(Int.self, forKey: key)
    }
    
    func double(forKey key: String) -> Double? {
        return type(Double.self, forKey: key)
    }
    
    func boolean(forKey key: String) -> Bool? {
        return type(Bool.self, forKey: key)
    }
}
