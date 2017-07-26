//
//  CommandEncoding.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import SceneKit

/*
 Action message structure:
 
 [
  "Performer": <Commandable_ID>,
  "Action": <Command_Name>,
  "Args": [PlaygroundValue]
 ]
*/

struct EncodingKey {
    static let action = "Action"
    static let performer = "Performer"
    static let arguments = "Arguments"
}

// MARK: Encoding

final class CommandEncoder {
    unowned let world: GridWorld
    
    init(world: GridWorld) {
        self.world = world
    }
    
    // MARK: Live view message
    
    func createMessage(from command: Command) -> PlaygroundValue {
        // Start with the action dictionary.
        var message = encode(action: command.action)
        
        // Add the id of the `performer`.
        message[EncodingKey.performer] = .integer(command.performer.id)
        
        return .dictionary(message)
    }
    
    func encode(action: Action) -> [String: PlaygroundValue] {
        let args: Entry
        
        switch action {
        case let .move(from, to):
            args = argumentsEntry([from, to])
        
        case let .jump(from, to):
            args = argumentsEntry([from, to])
            
        case let .turn(from, to, clockwise):
            args = argumentsEntry([from, to, clockwise])
            
        case let .teleport(from: from, to):
            args = argumentsEntry([from, to])
            
        case let .place(indices):
            let items = world.items(from: indices)
            let messageConstructors = items.map { $0 as! MessageConstructor }
            args = argumentsEntry(messageConstructors)
            
        case let .remove(indices):
            let items = world.items(from: indices)
            let messageConstructors = items.map { $0 as! MessageConstructor }
            args = argumentsEntry(messageConstructors)
            
        case let .toggle(coordinate, state):
            args = argumentsEntry([coordinate, state])
            
        case let .control(lock, goingUp):
            args = argumentsEntry([lock, goingUp])
            
        case .incorrect(_):
            // Default args for incorrect commands.
            args = argumentsEntry([false])
        }
        
        let fullCommand = [commandEntry(from: action), args].map { $0 }
        
        return fullCommand
    }
    
    // MARK: Entires
    
    typealias Entry = (String, PlaygroundValue)
    
    func commandEntry(from action: Action) -> Entry {
        return (EncodingKey.action, .string(action.key.rawValue))
    }
    
    private func argumentsEntry(_ args: [MessageConstructor]) -> Entry {
        let argMessages = args.map { $0.message }
        return (EncodingKey.arguments, .array(argMessages))
    }
}

// MARK: Decoding

final class CommandDecoder {
    unowned let world: GridWorld
    
    init(world: GridWorld) {
        self.world = world
    }
    
    // MARK: Live view message
    
    func command(from message: PlaygroundValue) -> Command? {
        guard let action = action(from: message),
            performer = performer(from: message) else { return nil }
        
        return Command(performer: performer, action: action)
    }
    
    func performer(from message: PlaygroundValue) -> Performer? {
        guard case let .dictionary(dict) = message else { return nil }
        guard case let .integer(id)? = dict[EncodingKey.performer] else { return nil }
        
        // Search all items in case the actor has not yet been placed. 
        let eligibleActors = world.grid.allItems.flatMap { item -> Actor? in
            guard let actor = item as? Actor where actor.worldIndex == id else { return nil }
            
            return actor
        }
        
        assert(eligibleActors.count <= 1, "The same action cannot apply to multiple actors \(eligibleActors).")
        
        // If the action does not apply to any of the actors, it must apply to the world.
        return eligibleActors.first ?? world
    }
    
    func action(from message: PlaygroundValue) -> Action? {
        guard case let .dictionary(dict) = message else { return nil }
        guard case let .string(commandKey)? = dict[EncodingKey.action] else { return nil }
        guard case let .array(args)? = dict[EncodingKey.arguments] else { return nil }

        switch CommandKey(rawValue: commandKey)! {
        case .move:
            guard args.count == 2 else { return nil }
            guard let from = SCNVector3(message: args[0]),
                    to = SCNVector3(message: args[1]) else { return nil }
            
            return .move(from: from, to: to)
            
        case .jump:
            guard args.count == 2 else { return nil }
            guard let from = SCNVector3(message: args[0]),
                to = SCNVector3(message: args[1]) else { return nil }
            
            return .jump(from: from, to: to)
            
        case .turn:
            guard args.count == 3 else { return nil }
            guard let from = SCNFloat(message: args[0]),
                to = SCNFloat(message: args[1]),
                clkwise = Bool(message: args[2]) else { return nil }
            
            return .turn(from: from, to: to, clockwise: clkwise)
        
        case .teleport:
            guard args.count == 2 else { return nil }
            guard let from = SCNVector3(message: args[0]),
                to = SCNVector3(message: args[1]) else { return nil }
            
            return .teleport(from: from, to: to)
            
        case .toggle:
            guard args.count == 2 else { return nil }
            guard let id = Int(message: args[0]),
                state = Bool(message: args[1]) else { return nil }
            
            return .toggle(toggleable: id, active: state)
            
        case .place:
            var indices = [Int]()
            for message in args {
                guard let item = NodeFactory.make(from: message, within: world) else {
                    fatalError("Failed to create placed item from \(message).")
                }
                indices.append(item.worldIndex)
                
                // Add the item to-be-placed to `itemsById` to keep track
                // of items that will be placed, but are not yet in the world. 
                world.grid.itemsById[item.worldIndex] = item
            }
            return .place(indices)
        
        case .remove:
            let indices = args.map {
                return NodeFactory.worldIndex(from: $0)
            }
            return .remove(indices)
            
        case .control:
            guard args.count == 2 else { return nil }
            guard let lock = NodeFactory.make(from: args[0], within: world) as? PlatformLock,
                goingUp = Bool(message: args[1]) else { return nil }
            
            return .control(lock: lock, movingUp: goingUp)
            
        case .offEdge:
            return .incorrect(.offEdge)
            
        case .intoWall:
            return .incorrect(.intoWall)
            
        case .missingGem:
            return .incorrect(.missingGem)
            
        case .missingSwitch:
            return .incorrect(.missingSwitch)
        
        case .missingLock:
            return .incorrect(.missingLock)
        }
    }
}

