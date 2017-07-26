// 
//  GridWorld+Diff.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

extension GridWorld {    
    // MARK: Diff Calculation
    
    /**
     Checks for the following:
        - All gems in the final world have been removed.
        - All switches in the final world are on.
    */
    func calculateResults() -> GridWorldResults {
        // Collect the results for any neglected gems or closed switches.
        var missedActions = [DiffResult]()
        
        //--- Search the world for gems that were not collected.
        let gems = existingGems(at: allPossibleCoordinates)
        for gem in gems {
            let result = DiffResult(coordinate: gem.coordinate, type: .failedToPickUpGoal)
            missedActions.append(result)
        }
        
        let pickupCount = commandQueue.collectedGemCount()
        
        //--- Check on/off state for all switches in the current world
        var openSwitchCount = 0
        
        for switchNode in existingItems(ofType: Switch.self, at: allPossibleCoordinates) {
            if switchNode.isOn {
                openSwitchCount += 1
            }
            else {
                let result = DiffResult(coordinate: switchNode.coordinate, type: .incorrectSwitchState)
                missedActions.append(result)
            }
        }
        
        return GridWorldResults(criteria: successCriteria, missedActions: missedActions, collectedGems: pickupCount, openSwitches: openSwitchCount)
    }
}
