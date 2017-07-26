// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 9, rows: 9)
public let world = loadGridWorld(named: "12.2")

public func playgroundPrologue() {
//    addStaticElements()
    addGameNodes()
    
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

func addStaticElements() {
    world.removeNodes(at: world.coordinates(inColumns: 0...3, intersectingRows: 0...3))
    world.removeNodes(at: world.coordinates(inColumns: [7,8], intersectingRows: 0...3))
    world.removeNodes(at: world.coordinates(inColumns: 3...8, intersectingRows: [7,8]))
    
    
    world.removeNodes(at: world.coordinates(inColumns: [6], intersectingRows: [1,2]))
    world.removeNodes(at: world.coordinates(inColumns: [3], intersectingRows: [4,5,6]))
    world.removeNodes(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [3]))
    world.placeWater(at: world.coordinates(inColumns: [6], intersectingRows: [1,2]))
    world.placeWater(at: world.coordinates(inColumns: [3], intersectingRows: [4,5,6]))
    world.placeWater(at: world.coordinates(inColumns: [4,5,6], intersectingRows: [3]))
    
    
    world.placeBlocks(at: world.coordinates(inColumns: [1], intersectingRows: 4...8))
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: [6,7,8]))
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: [7,8]))
    world.placeBlocks(at: world.coordinates(inColumns: [2], intersectingRows: [8]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [4,5,6,7,8], intersectingRows: [6]))
    world.placeBlocks(at: world.coordinates(inColumns: [4,5], intersectingRows: [6]))
    world.placeBlocks(at: world.coordinates(inColumns: [7,8], intersectingRows: [4]))
    
    
    world.place(nodeOfType: Stair.self, facing: east, at: world.coordinates(inColumns: [2], intersectingRows: [5]))
}

func addGameNodes() {
    world.placeGems(at: world.coordinates(inColumns: [1], intersectingRows: 5...8))
    world.placeGems(at: world.coordinates(inColumns: [5], intersectingRows: [0,1,2,4]))
    world.placeGems(at: world.coordinates(inColumns: [4,5,6,7], intersectingRows: [5]))
    
    let lock = PlatformLock(color: .purple)
    world.place(lock, facing: north, at: Coordinate(column: 1, row: 4))
    let platform1 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 5))
    let lock2 = PlatformLock(color: .green)
    world.place(lock2, facing: west, at: Coordinate(column: 8, row: 5))
    let platform2 = Platform(onLevel: 1, controlledBy: lock2)
    world.place(platform2, at: Coordinate(column: 5, row: 3))
}
