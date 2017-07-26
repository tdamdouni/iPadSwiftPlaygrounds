// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "9.1")
let actor = Actor()

public func playgroundPrologue() {
    placeActor()
    placeItems()
    

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
    
    
    world.removeNodes(at: [Coordinate(column: 3, row: 0)])
    world.removeNodes(at: [Coordinate(column: 3, row: 2)])
    
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 1))
}
