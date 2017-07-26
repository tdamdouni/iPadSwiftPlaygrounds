// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
public let world = GridWorld(columns: 4, rows: 4)


public func playgroundPrologue() {
    Display.coordinateMarkers = true
    let successPlacements = [
        Coordinate(column: 0, row: 0),
        Coordinate(column: 3, row: 0),
        Coordinate(column: 0, row: 3),
        Coordinate(column: 3, row: 3)
    ]
    
    let handler = assessment(world.blocksPresent(count: 6, at: successPlacements))
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


