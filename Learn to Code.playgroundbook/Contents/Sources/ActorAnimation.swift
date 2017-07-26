// 
//  ActorAnimation.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

struct ActorAnimation {
    typealias Animations = [CAAnimationGroup]
    
    static var actorAnimationsForType = [ActorType: [AnimationType: Animations]]()
    
    // MARK: Animation Loading
    
    static func loadAnimations(for type: ActorType, actions: [AnimationType]) {
        // Grab the existing animations if there are any.
        var animationsForAction: [AnimationType: [CAAnimationGroup]] = actorAnimationsForType[type] ?? [:]
        let identifiers = AnimationType.allIdentifiersByType
        
        for action in actions {
            guard animationsForAction[action] == nil else { continue } // Don't reload existing animations.
            
            for identifier in identifiers[action] ?? [] {
                let prefix = type.resourceFilePathPrefix
                guard let animationGroup = loadAnimation(prefix + identifier) else { continue }
                
                animationsForAction[action] = [animationGroup] + (animationsForAction[action] ?? [])
            }
        }
        
        actorAnimationsForType[type] = animationsForAction
    }
    
    // MARK:
    
    let type: ActorType
    var animationsForAction: [AnimationType: Animations] {
        return ActorAnimation.actorAnimationsForType[self.type] ?? [:]
    }
    
    init(type: ActorType) {
        self.type = type
    }
    
    func animations(for action: AnimationType) -> Animations {
        let animations = animationsForAction[action] ?? []
        
        if animations.isEmpty {
            log(message: "Cache miss. Loading '\(action)' action for \(type).")
            ActorAnimation.loadAnimations(for: type, actions: [action])
        }
        
        // Attempt to recover, but there may not be an animation for the requested action. 
        return animationsForAction[action] ?? []
    }
    
    /// An animation of the provided type, if one exists.
    ///
    /// If an invalid index is provided this wall fall back to a random animation
    /// for the action (if one exists).
    /// `nil` returns a random animation for the provided action.
    func animation(for action: AnimationType, index: Int? = nil) -> CAAnimationGroup? {
        let animations = self.animations(for: action)
        guard !animations.isEmpty else { return nil }
        
        let index = index ?? animations.randomIndex
        if animations.indices.contains(index) {
            return animations[index]
        }
        else {
            return animations.randomElement
        }
    }
    
    subscript(action: AnimationType) -> Animations {
        return animations(for: action)
    }
}

func loadAnimation(_ name: String) -> CAAnimationGroup? {
    guard let sceneURL = Bundle.main().urlForResource(name, withExtension: "dae") else {
        log(message: "1: Failed to find \(name) animation")
        return nil
    }
    guard let sceneSource = SCNSceneSource(url: sceneURL, options: nil) else {
        log(message: "2: Failed to load scene source from \(sceneURL).")
        return nil
    }
    
    let animationIdentifier = sceneSource.identifiersOfEntries(with: CAAnimation.self)
    guard let groupedAnimation = animationIdentifier.first else {
        log(message: "3: Failed to grab CAAnimation from \(sceneSource).")
        return nil
    }
    let animation = sceneSource.entryWithIdentifier(groupedAnimation, withClass: CAAnimation.self) as? CAAnimationGroup
    
    animation?.setDefaultAnimationValues()
    
    return animation
}
