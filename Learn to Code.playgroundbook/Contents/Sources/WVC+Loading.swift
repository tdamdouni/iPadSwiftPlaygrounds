//
//  WVC+Loading.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

extension WorldViewController {
    // MARK: Loading
    
    /// Loads a base set of animation for every actor that has been added to the scene, as well as
    /// the animations necessary to carry out each action in the `commandQueue`.
    /// Uses `loadingQueue` to start loading all shared animations and node geometry.
    func beginLoadingAnimations() {
        guard !isLoading else { return }
        
        var actionsForType = [ActorType: [AnimationType]]()
        
        // Add in a set of base animations to load for each actor.
        let baseActions: [AnimationType] = scene.commandQueue.isEmpty ? [.idle] : AnimationType.levelCompleteAnimations(for: isPassingRun)
        
        for actor in scene.actors {
            let type = actor.type
            actionsForType[type] = [.default] + baseActions
        }
        
        // Load only the additional actions which were used for every actor.
        for command in scene.commandQueue {
            guard let actor = command.performer as? Actor else { continue }
            let actorType = actor.type
            guard let action = command.action.animation else {
                fatalError("A action has been assigned to `Actor` without a corresponding animation.")
            }
            
            let existingActions = actionsForType[actorType] ?? []
            actionsForType[actorType] = [action] + existingActions
        }
        
        let actorLoader = BlockOperation {
            for (actorType, actions) in actionsForType {
                ActorAnimation.loadAnimations(for: actorType, actions: actions)
//                AudioComponent.loadSounds(for: actorType, actions: actions)
            }
        }
        loadingQueue.addOperation(actorLoader)
    }
    
    /// Load geometry for all items in the grid.
    func beginLoadingGeometry() {
        // `allItems` will include items that have not yet been added to the world.
        let allItems = scene.gridWorld.grid.allItems
        let geometryLoader = BlockOperation {
            for item in allItems {
                item.loadGeometry()
            }
        }
        loadingQueue.addOperation(geometryLoader)
    }
}
