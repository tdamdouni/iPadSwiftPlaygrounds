//
//  WorldActionComponent.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit

final class WorldActionComponent: ActorComponent, ActorNode {
    // MARK: Properties
    
    unowned let actor: Actor
    unowned let world: GridWorld
    
    private var animationDuration: TimeInterval {
        let animationComponent = actor.component(ofType: AnimationComponent.self)
        return animationComponent?.currentAnimationDuration ?? 1.0
    }
    
    // MARK: Initializers
    
    init(actor: Actor, world: GridWorld) {
        self.actor = actor
        self.world = world
    }
    
    // MARK: Performer
    
    func applyStateChange(for action: Action) {
        switch action {
        case let .move(dis, _):
            moveItemsBetween(start: dis.from, end: dis.to, animated: false)
            
        case .add(_), .remove(_):
            world.applyStateChange(for: action)
            
        case let .control(contr):
            contr.setStateForItem(in: world, animated: false)
            
        default:
            break
        }
    }
    
    func perform(_ action: Action) -> PerformerResult {
        switch action {
        case let .move(dis, type):
            moveItemsBetween(start: dis.from, end: dis.to, animated: true)
            if type == .teleport {
                teleportActor(with: dis)
            }
            
        case let .control(contr) where contr.kind == .movePlatforms:
            movePlatforms(with: contr)
            
        case let .control(contr) where contr.kind == .toggle:
            guard let switchItem = contr.controllable(in: world) as? Switch, switchItem.isInWorld else {
                fatalError("Instructed to `toogleSwitch`, but no switch was found for id: \(contr.identifier).")
            }
            contr.setStateForItem(in: world, animated: true)
            
            #if DEBUG
            assert(switchItem.coordinate == actor.coordinate, "The actor can only toggle switches it's currently on.")
            #endif

        case let .remove(indices):
            guard let index = indices.first, let gem = world.item(forID: index) as? Gem else {
                fatalError("Actor cannot remove nodes other than gems.")
            }
            
            gem.collect(withDuration: animationDuration)
            
        default:
            break
        }
        
        // Mark the action as complete. 
        return PerformerResult.done(self)
    }
    
    func perform(event: EventGroup, variation: Int, speed: Float) -> PerformerResult {
        guard let action = actor.currentAction else { return PerformerResult.done(self) }
        return perform(action)
    }

    func cancel(_ action: Action) {
        switch action {
        case let .remove(indices):
            for index in indices {
                let item = world.item(forID: index)
                item?.scnNode.removeAllActions()
            }
            
        default:
            node.removeAction(forKey: action.key.rawValue)
        }
    }
    
    // MARK: Convenience
    
    func moveItemsBetween(start: SCNVector3, end destination: SCNVector3, animated: Bool) {
        func moveGems(at coordinate: Coordinate, up: Bool) {
            let items = world.existingItems(ofType: Gem.self, at: [coordinate])
            
            let duration = animated ? animationDuration : 0.0
            for item in items {
                item.move(up: up, withDuration: duration)
            }
        }

        // Raise upcoming gems.
        let incomingCoordinate = Coordinate(destination)
        moveGems(at: incomingCoordinate, up: true)
        
        // Lower passed gems.
        let leavingCoordinate = Coordinate(start)
        moveGems(at: leavingCoordinate, up: false)
    }
    
    func movePlatforms(with contr: Controller) {
        guard let lock = contr.controllable(in: world) as? PlatformLock, lock.isInWorld else {
            fatalError("Instructed to control `PlatformLock`, but no lock was found for id: \(contr.identifier).")
        }
        
        let movementDuration = animationDuration / 2
        let wait = SCNAction.wait(duration: movementDuration)
        let movePlatforms = SCNAction.run { _ in
            lock.performPlatformMovement(goingUp: contr.state, duration: movementDuration)
        }
        
        lock.scnNode.runAction(.sequence([wait, movePlatforms]))
    }
    
    // MARK: Teleportation
    
    func teleportActor(with displacement: Displacement<SCNVector3>) {
        guard let startingPortal = world.existingItem(ofType: Portal.self, at: Coordinate(displacement.from)),
            let endingPortal = world.existingItem(ofType: Portal.self, at: Coordinate(displacement.to)) else { return }
        
        startingPortal.enter(atSpeed: Actor.commandSpeed, actorType: actor.type)
        endingPortal.exit(atSpeed: Actor.commandSpeed, actorType: actor.type)
    
        let halfWait = SCNAction.wait(duration: animationDuration / 2.0)
        let moveActor = SCNAction.move(to: displacement.to, duration: 0.0)
        node.runAction(.sequence([halfWait, moveActor]), forKey: "Teleport")
    }
}
