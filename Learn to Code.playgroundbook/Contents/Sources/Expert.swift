// 
//  Expert.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

public final class Expert: Actor {
    
    public convenience init() {
        let node = WorldNodeIdentifier.actor.makeNode()
        node.name! += "-" + ActorType.expert.rawValue
        self.init(node: node)!
    }
    
    public required init?(node: SCNNode) {
        super.init(node: node)
    }
    
    @available(*, unavailable, message:"The Expert can't jump 😕. Only the Character type can use the `jump()` method.")
    @discardableResult
    public override func jump() -> Coordinate {
        return coordinate
    }
    
    public override func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(ActorType.expert.createNode())
    }
}

extension Expert {
    
    /**
    Method that turns a lock up, causing all linked platforms to rise the height of one block.
     */
    public func turnLockUp() {
        turnLock(up: true)
    }
    
    /**
     Method that turns a lock down, causing all linked platforms to fall the height of one block.
     */
    public func turnLockDown() {
        turnLock(up: false)
    }
    
    /**
     Method that turns a lock either up or down a certain number of times.
     */
    public func turnLock(up: Bool, numberOfTimes: Int) {
        for _ in 1...numberOfTimes {
            turnLock(up: up)
        }
    }
    
    func turnLock(up: Bool) {
        let lock = world?.existingNode(ofType: PlatformLock.self, at: nextCoordinateInCurrentDirection)
        
        if let lock = lock where lock.level == level {
            add(action: .control(lock: lock, movingUp: up))
        }
        else {
            add(action: .incorrect(.missingLock))
        }
    }
}
