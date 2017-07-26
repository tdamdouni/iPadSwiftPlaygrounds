// 
//  AssetCache.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

class AssetCache {
    // MARK: Types
    
    typealias Animation = CAAnimation
    typealias Sound = SCNAudioSource

    // MARK: Static
    
    private static let cacheForType: [ActorType: AssetCache] = {
        var cacheForType = [ActorType: AssetCache]()
        for type in ActorType.cases {
            cacheForType[type] = AssetCache(type: type)
        }
        return cacheForType
    }()
    
    static func cache(forType type: ActorType) -> AssetCache {
        return self.cacheForType[type]!
    }

    // MARK: Properties
    
    let type: ActorType
    var animationsForAsset = [EventGroup: [Animation]]()
    var soundsForAsset = [EventGroup: [Sound]]()
    
    // Retrive a valid AssetCache form `AssetCache.cache(forType:)`.
    private init(type: ActorType) {
        self.type = type
    }
    
    // MARK: Asset Loading
    
    func loadAnimations(forAssets groups: [EventGroup]) {
        for group in groups {
            // Don't reload existing animations.
            guard animationsForAsset[group] == nil else { continue }
            
            // Load the new animations.
            let animations = type.animations(for: group)
            animationsForAsset[group] = animations
        }
    }
    
    func loadSounds(forAssets groups: [EventGroup]) {
        for group in groups {
            // Don't reload existing sounds.
            guard soundsForAsset[group] == nil else { continue }
            
            let sounds = type.sounds(for: group)
            soundsForAsset[group] = sounds
        }
    }
    
    func animations(for action: EventGroup) -> [Animation] {
        if animationsForAsset[action] == nil {
            loadAnimations(forAssets: [action])
        }
        
        // Attempt to recover, but there may not be an animation for the requested action. 
        return animationsForAsset[action] ?? []
    }
    
    /// An animation for the provided event, if one exists.
    func animation(for action: EventGroup, index: Int) -> Animation? {
        return animations(for: action).element(atIndex: index)
    }
    
    func sounds(for action: EventGroup) -> [Sound] {
        if soundsForAsset[action] == nil {
            loadSounds(forAssets: [action])
        }
        
        return soundsForAsset[action] ?? []
    }
    
    /// A sound for the provided event, if one exists.
    func sound(for action: EventGroup, index: Int) -> Sound? {
        return sounds(for: action).element(atIndex: index)
    }
    
    func sound(for variation: EventVariation) -> Sound? {
        return sounds(for: variation.event).element(atIndex: variation.variationIndex)
    }
}

extension Array {
    
    /// Returns an element if the index is valid.
    fileprivate func element(atIndex index: Int) -> Element? {
        guard !isEmpty else { return nil }
        
        let index = index
        if indices.contains(index) {
            return self[index]
        }
        
        return nil
    }
}


