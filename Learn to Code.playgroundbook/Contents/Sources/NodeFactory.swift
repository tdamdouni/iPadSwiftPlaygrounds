//
//  NodeFactory.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit
import PlaygroundSupport

struct NodeFactory {
    static let worldNodeTypes: [NodeConstructible.Type] = [
        Block.self, Water.self, Stair.self,
        Wall.self, Portal.self, StartMarker.self,
        Gem.self, Switch.self, Actor.self,
        PlatformLock.self, Platform.self,
        RandomNode.self
    ]
    
    static func make(from node: SCNNode) -> Item? {
        for nodeType in worldNodeTypes {
            if let item = nodeType.init(node: node) as? Item {
                return item
            }
        }
        return nil
    }
    
    static func worldIndex(from message: PlaygroundValue) -> Int {
        guard case let .array(args) = message where args.count >= 2,
            case let .integer(index) = args[1] else {
                return -1
        }
        
        return index
    }
    
    static func make(from message: PlaygroundValue, within world: GridWorld) -> Item? {
        guard
            case let .array(args) = message where args.count > 3,
            case let .string(id) = args[0], let identifier = WorldNodeIdentifier(rawValue: id),
            case let .integer(index) = args[1],
            let position = SCNVector3(message: args[2]),
            let rotation = SCNFloat(message: args[3])
        else {
            log(message: "Failed to find the necessary info to reconstruct a WorldNode from: \(message).")
            return nil
        }
        
        let item: Item
        // Search for an exiting node with that identifier.
        if let possibleItem = world.item(forID: index) where possibleItem.identifier == identifier {
            item = possibleItem
            item.world = world
        }
        else {
            // If no existing nodes could be found, try to create one.
            let stateInfo: [PlaygroundValue] = args.count > 4 ? Array(args.suffix(from: 4)) : []
            guard let newItem = make(with: identifier, in: world, from: stateInfo) else {
                log(message: "Failed to reconstruct a `\(identifier)` from: \(message).")
                return nil
            }
            item = newItem
        }
        
        // Set the `id` explicitly so that this world is synchronized with the user process.
        item.worldIndex = index
        item.rotation = rotation
        item.position = position

        return item
    }
    
    static func make(with identifier: WorldNodeIdentifier, in world: GridWorld, from stateInfo: [PlaygroundValue]) -> Item? {
        let node: Item
        
        switch identifier {
        case .block:
            node = Block()
            
        case .stair:
            node = Stair()
            
        case .wall:
            guard case let .integer(edges)? = stateInfo.first else { return nil }
            node = Wall(edges: Edge(rawValue: UInt(edges)))
            
        case .water:
            node = Water()
            
        case .item:
            node = Gem()
            
        case .switch:
            guard case let .boolean(on)? = stateInfo.first else { return nil }
            let s = Switch()
            s.isOn = on
            node = s
            
        case .portal:
            guard case let .boolean(on)? = stateInfo.first,
                case let .data(colorData)? = stateInfo.last,
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? _Color
                else { return nil }
            
            let portal = Portal(color: Color(color))
            portal.isActive = on
            node = portal
            
        case .platformLock:
            guard case let .data(colorData)? = stateInfo.last,
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? _Color
                else { return nil }
            node = PlatformLock(color: Color(color))
            
        case .platform:
            guard case let .integer(level)? = stateInfo.first,
                  case let .integer(lockId)? = stateInfo.first else { return nil }
            if let lock = world.item(forID: lockId) as? PlatformLock {
                node = Platform(onLevel: level, controlledBy: lock)
            }
            else {
                // Create a temporary lock, this will be verified before 
                // it's added to the world.
                node = Platform(onLevel: level)
            }
            
        case .randomNode:
            guard case let .string(id)? = stateInfo.first,
                let identifier = WorldNodeIdentifier(rawValue: id),
                let resemblingItem = make(with: identifier, in: world, from: []) else { return nil }

            node = RandomNode(resembling: resemblingItem)
            
        case .startMarker:
            guard case let .string(typeId)? = stateInfo.first,
                let type = ActorType(rawValue: typeId) else { return nil }
            
            node = StartMarker(type: type)
            
        case .actor:
            guard case let .string(typeId)? = stateInfo.first else { return nil }
            
            if let name = CharacterName(rawValue: typeId) {
                node = Actor(name: name)
            }
            else {
                node = Expert()
            }
        }
        
        return node
    }
}
