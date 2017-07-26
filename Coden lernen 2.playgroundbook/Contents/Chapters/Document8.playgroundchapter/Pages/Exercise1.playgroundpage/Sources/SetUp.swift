// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "9.1")
let actor = Actor()

public var finalGemCount = 0
public var initialGemCount = 0

public func playgroundPrologue() {
    placeActor()
    placeItems()
    
    let handler = assessment(world.collectedGemsAndUserVariablesAreCorrectlyAssigned(userVariableValues: (finalGemCount, initialGemCount), expectedVariableValues: (1,0)))
    
    world.successCriteria = .pageSpecific(handler)

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeItems() {
    world.placeGems(at: [Coordinate(column: 3, row: 1)])
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 1))
}

func placeBlocks() {
    world.placeBlocks(at: world.allPossibleCoordinates)
    world.placeBlocks(at: [Coordinate(column: 3, row: 1)])
    
    
    world.removeItems(at: [Coordinate(column: 3, row: 0)])
    world.removeItems(at: [Coordinate(column: 3, row: 2)])
    
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 1))
}
