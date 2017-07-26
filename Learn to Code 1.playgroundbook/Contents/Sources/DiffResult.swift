// 
//  CriteriaResults.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public enum DiffErrorType: Int, Error {
    case failedToPickUpGoal // A goal was in the initial map that was not removed.
    case incorrectSwitchState // Switch was left closed.
}

public struct GridWorldResults {
    
    public let missedActions: [DiffResult]
    
    public let successCriteria: GridWorld.SuccessCriteria
    public let passesCriteria: Bool
    
    public let numberOfCollectedGems: Int
    public let numberOfOpenSwitches: Int
    
    public init(criteria: GridWorld.SuccessCriteria, missedActions: [DiffResult], collectedGems: Int, openSwitches: Int) {
        
        successCriteria = criteria
        numberOfCollectedGems = collectedGems
        numberOfOpenSwitches = openSwitches
        
        self.missedActions = missedActions
    
        switch criteria {
        case .all:
            let gemSuccess = missedActions.filter {
                $0.type == .failedToPickUpGoal
            }.isEmpty
            
            let switchSuccess = missedActions.filter {
                $0.type == .incorrectSwitchState
            }.isEmpty
            passesCriteria = gemSuccess && switchSuccess

        case let .count(collectedGems, openSwitches):
            let gemSuccess = collectedGems == numberOfCollectedGems
            let switchSuccess = openSwitches == numberOfOpenSwitches
            passesCriteria = gemSuccess && switchSuccess

        case let .pageSpecific(evaluationFunction):
            passesCriteria = evaluationFunction()
        }
    }
}

// MARK: DiffResult

/**
 DiffResult is used to package up some additional information
 about the success or failure of interesting coordinates (coordinates
 with a Switch or Gem) within the gridWorld.
*/
public struct DiffResult {
    public let coordinate: Coordinate
    
    /// `nil` if the result is not considered an error.
    public let type: DiffErrorType?
    
    public init(coordinate: Coordinate, type: DiffErrorType? = nil) {
        self.coordinate = coordinate
        self.type = type
    }
}
