// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 6, rows: 6)
public let world = loadGridWorld(named: "13.5")
let actor = Actor()

public func playgroundPrologue() {
//    placeBlocks()
    world.place(actor, facing: south, at: Coordinate(column: 0, row: 5))
    world.place(Switch(), at: Coordinate(column: 5, row: 0))
    
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

// MARK: Placement

func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: [0,1,2], intersectingRows: [0,1,2]))
    world.removeNodes(at: world.coordinates(inColumns: [3,4,5], intersectingRows: [3,4,5]))
    
    world.removeNodes(at: world.coordinates(inColumns: [1,2], intersectingRows: [4,5]))
    world.removeNodes(at: world.coordinates(inColumns: [4,5], intersectingRows: [1,2]))
    world.placeWater(at: world.coordinates(inColumns: [1,2], intersectingRows: [4,5]))
    world.placeWater(at: world.coordinates(inColumns: [4,5], intersectingRows: [1,2]))
    
    
    world.place(Block(), at: Coordinate(column: 0, row: 5))
    world.place(Block(), at: Coordinate(column: 0, row: 5))
    world.place(Block(), at: Coordinate(column: 0, row: 4))
    world.place(Block(), at: Coordinate(column: 0, row: 3))
    
    world.place(Block(), at: Coordinate(column: 5, row: 0))
    world.place(Block(), at: Coordinate(column: 5, row: 0))
    world.place(Block(), at: Coordinate(column: 4, row: 0))
    world.place(Block(), at: Coordinate(column: 3, row: 0))
    
    world.place(Switch(), at: Coordinate(column: 5, row: 0))
    
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 4))
    world.place(Stair(), facing: east, at: Coordinate(column: 1, row: 3))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 3, row: 1))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 0))
}
