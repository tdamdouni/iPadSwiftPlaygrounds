// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
public let world = loadGridWorld(named: "12.5")

public func playgroundPrologue() {

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
    world.placeGems(at: world.coordinates(inColumns: [4], intersectingRows: [0]))
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 2, row: 1))
    let platform1 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 2, row: 4))
    let platform2 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 3, row: 4))
}

func placeBlocks() {
    world.removeItems(at: world.coordinates(inColumns: [0,2,3], intersectingRows: 0...5))
    world.placeWater(at: world.coordinates(inColumns: [0,2,3], intersectingRows: 0...5))
    
    
    world.placeBlocks(at: world.coordinates(inColumns: 0...7, intersectingRows: [8]))
    world.placeBlocks(at: world.coordinates(inColumns: 2...4, intersectingRows: [8]))
    world.placeBlocks(at: world.coordinates(inColumns: [1], intersectingRows: 0...4))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: 0...5))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: 0...2))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7], intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [2], intersectingRows: [1]))
    world.placeBlocks(at: world.coordinates(inColumns: [2], intersectingRows: [1]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7], intersectingRows: [1,2,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7], intersectingRows: [1,2,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [6,7], intersectingRows: [1,2,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [5], intersectingRows: [1]))
    world.placeBlocks(at: world.coordinates(inColumns: [5], intersectingRows: [1]))
    
    
    world.place(nodeOfType: Stair.self, facing: north, at: world.coordinates(inColumns: [1], intersectingRows: [5]))
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [1], intersectingRows: [8]))
    
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [5], intersectingRows: [1]))
    world.place(nodeOfType: Stair.self, facing: west, at: world.coordinates(inColumns: [5], intersectingRows: [5]))
    world.place(nodeOfType: Stair.self, facing: east, at: world.coordinates(inColumns: [5], intersectingRows: [8]))
    
    world.place(nodeOfType: Stair.self, facing:  south, at: world.coordinates(inColumns: [6], intersectingRows: [7]))
    world.place(nodeOfType: Stair.self, facing: north, at: world.coordinates(inColumns: [4], intersectingRows: [3]))
}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    world.place(expertMarker, facing: east, at: Coordinate(column: 0, row: 8))
}
