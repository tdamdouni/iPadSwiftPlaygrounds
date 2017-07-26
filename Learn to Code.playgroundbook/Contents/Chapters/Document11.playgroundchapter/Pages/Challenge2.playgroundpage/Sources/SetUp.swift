// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 9, rows: 5)
public let world = loadGridWorld(named: "11.5")

public func playgroundPrologue() {
    placeItems()
    placeLocks()
    placeMissingStairs()

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

func placeMissingStairs() {
    world.place(Stair(), facing:  south, at: Coordinate(column: 7, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 7, row: 3))
}


func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: 2...6, intersectingRows: [1,3]))
    world.removeNodes(at: world.coordinates(inColumns: [3,5], intersectingRows: [2]))
    
    world.placeWater(at: world.coordinates(inColumns: 2...6, intersectingRows: [1,3]))
    world.placeWater(at: world.coordinates(inColumns: [3,5], intersectingRows: [2]))
    
    
    world.placeBlocks(at: world.coordinates(inColumns:[1,7]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,7,8], intersectingRows: [2]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,8], intersectingRows: [2]))
    
    
    world.place(Stair(), facing:  south, at: Coordinate(column: 1, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 1, row: 3))
    
    world.place(nodeOfType: Stair.self, facing: east, at: world.coordinates(inColumns: [2], intersectingRows: [0,4]))
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [6], intersectingRows: [0,4]))

}

func placeItems() {
    world.placeGems(at: [Coordinate(column: 4, row: 2)])
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 2, row: 2)])
    
}

func placeLocks() {
    let lock = PlatformLock(color: .pink)
    world.place(lock, facing: east, at: Coordinate(column: 0, row: 2))
    let lock1 = PlatformLock(color: .green)
    world.place(lock1, facing: west, at: Coordinate(column: 8, row: 2))
    let platform1 = Platform(onLevel: 1, controlledBy: lock1)
    world.place(platform1, at: Coordinate(column: 3, row: 2))
    let platform2 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 5, row: 2))

}

