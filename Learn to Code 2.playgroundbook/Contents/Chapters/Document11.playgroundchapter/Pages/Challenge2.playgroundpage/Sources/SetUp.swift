// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 7)
public let world = loadGridWorld(named: "12.3")

public func playgroundPrologue() {
    let row4 = world.coordinates(inColumns: [0,1,2,3,4,5,6], intersectingRows: [4])
    
//    addStaticElements()
    addGameNodes()
    Display.coordinateMarkers = true
    placeRandomItems(itemCoordinates: row4)

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomGems(itemCoordinates: row4)
    }
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
    world.removeItems(at: world.allPossibleCoordinates)
    world.placeWater(at: world.allPossibleCoordinates)
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,1], intersectingRows: [0,4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [0,1], intersectingRows: [0,4]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [0]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3,6,7], intersectingRows: [2]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,2,3,6,7], intersectingRows: [2]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [4,5,6,7], intersectingRows: [4,5,6]))
    world.placeBlocks(at: world.coordinates(inColumns: [4], intersectingRows: [4]))
    world.placeBlocks(at: world.coordinates(inColumns: [5], intersectingRows: [5]))
    world.placeBlocks(at: world.coordinates(inColumns: [7], intersectingRows: [2,3,5]))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [6]))
    world.placeBlocks(at: world.coordinates(inColumns: [5,6,7], intersectingRows: [6]))
    
    
    world.place(nodeOfType: Stair.self, facing: east, at: world.coordinates(inColumns: [5], intersectingRows: [4]))
    world.place(nodeOfType: Stair.self, facing: north, at: world.coordinates(inColumns: [4], intersectingRows: [5]))
    
    world.place(nodeOfType: Stair.self, facing: north, at: world.coordinates(inColumns: [0], intersectingRows: [5]))
    
    world.place(nodeOfType: Stair.self, facing:  south, at: world.coordinates(inColumns: [6], intersectingRows: [5]))
    
}

func placeRandomItems(itemCoordinates: [Coordinate]) {
    let gem = Gem()
    for coor in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coor)
    }
}

func realizeRandomGems(itemCoordinates: [Coordinate]) {
    for coor in itemCoordinates {
        if randomBool() {
            world.place(Gem(), at: coor)
        }
    }
}

func addGameNodes() {
    world.placeGems(at: world.coordinates(inColumns: [0], intersectingRows: [0]))
    let lock = PlatformLock(color: .yellow)
    world.place(lock, facing: south, at: Coordinate(column: 0, row: 5))
    let platform1 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 2, row: 0))
    let platform2 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 3, row: 1))
    let platform3 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform3, at: Coordinate(column: 3, row: 0))
    let platform4 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform4, at: Coordinate(column: 4, row: 0))
    
    let lock2 = PlatformLock(color: .pink)
    world.place(lock2, facing: south, at: Coordinate(column: 3, row: 1))
    let platform5 = Platform(onLevel: 1, controlledBy: lock2)
    world.place(platform5, at: Coordinate(column: 2, row: 4))
    
    let lock3 = PlatformLock(color: .blue)
    world.place(lock3, facing: west, at: Coordinate(column: 7, row: 0))
    let platform6 = Platform(onLevel: 5, controlledBy: lock3)
    world.place(platform6, at: Coordinate(column: 3, row: 4))
}

