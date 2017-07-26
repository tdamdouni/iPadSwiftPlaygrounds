// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 5)
public let world = loadGridWorld(named: "13.1")
let actor = Actor()

public func playgroundPrologue() {
    Display.coordinateMarkers = true
//    placeBlocks()
    placeItems()
    placeActor()
    world.placeBlocks(at: world.coordinates(inColumns: [2,4,6], intersectingRows: [2]))

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

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 4))
}
    
func placeItems() {
    let _ = world.place(nodeOfType: Switch.self, at: world.coordinates(inColumns: [2,4,6], intersectingRows: [4]))
    world.placeGems(at: world.coordinates(inColumns: [2,4,6], intersectingRows: [0]))
}
    
func placeBlocks() {
    world.removeItems(at: world.coordinates(inRows:[2]))
    world.removeItems(at: world.coordinates(inColumns: [3,5], intersectingRows: [0,1]))
    world.placeWater(at: world.coordinates(inRows:[2]))
    world.placeWater(at: world.coordinates(inColumns: [3,5], intersectingRows: [0,1]))
    
    
    world.placeBlocks(at: world.coordinates(inRows:[4]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2,6], intersectingRows: [4]))
    world.placeBlocks(at: world.coordinates(inColumns: [2,6], intersectingRows: [0,1,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [2,4,6], intersectingRows: [0]))
    
    let _ = world.place(nodeOfType: Stair.self, facing: north, at: world.coordinates(inColumns: [2,4,6], intersectingRows: [1]))
    let _ = world.place(nodeOfType: Stair.self, facing:  south, at: world.coordinates(inColumns: [2,4,6], intersectingRows: [3]))
    
    world.place(Stair(), facing: east, at: Coordinate(column: 3, row: 3))
    world.place(Stair(), facing: west, at: Coordinate(column: 5, row: 3))
}
