//
//  Action.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

enum Action {
    // MARK: Types
    
    enum Movement: Int {
        case walk, jump, teleport
    }
    
    /// Displace from a position to a new position with the appropriate `Movement` type.
    case move(Displacement<SCNVector3>, type: Movement)
    
    /// Rotate between two angles specifying the direction with `clockwise`.
    /// The angle must be specified in radians.
    case turn(Displacement<SCNFloat>, clockwise: Bool)
    
    /// Add `Item`s to the world.
    case add([ItemID])
    
    /// Remove `Item`s from the world.
    case remove([ItemID])
    
    /// Holds the id of a `Controllable` item.
    /// Ex.
    /// Toggle a `Switch` on or off.
    /// Control a `PlatformLock` to move it's platforms up or down.
    /// Activate or deactivate a `Portal`.
    case control(Controller)
    
    /// Run a specific `EventGroup`.
    /// Providing a variation index will use a specific index if possible, falling back to random.
    case run(EventGroup, variation: Int?)
    
    /// An action was requested, but unable to be fulfilled. `IncorrectAction`
    /// describes the reason.
    case fail(IncorrectAction)
}

// MARK: Supporting Types

struct Controller {
    enum Kind: Int {
        case toggle, activate, movePlatforms
    }
    
    /// The `ItemID` of the `Controllable` item. 
    let identifier: ItemID
    
    let kind: Kind
    
    var state: Bool
    
    // MARK: Methods
    
    /// Used to retrive the `Controllable` associated with this controller from the world.
    func controllable(in world: GridWorld) -> Controllable? {
        return world.item(forID: identifier) as? Controllable
    }
    
    @discardableResult
    func setStateForItem(in world: GridWorld, animated: Bool = true) -> TimeInterval? {
        guard let item = controllable(in: world) else { return nil }
        return item.setState(state, animated: animated)
    }
}

struct Displacement<T: MessageConstructible> {
    let from: T
    let to: T
    
    var reversed: Displacement<T> {
        return Displacement(from: to, to: from)
    }
}

enum IncorrectAction {
    case offEdge, intoWall
    case missingGem, missingSwitch, missingLock
    
    var event: EventGroup {
        switch self {
        case .offEdge:
            return .almostFallOffEdge
            
        case .intoWall:
            return .bumpIntoWall
            
        case .missingGem:
            return .pickUp
            
        case .missingSwitch:
            return .toggleSwitch
            
        case .missingLock:
            return .turnLockRight
        }
    }
}

extension Action {
    /// Provides a mapping of the command to an `EventGroup`.
    var event: EventGroup? {
        switch self {
        case let .move(dis, type):
            return event(from: dis, type: type)
            
        case .turn(_, let clockwise):
            return clockwise ? .turnRight : .turnLeft
            
        case .control(let contr):
            return contr.event
            
        case .remove(_):
            return .pickUp
            
        case .add(_):
            return nil
            
        case let .run(anim, _):
            return anim
            
        case let .fail(command):
            return command.event
        }
    }
    
    private func event(from dis: Displacement<SCNVector3>, type: Action.Movement) -> EventGroup {
        let fromY = dis.from.y
        let toY = dis.to.y
        
        switch type {
        case .walk:
            if fromY.isClose(to: toY, epiValue: WorldConfiguration.heightTolerance) {
                return .walk
            }
            return fromY < toY ? .walkUpStairs : .walkDownStairs
            
        case .jump:
            if fromY.isClose(to: toY, epiValue: WorldConfiguration.heightTolerance) {
                return .jumpForward
            }
            return fromY > toY ? .jumpDown : .jumpUp
            
        case .teleport:
            return .teleport
        }
    }
    
    /// Returns a random index for one of the possible variations.
    /// Note: `.run(_:variation:)` is special cased to allow specific events to be requested.
    var variationIndex: Int {
        if case let .run(_, index) = self, let variation = index {
            return variation
        }
        
        if let event = self.event {
            let possibleVariations = EventGroup.allIdentifiersByType[event]
            return possibleVariations?.randomIndex ?? 0
        }
        
        return 0
    }
}

extension Controller {
    var event: EventGroup? {
        switch kind {
        case .activate: return nil
        case .toggle: return .toggleSwitch
        case .movePlatforms:
            return state ? .turnLockRight : .turnLockLeft
        }
    }
}

extension Action {
    
    var reversed: Action {
        switch self {
        case let .move(dis, type):
            return .move(dis.reversed, type: type)
            
        case let .turn(dis, clkwise):
            return .turn(dis.reversed, clockwise: !clkwise)
            
        case let .remove(nodes):
            return .add(nodes)

        case let .add(nodes):
            return .remove(nodes)

        case let .control(contr):
            var revContr = contr
            revContr.state = !contr.state
            return .control(revContr)
            
        case .run(_), .fail(_):
            return self
        }
    }
}

extension Action: Equatable {}
func ==(lhs: Action, rhs: Action) -> Bool {
    switch (lhs, rhs) {
    case (let .move(dis1, type1), let .move(dis2, type2)):
        return type1 == type2
        && dis1.to == dis2.to && dis1.from == dis2.from
        
    case (let .turn(dis1, clk1), let .turn(dis2, clk2)):
        return clk1 == clk2
        && dis1.to == dis2.to && dis1.from == dis2.from
        
    case (let .remove(nodes1), let .remove(nodes2)):
        return nodes1 == nodes2
        
    case (let .control(coor1), let .control(coor2)):
        return coor1.identifier == coor2.identifier
        && coor1.state == coor2.state
        
    default:
        return lhs.event == rhs.event
    }
}
