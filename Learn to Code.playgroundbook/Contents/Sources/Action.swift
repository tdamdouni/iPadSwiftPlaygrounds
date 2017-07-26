//
//  Action.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

enum IncorrectAction {
    case offEdge, intoWall
    case missingGem, missingSwitch, missingLock
    
    var animation: AnimationType {
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

enum Action {
    case move(from: SCNVector3, to: SCNVector3)
    case jump(from: SCNVector3, to: SCNVector3)
    case teleport(from: SCNVector3, to: SCNVector3)
    
    /// The angle must be specified in radians.
    case turn(from: SCNFloat, to: SCNFloat, clockwise: Bool)
    
    case place([Int])
    case remove([Int])
    
    /// Holds the id of a `Toggleable` item.
    case toggle(toggleable: Int, active: Bool)
    case control(lock: PlatformLock, movingUp: Bool)
    
    case incorrect(IncorrectAction)
    
    /// Provides a mapping of the command to an `AnimationType`.
    var animation: AnimationType? {
        switch self {
        case let .move(from, to):
            if from.y.isClose(to: to.y, epiValue: WorldConfiguration.heightTolerance) {
                return .walk
            }
            return from.y < to.y ? .walkUpStairs : .walkDownStairs
            
        case let jump(from, to):
            return from.y > to.y ? .jumpDown : .jumpUp
            
        case .teleport(_):
            return .teleport
            
        case .turn(_, _, let clockwise):
            return clockwise ? .turnRight : .turnLeft
            
        case .toggle(_):
            return .toggleSwitch
            
        case .control(_, let isMovingUp):
            return isMovingUp ? .turnLockRight : .turnLockLeft
            
        case .remove(_):
            return .pickUp
            
        case .place(_):
            return nil
            
        case let .incorrect(command):
            return command.animation
        }
    }
}

extension Action {
    
    var isPickUpCommand: Bool {
        if case .remove(_) = self {
            return true
        }
        return false
    }
    
    var reversed: Action {
        switch self {
        case let .move(to, from):
            return .move(from: from, to: to)
            
        case let .jump(to, from):
            return .jump(from: from, to: to)
        
        case let .teleport(start, end):
            return .teleport(from: end, to: start)
            
        case let .turn(from, to, clkwise):
            return .turn(from: to, to: from, clockwise: clkwise)
            
        case let .remove(nodes):
            return .place(nodes)

        case let .place(nodes):
            return .remove(nodes)
            
        case let .toggle(item, on):
            return .toggle(toggleable: item, active: !on)
            
        case let .control(lock, isMovingUp):
            return .control(lock: lock, movingUp: !isMovingUp)
            
        case .incorrect(_):
            return self
        }
    }
}

extension Action: Equatable {}
func ==(lhs: Action, rhs: Action) -> Bool {
    switch (lhs, rhs) {
    case (let .move(to1, from1), let .move(to2, from2)):
        return Coordinate(to1) == Coordinate(to2)
        && Coordinate(from1) == Coordinate(from2)
        
    case (let .turn(deg1), let .turn(deg2)):
        return deg1 == deg2
        
    case (let .remove(nodes1), let .remove(nodes2)):
        return nodes1 == nodes2
        
    case (let .toggle(coor1), let .toggle(coor2)):
        return coor1 == coor2
        
    default:
        return lhs.animation == rhs.animation
    }
}
