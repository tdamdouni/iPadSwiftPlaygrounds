// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 9, rows: 7)
public let world = loadGridWorld(named: "12.7")
public func playgroundPrologue() {

//    placeBlocks()
    placeItems()
    placePortals()
    Display.coordinateMarkers = true
    
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
    world.placeGems(at: [Coordinate(column: 1, row: 1)])
    world.placeGems(at: [Coordinate(column: 1, row: 6)])
    world.placeGems(at: [Coordinate(column: 6, row: 1)])
    let topLock = PlatformLock(color: .red)
    world.place(topLock, facing: west, at: Coordinate(column: 3, row: 6))
    let platform1 = Platform(onLevel: 1, controlledBy: topLock)
    world.place(platform1, at: Coordinate(column: 2, row: 2))
    
    let lowerLock = PlatformLock(color: .blue)
    world.place(lowerLock, facing: west, at: Coordinate(column: 3, row: 1))
    let platform2 = Platform(onLevel: 1, controlledBy: lowerLock)
    world.place(platform2, at: Coordinate(column: 6, row: 2))
}
    
func placePortals() {

    world.place(Portal(color: .blue), between: Coordinate(column: 2, row: 0), and: Coordinate(column: 6, row: 6))
}

func placeBlocks() {
    world.removeItems(at: world.allPossibleCoordinates)
    world.placeWater(at: world.allPossibleCoordinates)
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3], intersectingRows: [0,1,3,4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,3,6], intersectingRows: [3,4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,3,6], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,3,6], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [2], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [2], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [2], intersectingRows: [6]))
    world.placeBlocks(at: world.coordinates(inColumns: 5...7, intersectingRows: [1]))
    
    world.place(nodeOfType: Stair.self, facing:  south, at: world.coordinates(inColumns: [2], intersectingRows: [3, 4, 5]))
    world.place(nodeOfType: Stair.self, facing:  south, at: world.coordinates(inColumns: [6], intersectingRows: [3, 4]))
}
