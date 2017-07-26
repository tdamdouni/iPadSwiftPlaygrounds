// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 8, rows: 7)
public let world = loadGridWorld(named: "12.4")
var gemRandomizer: RandomizedQueueObserver?
public let randomNumberOfGems = Int(arc4random_uniform(12)) + 1
public var gemsPlaced = 0

let gemCoords = [
    Coordinate(column: 3, row: 0),
    Coordinate(column: 3, row: 2),
    Coordinate(column: 3, row: 3),
    Coordinate(column: 3, row: 5),
    
    Coordinate(column: 5, row: 4),
    Coordinate(column: 5, row: 2),
    Coordinate(column: 5, row: 1),
    
    Coordinate(column: 4, row: 0),
    Coordinate(column: 4, row: 6),
]

public func playgroundPrologue() {
    Display.coordinateMarkers = true


    placeRandomItems(gemCoords: gemCoords)
    placeLocks()
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomGems(gemCoords: gemCoords)
    }
    //// ----
    
    placeGemsOverTime()
}

public func presentWorld() {
    setUpLiveViewWith(world)
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

// MARK: Placement

func placeLocks() {
    let lock = PlatformLock(color: .blue)
    world.place(lock, facing: south, at: Coordinate(column: 1, row: 5))
    
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 4, row: 0))
    
    let platform2 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 4, row: 1))
    let platform3 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform3, at: Coordinate(column: 4, row: 2))
    let platform4 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform4, at: Coordinate(column: 4, row: 3))
    let platform5 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform5, at: Coordinate(column: 4, row: 4))
    let platform6 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform6, at: Coordinate(column: 4, row: 5))
    let platform7 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform7, at: Coordinate(column: 4, row: 6))
}

func placeRandomItems(gemCoords: [Coordinate]) {
    let gem = Gem()
    for coordinate in gemCoords {
        world.place(RandomNode(resembling: gem), at: coordinate)
    }
}

func realizeRandomGems(gemCoords: [Coordinate]) {
    
    for coordinate in gemCoords where gemsPlaced < randomNumberOfGems {
        let random = Int(arc4random_uniform(5))
        if random % 2 == 0 {
            world.place(Gem(), at: coordinate)
            gemsPlaced += 1
        }
    }
}

func placeGemsOverTime() {

    gemRandomizer = RandomizedQueueObserver(randomRange: 0...5, world: world) { world in
        let existingGemCount = world.existingGems(at: gemCoords).count
        guard existingGemCount < 3 && gemsPlaced < randomNumberOfGems else { return }
        
        for coordinate in Set(gemCoords) {
            if world.existingGems(at: [coordinate]).isEmpty && world.existingCharacters(at: [coordinate]).isEmpty {
                world.place(Gem(), at: coordinate)
                gemsPlaced += 1
                return
                
            }
        }
    }
    
    
}

func addStaticElements() {
    let allCoordinates = world.allPossibleCoordinates
    world.removeItems(at: allCoordinates)
    
    world.placeWater(at: world.coordinates(inColumns: [2,4,6], intersectingRows: 2...6))
    world.placeWater(at: world.coordinates(inColumns: [2,4,6], intersectingRows: 0...1))
    world.placeWater(at: world.coordinates(inColumns: [1], intersectingRows: [2,6]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [3,5], intersectingRows: 0...6))
    world.placeBlocks(at: world.coordinates(inColumns: [5], intersectingRows: 0...6))
    
    let blocks = [
        Coordinate(column: 3, row: 5),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 3, row: 0),
        Coordinate(column: 3, row: 0),
        
        Coordinate(column: 5, row: 6),
        Coordinate(column: 5, row: 5),
        Coordinate(column: 5, row: 5),
        
        Coordinate(column: 5, row: 4)
    ]
    world.placeBlocks(at: blocks)
    
    world.removeItems(at: world.coordinates(inColumns: [5], intersectingRows: [0,2]))
    world.place(Block(), at: Coordinate(column: 5, row: 2))
    world.place(Block(), at: Coordinate(column: 5, row: 0))
    
    world.placeBlocks(at: world.coordinates(inColumns: [1], intersectingRows: 3...5))
}
