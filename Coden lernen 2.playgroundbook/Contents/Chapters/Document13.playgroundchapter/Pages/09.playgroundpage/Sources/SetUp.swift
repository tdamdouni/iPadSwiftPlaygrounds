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
    
    // Reset the `successCriteria` every run. 
    world.successCriteria = .all
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
    
public func playgroundEpilogue(block: @escaping (GridWorld) -> Swift.Void) {
    // Call it once to simulate a normal run of the world.
    block(world)

    let handler = assessment(world.randomizedLandscape(worldConfig: block))
    world.successCriteria = .pageSpecific(handler)
    
    sendCommands(for: world)
}
