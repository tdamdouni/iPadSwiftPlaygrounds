// 
//  DiffResult.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public enum DiffErrorType: Int, ErrorProtocol {
    case failedToPickUpGoal // A goal was in the initial map that was not removed.
    case incorrectSwitchState // Switch was left off.
}

public struct GridWorldResults {
    // MARK: Types
    
    public enum State {
        case Success
        case Failure
    }
    
    // Left over from prior tuple-based diff results; still needed for internal determination of correctness
    private let missedActions: Set<DiffResult>
    
    public let successCriteria: GridWorldSuccessCriteria
    public let passesCriteria: Bool
    
    public let numberOfCollectedGems: Int
    public let numberOfOpenSwitches: Int
    
    public init(criteria: GridWorldSuccessCriteria, missedActions: Set<DiffResult>, collectedGems: Int, openSwitches: Int) {
        
        successCriteria = criteria
        numberOfCollectedGems = collectedGems
        numberOfOpenSwitches = openSwitches
        
        self.missedActions = missedActions

        var gemSuccess = false
        if successCriteria.collectedGems == numberOfCollectedGems {
            gemSuccess = true
        } else if criteria.collectedGems == CriteriaAll {
            let missedGems = missedActions.filter {
                $0.type == .failedToPickUpGoal
            }
            gemSuccess = missedGems.isEmpty
        }
        
        var switchSuccess = false
        if criteria.openedSwitches == numberOfOpenSwitches {
            switchSuccess = true
        } else if criteria.openedSwitches == CriteriaAll {
            let missedSwitches = missedActions.filter {
                $0.type == .incorrectSwitchState
            }
            switchSuccess = missedSwitches.isEmpty
        }
        
        passesCriteria = gemSuccess && switchSuccess
    }
}

/**
 DiffResult is used to package up some additional information
 about the success or failure of interesting coordinates (coordinates
 with more than just inanimate world objects) within the gridWorld.
*/
public struct DiffResult {
    public let coordinate: Coordinate
    public let foundNodes: [SCNNode]
    
    /// `nil` if the result is not considered an error.
    public let type: DiffErrorType?
    
    public init(coordinate: Coordinate, foundNodes: [SCNNode] = [], type: DiffErrorType? = nil) {
        self.coordinate = coordinate
        self.foundNodes = foundNodes
        self.type = type
    }
}

extension DiffResult: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "[\(coordinate.column) | \(coordinate.row)] \(foundNodes.count) nodes - \(type)"
    }
}

extension DiffResult: Hashable {
    public var hashValue: Int {
        let typeVal = type?.rawValue ?? 25 // Unique value not likely in `DiffErrorType`
        let coorVal = coordinate.hashValue
        return (((coorVal + typeVal) * (coorVal + typeVal + 1)) / 2) + typeVal
    }
}
public func ==(lhs: DiffResult, rhs: DiffResult) -> Bool {
    return lhs.coordinate == rhs.coordinate
    && lhs.type == rhs.type
}
