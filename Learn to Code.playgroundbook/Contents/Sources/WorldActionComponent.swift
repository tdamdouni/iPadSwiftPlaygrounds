//
//  WorldActionComponent.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

class WorldActionComponent: ActorComponent {
    
    // MARK: Properties
    
    unowned let actor: Actor
    weak var world: GridWorld?
    
    private var animationDuration: TimeInterval {
        let animationComponent = actor.componentForType(AnimationComponent.self)
        return animationComponent?.currentAnimationDuration ?? 1.0
    }
    
    // MARK: Initializers
    
    required init(actor: Actor) {
        self.actor = actor
    }
    
    // MARK: Performer
    
    func applyStateChange(for action: Action) {
        guard let world = world else { return }
        
        switch action {
        case let .move(start, end):
            moveItemsBetween(start: start, end: end, animated: false)
            
        case let .jump(start, end):
            moveItemsBetween(start: start, end: end, animated: false)
            
        case .place(_), .remove(_):
            world.applyStateChange(for: action)
            
        case let .toggle(id, on):
            guard let switchItem = world.item(forID: id) as? Switch else { break }
            switchItem.setActive(on, animated: false)
            
        case let .control(lock, isMovingUp):
            isMovingUp ? lock.raisePlatforms() : lock.lowerPlatforms()
            
        default:
            break
        }
    }
    
    func perform(_ action: Action) {
        // Unpack action. 
        switch action {
        case let .move(start, end):
            moveItemsBetween(start: start, end: end, animated: true)
            
        case let .jump(start, end):
            moveItemsBetween(start: start, end: end, animated: true)
            
        case let .teleport(from: start, end):
            teleportActorFrom(start, to: end)
        
        case let .toggle(id, on):
            guard let switchItem = world?.item(forID: id) as? Switch where switchItem.isInWorld else {
                fatalError("Instructed to `toogleSwitch`, but no switch was found for id: \(id).")
            }
            #if DEBUG
            assert(switchItem.coordinate == actor.coordinate, "The actor can only toggle switches it's currently on.")
            #endif
            switchItem.setActive(on, animated: true)

        case let .remove(indices):
            guard let index = indices.first else { fatalError("Attempting to remove, but no indices were found") }
            guard let gem = world?.item(forID: index) as? Gem else {
                fatalError("Actor cannot remove nodes other than gems. <\(index)> \(world?.item(forID: index))")
            }
            
            gem.collect(withDuration: animationDuration)
            
        case let .control(lock, isMovingUp):
            let movementDuration = animationDuration / 2
            let wait = SCNAction.wait(forDuration: animationDuration / 2)
            let movePlatforms = SCNAction.run { _ in
                
                SCNTransaction.begin()
                SCNTransaction.animationDuration = movementDuration
                SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                
                isMovingUp ? lock.raisePlatforms() : lock.lowerPlatforms()
                
                SCNTransaction.commit()
            }
            
            lock.scnNode.run(.sequence([wait, movePlatforms]))
            
        default:
            break
        }
        actor.performerFinished(self)
    }
    
    func cancel(_ action: Action) {
        switch action {
        case let .remove(indices):
            let index = indices.first!
            let item = world?.item(forID: index)
            item?.scnNode.removeAllActions()
            
        default:
            node.removeAction(forKey: action.key.rawValue)
        }
    }
    
    // MARK: Convenience
    
    func moveItemsBetween(start: SCNVector3, end destination: SCNVector3, animated: Bool) {
        guard let world = world else { return }
        
        func moveGems(at coordinate: Coordinate, up: Bool) {
            let items = world.existingNodes(ofType: Gem.self, at: [coordinate])
            
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
    
    // MARK: Teleportation
    
    func teleportActorFrom(_ position: SCNVector3, to newPosition: SCNVector3) {
        guard let world = world,
            startingPortal = world.existingNode(ofType: Portal.self, at: Coordinate(position)),
            endingPortal = world.existingNode(ofType: Portal.self, at: Coordinate(newPosition)) else { return }
        
        startingPortal.enter(atSpeed: actor.commandSpeed)
        endingPortal.exit(atSpeed: actor.commandSpeed)
    
        let halfWait = SCNAction.wait(forDuration: animationDuration / 2.0)
        let moveActor = SCNAction.move(to: newPosition, duration: 0.0)
        node.run(SCNAction.sequence([halfWait, moveActor]))
    }
}
