// 
//  EventGroup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

/// The different events (animation or audio) that an actor can perform.
/// These are top level identifiers for the asset variations (e.g. Walk, Walk02).
enum EventGroup: String {
    case `default`
    case idle, happyIdle
    case turnLeft, turnRight
    case pickUp
    case toggleSwitch
    
    case walk
    case walkUpStairs
    case walkDownStairs
    case run, runUpStairs, runDownStairs

    case jumpUp, jumpDown, jumpForward
    case teleport
    
    case turnLockLeft, turnLockRight
    
    case bumpIntoWall
    case almostFallOffEdge
    
    case defeat
    case victory, celebration
    
    case leave, arrive
    case pickerReactLeft, pickerReactRight
    
    /// The asset identifiers for every EventGroup.
    /// These identifiers correspond directly with asset names `(identifier).dae` and `(identifier).m4a`
    /// as described in Assets.swift.
    static var allIdentifiersByType: [EventGroup: [String]] {
        return [
            .default: ["BreathingIdle"],
            .happyIdle: ["HappyIdle"],
            .idle: ["Idle01", "Idle02", "Idle03", "BreatheLookAround"],
            .turnLeft: ["TurnLeft",],
            .turnRight: ["TurnRight",],
            .pickUp: ["GemTouch",],
            .toggleSwitch: ["Switch"],
            
            // Repeat "Walk" so that it is more likely in a random selection.
            .walk: ["Walk", "Walk", "Walk02"],
            .walkUpStairs: ["StairsUp", "StairsUp02"],
            .walkDownStairs: ["StairsDown", "StairsDown02"],
            .run: ["RunFast01", "RunFast02"],
            .runDownStairs: ["StairsDownFast"],
            .runUpStairs: ["StairsUpFast"],
            
            .jumpForward: ["Jump"],
            .jumpUp: ["JumpUp"],
            .jumpDown: ["JumpDown"],
            
            .teleport: ["Portal"],
            .turnLockLeft: ["LockPick01"],
            .turnLockRight: ["LockPick03"],
            
            .bumpIntoWall: ["BumpIntoWall",],
            .almostFallOffEdge: ["AlmostFallOffEdge",],
            
            .defeat: ["Defeat", "Defeat02", "HeadScratch"],
            .victory: ["Victory", "Victory02"],
            .celebration: ["CelebrationDance"],
            .leave: ["LeavePicker"],
            .arrive: ["ArrivePicker"],
            .pickerReactLeft: ["PickerReactLeft"],
            .pickerReactRight: ["PickerReactRight"],
        ]
    }
    
    // MARK: Static Properties
    
    static var walkingAnimations: [EventGroup] {
        return [.walk, .walkUpStairs, .walkDownStairs, .turnLeft, .turnRight]
    }
    
    static func levelCompleteAnimations(for pass: Bool) -> [EventGroup] {
        if pass {
            return [.victory, .celebration, .happyIdle]
        }
        else {
            return [.defeat]
        }
    }
    
    // MARK: Properties
    
    var fastVariation: EventGroup? {
        switch self {
        case .walk: return .run
        case .walkUpStairs: return .runUpStairs
        case .walkDownStairs: return .runDownStairs
            
        default:
            return nil
        }
    }
    
    var isStationary: Bool {
        switch self {
        case .walk, .run,
             .walkUpStairs, .walkDownStairs,
             .runUpStairs, .runDownStairs,
             .turnLeft, .turnRight,
             .jumpUp, .jumpDown,
             .leave, .arrive,
             .teleport:
            
            return false
            
        default:
            return true
        }
    }
    
    var identifiers: [String] {
        return EventGroup.allIdentifiersByType[self] ?? []
    }
}

// MARK: EventVariation

struct EventVariation {
    var event: EventGroup
    var variationIndex: Int
    
    var identifier: String {
        guard let events = EventGroup.allIdentifiersByType[event],
            events.indices.contains(variationIndex) else { return "" }
        
        return events[variationIndex]
    }
}

extension EventVariation: Equatable {}
func ==(lhs: EventVariation, rhs: EventVariation) -> Bool {
    return lhs.event == rhs.event && lhs.variationIndex == rhs.variationIndex
}
