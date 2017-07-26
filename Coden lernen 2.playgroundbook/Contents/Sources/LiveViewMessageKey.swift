// 
//  LiveViewMessageKey.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport

struct Message {
    // MARK: Types
    
    enum Key: String {
        case finishedSendingCommands
        case successCriteriaInfo
        case readyForMoreCommands
        
        // The message key sent from the
        // LiveView process indicating that the world is complete.
        // Form: [.finishedEvaluating: Bool(success)]
        case finishedEvaluating
    }
    
    // MARK: Properties
    
    let value: PlaygroundValue
    
    /// Returns `nil` if the value can not be represented as an array or dictionary
    /// (only valid message types).
    init?(value: PlaygroundValue) {
        self.value = value
        
        switch value {
        case .array(_), .dictionary(_): break
        default: return nil
        }
    }
    
    func type<T: Any>(_ t: T.Type, forKey key: Key) -> T? {
        return type(t, forKey: key.rawValue)
    }
    
    /// Retrieves values by index if the underlying value is an array.
    /// Ensures that the index is valid.
    func type<T: Any>(_ t: T.Type, forIndex index: Int) -> T? {
        guard case let .array(arr) = value, arr.indices.contains(index) else { return nil }
        
        return arr[index].associatedType(t)
    }
}

extension Message: ExpressibleByArrayLiteral {
    init(arrayLiteral elements: PlaygroundValue...) {
        self.init(value: .array(elements))!
    }
}

extension Message: ExpressibleByDictionaryLiteral {
    /// Creates an instance initialized with the given key-value pairs.
    public init(dictionaryLiteral elements: (Message.Key, PlaygroundValue)...) {
        var dict = [String: PlaygroundValue]()
        for (key, value) in elements {
            dict[key.rawValue] = value
        }
        self.init(value: .dictionary(dict))!
    }
}

extension Message: PlaygroundValueAccessor {
    
    subscript(key: Key) -> PlaygroundValue? {
        return self[key.rawValue]
    }
    
    // MARK: PlaygroundValueAccessor
    
    subscript(key: String) -> PlaygroundValue? {
        guard case let .dictionary(dict) = value else { return nil }
        
        return dict[key]
    }
}

extension PlaygroundLiveViewMessageHandler {
    func send(_ value: PlaygroundValue, forKey key: Message.Key) {
        // Messages can always be sent from the User Process, or while the connection is open in the LVP.
        guard !Process.isLiveViewProcess || Process.isLiveViewConnectionOpen else {
            log(message: "Attempting to send, but the connection is closed.\nMessageKey:  \(key)\n\(value)")
            return
        }
        
        send(.dictionary([key.rawValue: value]))
    }
}
