//
//  Persisted.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport
import Foundation

/// The name of the current page being presented.
/// Must be manually set in the pages auxiliary sources.
public var pageIdentifier = ""

enum Persisted {
    enum Key {
        static let characterName = "CharacterNameKey"
        
        static let speedIndex = "SpeedIndexKey"
        
        static let backgroundAudio = "BackgroundAudioKey"
        
        static let characterAudio = "CharacterAudioKey"
        
        /// The key for the identifier of the last track played.
        static let resumingTrackIdentifier = "ResumingTrackIdentifier"
        
        static let playedTrackIdentifiers = "PlayedTrackIdentifiers"
        
        static let configPList = "Configuration"
        
        static var executionCount: String {
            return "\(pageIdentifier).executionCountKey"
        }
    }
    
    static let store = PlaygroundKeyValueStore.current
    
    static let configuration: NSDictionary? = {
        guard let url = Bundle.main.url(forResource: Key.configPList, withExtension: "plist") else {
            return nil
        }
        return NSDictionary(contentsOf: url)
    }()
    
    // MARK: Properties
    
    static var speedIndex: Int {
        get {
            let count = store.integer(forKey: Key.speedIndex)
            return count ?? 0
        }
        set {
            store[Key.speedIndex] = .integer(newValue)
        }
    }
    
    static var playedSongIdentifiers: [String] {
        get {
            let arr = store.array(forKey: Key.playedTrackIdentifiers) ?? []
            return arr.flatMap { $0.associatedType(String.self) }
        }
        set {
            let arr = newValue.map { PlaygroundValue.string($0) }
            store[Key.playedTrackIdentifiers] = .array(arr)
        }
    }
    
    static var isBackgroundAudioEnabled: Bool {
        get {
            let enabled = store.boolean(forKey: Key.backgroundAudio)
            return enabled ?? true
        }
        set {
            store[Key.backgroundAudio] = .boolean(newValue)
        }
    }
    
    static var areSoundEffectsEnabled: Bool {
        get {
            let enabled = store.boolean(forKey: Key.characterAudio)
            return enabled ?? true
        }
        set {
            store[Key.characterAudio] = .boolean(newValue)
        }
    }
    
    static var resumingTrackIdentifier: String? {
        get {
            return store.string(forKey: Key.resumingTrackIdentifier)
        }
        set {
            if let id = newValue {
                store[Key.resumingTrackIdentifier] = .string(id)
            }
        }
    }
    
    // MARK: Derived Properties
    
    static var isAllAudioEnabled: Bool {
        return Persisted.areSoundEffectsEnabled && Persisted.isBackgroundAudioEnabled
    }
}

/** 
    Reads the current page run count from UserDefaults.
    It relies on the `pageIdentifier` to be correctly set
    so that the page can be correctly identified.
 */
public var currentPageRunCount: Int {
    get {
        let runCount = Persisted.store.integer(forKey: Persisted.Key.executionCount)
        return runCount ?? 0
    }
    set {
        Persisted.store[Persisted.Key.executionCount] = .integer(newValue)
    }
}

extension ActorType {
    
    static func loadDefault() -> ActorType {
        let key = Persisted.Key.characterName
        
        let type: ActorType
        // Look for a previously saved type.
        if let value = Persisted.store.string(forKey: key),
            let loadedType = ActorType(rawValue: value) {
            type = loadedType
        }
        // Check the "Configuration.plist" for a default character.
        else if let value = Persisted.configuration?[key] as? String,
            let defaultValue = ActorType(rawValue: value.lowercased()) {
            type = defaultValue
        }
        // Return `.byte` as the fallback type if no saved value is found.
        else {
            type = .byte
        }
    
        return type
    }
    
    func saveAsDefault() {
        Persisted.store[Persisted.Key.characterName] = .string(self.rawValue)
    }
}
