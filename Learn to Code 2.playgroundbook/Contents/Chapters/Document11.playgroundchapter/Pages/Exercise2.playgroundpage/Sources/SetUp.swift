// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 7, rows: 4)
public let world = loadGridWorld(named: "12.6")


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
    let allCoordinates = world.allPossibleCoordinates
    world.removeItems(at: allCoordinates)
    
    world.placeWater(at: world.coordinates(inColumns: [0, 2], intersectingRows: 0...3))
    world.placeWater(at: world.coordinates(inColumns: [1,3,6], intersectingRows: [3]))
    world.place(Water(), at: Coordinate(column: 3, row: 0))
    world.placeWater(at: world.coordinates(inColumns: [4,5], intersectingRows: [1,2]))
    world.placeBlocks(at: world.coordinates(inColumns: [1], intersectingRows: 0...2))
    world.placeBlocks(at: world.coordinates(inColumns: [1], intersectingRows: 0...2))
    world.placeBlocks(at: world.coordinates(inColumns: [1], intersectingRows: 0...2))
    
    
    
    let blocks = [
                     Coordinate(column: 3, row: 1),
                     Coordinate(column: 3, row: 1),
                     Coordinate(column: 3, row: 1),
                     Coordinate(column: 3, row: 1),
                     
                     Coordinate(column: 3, row: 2),
                     Coordinate(column: 3, row: 2),
                     
                     Coordinate(column: 4, row: 0),
                     Coordinate(column: 4, row: 0),
                     
                     Coordinate(column: 5, row: 0),
                     Coordinate(column: 5, row: 0),
                     Coordinate(column: 5, row: 0),
                     Coordinate(column: 5, row: 0),
                     
                     Coordinate(column: 6, row: 1),
                     Coordinate(column: 6, row: 1),
                     Coordinate(column: 6, row: 1),
                     Coordinate(column: 6, row: 1),
                     Coordinate(column: 6, row: 1),
                     
                     Coordinate(column: 6, row: 2),
                     
                     
                     Coordinate(column: 5, row: 3),
                     Coordinate(column: 5, row: 3),
                     Coordinate(column: 5, row: 3),
                     Coordinate(column: 5, row: 3),
                     
                     Coordinate(column: 4, row: 3),

                     
                     ]
    world.placeBlocks(at: blocks)
}

func addGameNodes() {
    let gems = [
                   Coordinate(column: 4, row: 0),
                   
                   Coordinate(column: 5, row: 0),
                   
                   Coordinate(column: 4, row: 3),
                   
                   
    ]
    world.placeGems(at: gems)
    
    let lock = PlatformLock(color: .purple)
    world.place(lock, facing: north, at: Coordinate(column: 1, row: 0))
    let platform1 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 4, row: 2))
    let platform2 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 5, row: 2))
    
    let lock2 = PlatformLock(color: .yellow)
    world.place(lock2, facing: south, at: Coordinate(column: 1, row: 2))
    let platform3 = Platform(onLevel: 2, controlledBy: lock2)
    world.place(platform3, at: Coordinate(column: 4, row: 1))
    let platform4 = Platform(onLevel: 2, controlledBy: lock2)
    world.place(platform4, at: Coordinate(column: 5, row: 1))
}
