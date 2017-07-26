// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
public let world = GridWorld(columns: 8, rows: 8)

public func playgroundPrologue() {
    Display.coordinateMarkers = true
   
    
    var successPlacements: [Coordinate] = []
    for coor in world.allPossibleCoordinates {
        if coor.column > 5 || coor.row < 4 {
            successPlacements.append(coor)
        }
    }
    
    let handler = assessment(world.blocksPresent(count: 7, at: successPlacements))
    world.successCriteria = .pageSpecific(handler)

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

public func presentWorld() {
    setUpLiveViewWith(world)
}

// MARK: Epilogue
    
public func playgroundEpilogue() {
    sendCommands(for: world)
}


