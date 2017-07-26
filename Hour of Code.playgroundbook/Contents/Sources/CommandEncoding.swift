//
//  CommandEncoding.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
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
    
    func createValue(from command: Command) -> PlaygroundValue {
        // Start with the action dictionary.
        var message = encode(action: command.action)
        
        // Add the id of the `performer`.
        message[EncodingKey.performer] = .integer(command.performer.id)
        
        return .dictionary(message)
    }
    
    func encode(action: Action) -> [String: PlaygroundValue] {
        let args: Entry
        
        switch action {
        case let .move(dis, type):
            args = argumentsEntry([dis, type.rawValue])
            
        case let .turn(dis, clockwise):
            args = argumentsEntry([dis, clockwise])
            
        case let .add(indices):
            let items = world.items(from: indices)
            let messageConstructors = items.map { $0 as! MessageConstructor }
            args = argumentsEntry(messageConstructors)
            
        case let .remove(indices):
            let items = world.items(from: indices)
            let messageConstructors = items.map { $0 as! MessageConstructor }
            args = argumentsEntry(messageConstructors)
            
        case let .control(controller):
            args = argumentsEntry([controller])
            
        case let .run(type, variation):
            let message: [MessageConstructor]
            if let v = variation {
                message = [type, v]
            }
            else {
                message = [type]
            }
            args = argumentsEntry(message)

        case .fail(_):
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
    
    func command(from message: Message) -> Command? {
        guard let action = action(from: message),
            let performer = performer(from: message) else { return nil }
        
        return Command(performer: performer, action: action)
    }
    
    func performer(from message: Message) -> Performer? {
        guard let id = message.integer(forKey: EncodingKey.performer) else { return nil }
        
        // Search all items in case the actor has not yet been placed. 
        let eligibleActors = world.grid.allItems.flatMap { item -> Actor? in
            guard let actor = item as? Actor, actor.id == id else { return nil }
            
            return actor
        }
        
        assert(eligibleActors.count <= 1, "The same action cannot apply to multiple actors \(eligibleActors).")
        
        // If the action does not apply to any of the actors, it must apply to the world.
        return eligibleActors.first ?? world
    }
    
    func action(from message: Message) -> Action? {
        guard let commandKey = message.string(forKey: EncodingKey.action),
            let args = message.array(forKey: EncodingKey.arguments) else { return nil }

        let key = CommandKey(rawValue: commandKey)!
        switch key {
        case .move:
            guard args.count == 2 else { return nil }
            guard let dis = Displacement<SCNVector3>(message: args[0]),
                  let val = Int(message: args[1]) else { return nil }
            
            return .move(dis, type: Action.Movement(rawValue: val)!)
            
        case .turn:
            guard args.count == 2 else { return nil }
            guard let dis = Displacement<SCNFloat>(message: args[0]),
                let clkwise = Bool(message: args[1]) else { return nil }
            
            return .turn(dis, clockwise: clkwise)
        
        case .control:
            guard args.count == 1 else { return nil }
            guard let con = Controller(message: args[0]) else { return nil }
            
            return .control(con)
            
        case .add:
            var indices = [Int]()
            for message in args {
                guard let item = NodeFactory.make(from: message, within: world) else {
                    fatalError("Failed to create placed item from \(message).")
                }
                indices.append(item.id)
                
                // Add the item to-be-placed to `itemsById` to keep track
                // of items that will be placed, but are not yet in the world. 
                world.grid.itemsById[item.id] = item
            }
            return .add(indices)
        
        case .remove:
            let indices = args.map {
                return NodeFactory.id(from: $0)
            }
            return .remove(indices)
            
        case .run:
            guard args.count >= 1 else { return nil }
            guard let asset = EventGroup(message: args[0]) else { return nil }
    
            var variation: Int? = nil
            if case let .integer(index)? = args.last {
                variation = index
            }
            
            return .run(asset, variation: variation)

        case .offEdge:
            return .fail(.offEdge)
            
        case .intoWall:
            return .fail(.intoWall)
            
        case .missingGem:
            return .fail(.missingGem)
            
        case .missingSwitch:
            return .fail(.missingSwitch)
        
        case .missingLock:
            return .fail(.missingLock)
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
        guard case let .array(components) = message, components.count == 3 else { return nil }
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
        guard case let .array(values) = message, values.count == 2 else { return nil }
        
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

extension EventGroup: MessageConstructible {
    var message: PlaygroundValue {
        return .string(self.rawValue)
    }
    
    init?(message: PlaygroundValue) {
        guard case let .string(value) = message,
            let type = EventGroup(rawValue: value) else { return nil }
        
        self = type
    }
}

extension Controller: MessageConstructible {
    var message: PlaygroundValue {
        return .array([
            identifier.message,
            kind.rawValue.message,
            state.message
        ])
    }
    
    init?(message: PlaygroundValue) {
        guard case let .array(values) = message, values.count == 3 else { return nil }
        guard let id = Int(message: values[0]),
            let kind = Int(message: values[1]),
            let state = Bool(message: values[2]) else { return nil }
        
        self = Controller(identifier: id, kind: Kind(rawValue: kind)!, state: state)
    }
}

extension Displacement: MessageConstructible {
    var message: PlaygroundValue {
        return .array([
            from.message,
            to.message,
            ])
    }
    
    init?(message: PlaygroundValue) {
        guard case let .array(values) = message, values.count == 2 else { return nil }
        guard let from = T(message: values[0]),
            let to = T(message: values[1]) else { return nil }
        
        self = Displacement(from: from, to: to)
    }
}

// MARK: CommandKey

/// A Sting the uniquely identifies every `Action`.
enum CommandKey: String {
    case move, turn, control, add, remove, run,
    
    // Includes all the `IncorrectAction` cases. 
    offEdge, intoWall, missingGem, missingSwitch, missingLock
}

extension Action {
    var key: CommandKey {
        switch self {
        case .move(_): return .move
        case .turn(_): return .turn
        case .add(_): return .add
        case .remove(_): return .remove
        case .control(_): return .control
        case .run(_): return .run
        case let .fail(action): return action.key
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
