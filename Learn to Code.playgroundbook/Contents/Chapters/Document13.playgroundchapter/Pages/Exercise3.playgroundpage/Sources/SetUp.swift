// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 7, rows: 9)
public let world = loadGridWorld(named: "13.7")
let actor = Actor()



public func playgroundPrologue() {
//    placeBlocks()
    placeItems()

    world.place(actor, facing: north, at: Coordinate(column: 3, row: 0))

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

func placeItems() {
    world.place(nodeOfType: Switch.self, at: world.coordinates(inColumns: [0,6], intersectingRows: [4,5,6]))
    world.place(nodeOfType: Switch.self, at: world.coordinates(inColumns: [2,3,4], intersectingRows: [8]))
}

func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: [0,1,5,6], intersectingRows: [0,1,2,3,7,8]))
    
    world.placeWater(at: world.coordinates(inColumns: [0,1,5,6], intersectingRows: [0,1,2,3,7,8]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [2,3,4], intersectingRows: 2...8))
    world.placeBlocks(at: world.coordinates(inRows:[4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [2,4], intersectingRows: [3]))
}
