// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 7, rows: 7)
public let world = loadGridWorld(named: "11.2")

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

func addStaticElements() {
    world.removeNodes(at: world.coordinates(inColumns:[0,1,2,3,4,5,6]))
    world.placeWater(at: world.coordinates(inColumns:[0,1,2,3,4,5,6]))
    
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,5], intersectingRows: [5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,5], intersectingRows: [5,6]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [6]))
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [6]))
    
    world.placeBlocks(at: world.coordinates(inColumns: 1...6, intersectingRows: [2]))
    world.placeBlocks(at: world.coordinates(inColumns: 1...6, intersectingRows: [2]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [0,1,3]))
    world.placeBlocks(at: world.coordinates(inColumns: [3], intersectingRows: [0,1,3]))
}

func addGameNodes() {
    world.placeGems(at: [Coordinate(column: 1, row: 5), Coordinate(column: 3, row: 6), Coordinate(column: 5, row: 5)])
    world.placeGems(at: [Coordinate(column: 2, row: 2), Coordinate(column: 3, row: 1), Coordinate(column: 4, row: 2)])
    
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 1, row: 2), Coordinate(column: 3, row: 0)])
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 6, row: 2))
    let platform1 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 4))
    let platform2 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 3, row: 5))
    let platform3 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform3, at: Coordinate(column: 2, row: 5))
    let platform4 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform4, at: Coordinate(column: 4, row: 5))
}
