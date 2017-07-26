// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 7)
public let world = loadGridWorld(named: "11.1")

public func playgroundPrologue() {
    placeItems()
//    placeBlocks()
    placeLocks()

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

// MARK: Placement

func placeItems() {
     world.placeGems(at: [Coordinate(column: 0, row: 3), Coordinate(column: 3, row: 0), Coordinate(column: 3, row: 6)])
}

func placeLocks() {
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 7, row: 3))
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 1))
    
}

func placeBlocks() {
    world.removeNodes(at: Coordinate(column: 3, row: 1))
    world.place(Water(), at: Coordinate(column: 3, row: 1))
    
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2,4,5,6], intersectingRows: [0,1,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,5,6], intersectingRows: [0,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,6], intersectingRows: [0,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [3]))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 3, row: 4))
    world.place(Stair(), facing: east, at: Coordinate(column: 4, row: 3))
    world.place(Stair(), facing: south, at: Coordinate(column: 3, row: 2))
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 3))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 0, row: 2))
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 4))
    
    
    world.removeNodes(at: world.coordinates(inColumns: [7], intersectingRows: [0,1,2,4,5,6]))
    
    
}

 

 


