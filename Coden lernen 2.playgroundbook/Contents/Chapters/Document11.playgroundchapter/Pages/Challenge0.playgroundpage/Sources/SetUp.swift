// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 8)
public let world = loadGridWorld(named: "12.1")


public func playgroundPrologue() {

    placePlatforms()
    placeStair()
    placeItems()
    placeStartMarker()

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
    world.placeGems(at: world.coordinates(inColumns: [4], intersectingRows: [5]))
    world.placeGems(at: world.coordinates(inColumns: [5], intersectingRows: [0,6]))
    world.placeGems(at: world.coordinates(inColumns: [6], intersectingRows: [1,5]))
    world.placeGems(at: world.coordinates(inColumns: [7], intersectingRows: [2,4]))
}

func placePlatforms() {
    let lock = PlatformLock(color: .blue)
    world.place(lock, facing: east, at: Coordinate(column: 0, row: 6))
    let lock2 = PlatformLock(color: .orange)
    world.place(lock2, facing: north, at: Coordinate(column: 1, row: 5))
    let lock3 = PlatformLock(color: .green)
    world.place(lock3, facing: south, at: Coordinate(column: 1, row: 7))
    let lock4 = PlatformLock(color: .pink)
    world.place(lock4, facing: west, at: Coordinate(column: 2, row: 6))
    
    
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 5, row: 1))
    let platform2 = Platform(onLevel: 1, controlledBy: lock2)
    world.place(platform2, at: Coordinate(column: 6, row: 2))
    let platform3 = Platform(onLevel: 1, controlledBy: lock3)
    world.place(platform3, at: Coordinate(column: 5, row: 5))
    let platform4 = Platform(onLevel: 1, controlledBy: lock4)
    world.place(platform4, at: Coordinate(column: 6, row: 4))
}

func placeStair() {
    world.place(Stair(), facing: south, at: Coordinate(column: 4, row: 4))
}

func placeBlocks() {
    world.removeItems(at: world.coordinates(inColumns: [0,1,2,3], intersectingRows: 4...7))
    world.placeWater(at: world.coordinates(inColumns: [0,1,2,3], intersectingRows: 4...7))
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: 5...7))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1,2], intersectingRows: 5...7))
    
    world.removeItems(at: world.coordinates(inColumns: [0,1,2,3,4], intersectingRows: [0]))
    world.removeItems(at: world.coordinates(inColumns: [5], intersectingRows: [1,5]))
    world.removeItems(at: world.coordinates(inColumns: [6], intersectingRows: [2,4]))
    world.placeWater(at: world.coordinates(inColumns: [0,1,2,3,4], intersectingRows: [0]))
    world.placeWater(at: world.coordinates(inColumns: [5], intersectingRows: [1,5]))
    world.placeWater(at: world.coordinates(inColumns: [6], intersectingRows: [2,4]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [2,3,4,6,7], intersectingRows: [1,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [4,6,7], intersectingRows: [1,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7], intersectingRows: [3]))
    world.placeBlocks(at: world.coordinates(inColumns: [3,4,6,7], intersectingRows: [1]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [0]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [0]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [0]))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: [4,5,7]))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: [4,5,7]))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: [5,7]))
    world.placeBlocks(at: world.coordinates(inColumns: [6], intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [6], intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [6], intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [7]))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [7]))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [7]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7], intersectingRows: [7]))
    
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [1,2,3], intersectingRows: [1]))
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [1,3], intersectingRows: [3]))
    world.place(Stair(), facing: south, at: Coordinate(column: 4, row: 4))
    
    world.place(Wall(edges: [.top]), at: Coordinate(column: 0, row: 2))
}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    let chararacterMarker = StartMarker(type: .byte)

    world.place(expertMarker, facing: north, at: Coordinate(column: 1, row: 6))
    world.place(chararacterMarker, facing: north, at: Coordinate(column: 4, row: 3))
}
