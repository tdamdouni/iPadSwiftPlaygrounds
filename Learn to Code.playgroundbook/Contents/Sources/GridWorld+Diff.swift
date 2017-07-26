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
        var missedActions = Set<DiffResult>()
        
        //--- Search the world for gems that were not collected.
        let gems = existingGems(at: allPossibleCoordinates)
        for gem in gems {
            let result = DiffResult(coordinate: gem.coordinate, foundNodes: [gem.scnNode], type: .failedToPickUpGoal)
            missedActions.insert(result)
        }
        
        let pickupCount = commandQueue.collectedGemCount()
        
        //--- Check on/off state for all switches in the current world
        var openedSwitchCount = 0
        
        for switchNode in existingNodes(ofType: Switch.self, at: allPossibleCoordinates) {
            let coordinate = switchNode.coordinate
            
            if switchNode.isOn {
                openedSwitchCount += 1
            }
            else {
                missedActions.insert(DiffResult(coordinate: coordinate, foundNodes: [switchNode.scnNode], type: .incorrectSwitchState))
            }
        }
        
        let criteria = self.successCriteria ?? GridWorldSuccessCriteria()
        return GridWorldResults(criteria: criteria, missedActions: missedActions, collectedGems: pickupCount, openSwitches: openedSwitchCount)
    }
}
