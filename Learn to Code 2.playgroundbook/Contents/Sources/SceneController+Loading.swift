//
//  SceneController+Loading.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

extension SceneController {
    // MARK: Loading
    
    /// Loads a base set of animation for every actor that has been added to the scene, as well as
    /// the animations necessary to carry out each action in the `commandQueue`.
    /// Uses `loadingQueue` to start loading all shared animations and node geometry.
    func beginLoadingAnimations() {
        guard !isLoading else { return }
        
        var actionsForType = [ActorType: [EventGroup]]()
        
        // Add in a set of base animations to load for each actor.
        let baseActions: [EventGroup] = scene.commandQueue.isEmpty ? [.idle] : EventGroup.levelCompleteAnimations(for: isPassingRun)
        
        for actor in scene.actors {
            let type = actor.type
            actionsForType[type] = [.default] + baseActions
        }
        
        // Load only the additional actions which were used for every actor.
        for command in scene.commandQueue {
            guard let actor = command.performer as? Actor else { continue }
            let actorType = actor.type
            guard let action = command.action.event else {
                fatalError("A action has been assigned to `Actor` without a corresponding animation.")
            }
            
            let existingActions = actionsForType[actorType] ?? []
            actionsForType[actorType] = [action] + existingActions
        }
        
        let actorLoader = BlockOperation {
            for (actorType, actions) in actionsForType {
                let cache = AssetCache.cache(forType: actorType)
                
                cache.loadSounds(forAssets: actions)
                cache.loadAnimations(forAssets: actions)
            }
        }
        loadingQueue.addOperation(actorLoader)
    }
    
    /// Load geometry for all items in the grid.
    func beginLoadingGeometry(queue: OperationQueue = .main) {
        // `allItems` will include items that have not yet been added to the world.
        let allItems = scene.gridWorld.grid.allItems
        let geometryLoader = BlockOperation {
            for item in allItems {
                item.loadGeometry()
            }
        }
        queue.addOperation(geometryLoader)
    }
}