// MARK: MessageConstructor

protocol MessageConstructor {
    var message: PlaygroundValue { get }
}

protocol MessageConstructible: MessageConstructor {
    init?(message: PlaygroundValue)
}

// MARK: MessageConstructible Extensions

extension SCNVector3: MessageConstructible {
    var message: PlaygroundValue {
        let x: PlaygroundValue = .floatingPoint(Double(self.x))
        let y: PlaygroundValue = .floatingPoint(Double(self.y))
        let z: PlaygroundValue = .floatingPoint(Double(self.z))
        return .array([x, y, z])
    }
    
    init?(message: PlaygroundValue) {
        guard case let .array(components) = message where components.count == 3 else { return nil }
        guard case let .floatingPoint(xd) = components[0],
              case let .floatingPoint(yd) = components[1],
              case let .floatingPoint(zd) = components[2] else { return nil }
        
        self = SCNVector3(x: SCNFloat(xd), y: SCNFloat(yd), z: SCNFloat(zd))
    }
}

extension SCNFloat: MessageConstructible {
    var message: PlaygroundValue {
        return .floatingPoint(Double(self))
    }
    
    init?(message: PlaygroundValue) {
        guard case let .floatingPoint(value) = message else { return nil }
        self = SCNFloat(value)
    }
}

extension Coordinate: MessageConstructible {
    var message: PlaygroundValue {
        return .array([.integer(column), .integer(row)])
    }
    
    init?(message: PlaygroundValue) {
        guard case let .array(values) = message where values.count == 2 else { return nil }
        
        guard case let .integer(col) = values[0],
            case let .integer(row) = values[1] else { return nil }
        
        self = Coordinate(column: col, row: row)
    }
}

extension Bool: MessageConstructible {
    var message: PlaygroundValue {
        return .boolean(self)
    }
    
    init?(message: PlaygroundValue) {
        guard case let .boolean(value) = message else { return nil }
        self = value
    }
}

extension Int: MessageConstructible {
    var message: PlaygroundValue {
        return .integer(self)
    }
    
    init?(message: PlaygroundValue) {
        guard case let .integer(value) = message else { return nil }
        
        self = value
    }
}

extension Color: MessageConstructible {
    var message: PlaygroundValue {
        return .data(NSKeyedArchiver.archivedData(withRootObject: rawValue))
    }
    
    convenience init?(message: PlaygroundValue) {
        guard case let .data(data) = message else { return nil }
        
        self.init(NSKeyedUnarchiver.unarchiveObject(with: data) as! _Color)
    }
}

/// A Sting the uniquely identifies every `Action`.
enum CommandKey: String {
    case move, jump, turn, teleport, toggle, control, place, remove,
    
    // Includes all the `IncorrectAction` cases. 
    offEdge, intoWall, missingGem, missingSwitch, missingLock
}

extension Action {
    var key: CommandKey {
        switch self {
        case .move(_): return .move
        case .jump(_): return .jump
        case .teleport(from: _): return .teleport
        case .turn(_): return .turn
        case .place(_): return .place
        case .remove(_): return .remove
        case .toggle(_): return .toggle
        case .control(_): return .control
        case let .incorrect(action): return action.key
        }
    }
}

extension IncorrectAction {
    var key: CommandKey {
        switch self {
        case .offEdge: return .offEdge
        case .intoWall: return .intoWall
        case .missingGem: return .missingGem
        case .missingSwitch: return .missingSwitch
        case .missingLock: return .missingLock
        }
    }
}

// MARK: Convenience

extension Array {
    func map<K, V>(transform: (Element) -> (key: K, value: V)) -> Dictionary<K, V> {
        return reduce([:]) { combiningDict, elem in
            var dict = combiningDict
            let (key, value) = transform(elem)
            dict[key] = value
            
            return dict
        }
    }
}
