// 
//  AnimationType.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

/// The different actions that an animated actor can perform.
enum AnimationType: String {
    case `default`
    case idle, happyIdle
    case turnLeft, turnRight
    case pickUp
    case toggleSwitch
    
    case walk
    case walkUpStairs
    case walkDownStairs
    case run, runUpStairs, runDownStairs

    case jumpUp, jumpDown
    case teleport
    
    case turnLockLeft, turnLockRight
    
    case bumpIntoWall
    case almostFallOffEdge
    
    case defeat
    case victory, celebration
    
    case leave, arrive
    case pickerReactLeft, pickerReactRight
    
    static var allIdentifiersByType: [AnimationType: [String]] {
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
    
    static var walkingAnimations: [AnimationType] {
        return [.walk, .walkUpStairs, .walkDownStairs, .turnLeft, .turnRight]
    }
    
    var fastVariation: AnimationType? {
        switch self {
        case .walk: return .run
        case .walkUpStairs: return .runUpStairs
        case .walkDownStairs: return .runDownStairs
        
        default:
            return nil
        }
    }
    
    static func levelCompleteAnimations(for pass: Bool) -> [AnimationType] {
        if pass {
            return [.victory, .celebration, .happyIdle]
        }
        else {
            return [.defeat]
        }
    }
}
