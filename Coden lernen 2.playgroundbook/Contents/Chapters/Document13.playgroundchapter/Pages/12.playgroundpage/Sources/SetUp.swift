// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
public let world = GridWorld(columns: 12, rows: 12)


public func playgroundPrologue() {
    Display.coordinateMarkers = true
   
    let handler = assessment(world.containsStatements(minimumCount: 9))
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


