// 
//  _KeyValueStoreAccess.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import Foundation

/// The name of the current page being presented.
/// Must be manually set in the pages auxiliary sources.
public var pageIdentifier = ""

struct KeyValueStoreKey {
    static let domain = "com.apple.learntocode.customization"

    static let characterName = "characterNameKey"
    
    static var executionCount: String {
        return "\(pageIdentifier).executionCountKey"
    }
}

/** 
    Reads the current page run count from UserDefaults.
    It relies on the `pageIdentifier` to be correctly set
    so that the page can be correctly identified.
 */
public var currentPageRunCount: Int {
    get {
        let count = UserDefaults(suiteName: KeyValueStoreKey.domain)?.integer(forKey: KeyValueStoreKey.executionCount)
        return count ?? 0
    }
    set {
        if let defaults = UserDefaults(suiteName: KeyValueStoreKey.domain) {
            defaults.set(newValue, forKey: KeyValueStoreKey.executionCount)
            defaults.synchronize()
        }
    }
}

extension ActorType {
    
    static func loadDefault() -> ActorType {
        // Return `.byte` as the default if no saved value is found.
        let fallbackType: ActorType = .byte

        if let value = UserDefaults(suiteName:KeyValueStoreKey.domain)?.object(forKey: KeyValueStoreKey.characterName) {
            return ActorType(rawValue: value as! String) ?? fallbackType
        }
    
        return fallbackType
    }
    
    func saveAsDefault() {
        if let defaults = UserDefaults(suiteName: KeyValueStoreKey.domain) {
            defaults.set(self.rawValue, forKey:KeyValueStoreKey.characterName)
            defaults.synchronize()
        }
    }
}
