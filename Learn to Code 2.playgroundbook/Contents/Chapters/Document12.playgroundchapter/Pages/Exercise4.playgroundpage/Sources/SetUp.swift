// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 5, rows: 5)
public let world = loadGridWorld(named: "13.8")
let actor = Actor()



public func playgroundPrologue() {
    Display.coordinateMarkers = true
//    placeBlocks()
    world.place(actor, facing: south, at: Coordinate(column: 2, row: 2))
    
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
    world.placeBlocks(at: world.coordinates(inRows:[0,4]))
    world.placeBlocks(at: world.coordinates(inColumns:[0,4]))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 1))
    world.place(Stair(), facing: east, at: Coordinate(column: 1, row: 2))
    world.place(Stair(), facing:  south, at: Coordinate(column: 2, row: 3))
    world.place(Stair(), facing: west, at: Coordinate(column: 3, row: 2))
    
    world.place(nodeOfType: Stair.self, facing: north, at: world.coordinates(inColumns: [0,4], intersectingRows: [1]))
    world.place(nodeOfType: Stair.self, facing:  south, at: world.coordinates(inColumns: [0,4], intersectingRows: [3]))
    
    world.place(nodeOfType: Stair.self, facing: east, at: world.coordinates(inColumns: [1], intersectingRows: [0,4]))
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [3], intersectingRows: [0,4]))
}
