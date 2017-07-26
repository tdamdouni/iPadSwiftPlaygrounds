//
//  NodeFactory.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import SceneKit
import PlaygroundSupport

struct ItemInfo {
    
    let identifier: WorldNodeIdentifier
    let id: Int
    
    let position: SCNVector3
    let rotation: SCNFloat
    
    let stateInfo: [PlaygroundValue]
    
    init?(message: PlaygroundValue) {
        guard case let .array(args) = message, args.count > 3 else { return nil }
        guard case let .string(id) = args[0],
            let identifier = WorldNodeIdentifier(rawValue: id)
        else { return nil }
        
        guard
            case let .integer(index) = args[1],
            let position = SCNVector3(message: args[2]),
            let rotation = SCNFloat(message: args[3])
        else { return nil }
        
        let stateInfo: [PlaygroundValue] = args.count > 4 ? Array(args.suffix(from: 4)) : []

        self.identifier = identifier
        self.id = index
        self.position   = position
        self.rotation   = rotation
        self.stateInfo  = stateInfo
    }
}

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
    
    static func id(from message: PlaygroundValue) -> Int {
        guard case let .array(args) = message, args.count >= 2,
            case let .integer(index) = args[1] else {
                return -1
        }
        
        return index
    }
    
    static func make(from message: PlaygroundValue, within world: GridWorld) -> Item? {
        guard let info = ItemInfo(message: message) else {
            log(message: "Failed to find the necessary info to reconstruct a WorldNode from: \(message).")
            return nil
        }
        
        let item: Item
        // Search for an exiting node with that identifier.
        if let possibleItem = world.item(forID: info.id),
            possibleItem.identifier == info.identifier {
            item = possibleItem
            item.world = world
        }
        else {
            // If no existing nodes could be found, try to create one.
            guard let newItem = make(with: info.identifier, in: world, from: info.stateInfo) else {
                log(message: "Failed to reconstruct a `\(info.identifier)` from: \(message).")
                return nil
            }
            item = newItem
        }
        
        // Set the `id` explicitly so that this world is synchronized with the user process.
        item.id = info.id
        item.rotation = info.rotation
        item.position = info.position

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
            
        case .gem:
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
            guard case let .data(colorData)? = stateInfo.first,
                case let .array(indicies)? = stateInfo.last,
                let color = NSKeyedUnarchiver.unarchiveObject(with: colorData) as? _Color
                else { return nil }
            
            let lock = PlatformLock(color: Color(color))
            node = lock

            // Reconfigure the platforms with this lock.
            let platformIndicies: [Int] = indicies.flatMap {
                if case let .integer(index) = $0 {
                    return index
                }
                return nil
            }
            
            for index in platformIndicies {
                let platform = world.item(forID: index) as? Platform
                platform?.lock = lock
            }
            
        case .platform:
            guard case let .integer(level)? = stateInfo.first,
                  case let .integer(lockId)? = stateInfo.last else { return nil }

            let platform = Platform(onLevel: level)
            platform.lock = world.item(forID: lockId) as? PlatformLock
            node = platform
            
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
