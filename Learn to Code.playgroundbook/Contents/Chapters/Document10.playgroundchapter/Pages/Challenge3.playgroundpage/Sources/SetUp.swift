// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//public let world = GridWorld(columns: 5, rows: 7)
public let world = loadGridWorld(named: "10.5")
let actor = Actor()
var gemRandomizer: RandomizedQueueObserver?
public let randomNumberOfGems = Int(arc4random_uniform(8)) + 1
public var pinkPortal = Portal(color: .pink)
public var bluePortal = Portal(color: .blue)
public var gemsPlaced = 0

let gemCoords = [
    Coordinate(column: 0, row: 1),
    Coordinate(column: 0, row: 2),
    Coordinate(column: 0, row: 4),
    Coordinate(column: 0, row: 5),
    
    Coordinate(column: 4, row: 1),
    Coordinate(column: 4, row: 2),
    Coordinate(column: 4, row: 4),
    Coordinate(column: 4, row: 5),
    
    Coordinate(column: 2, row: 1),
    Coordinate(column: 2, row: 3),
    Coordinate(column: 2, row: 5),
    
]

public func playgroundPrologue() {
    
    placeRandomPlaceholders()
    placeActor()
    placePortals()
    
//    placeBlocks()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomGems()
    }
    //// ----

    placeGemsOverTime()
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeActor() {
    world.place(actor, facing: south, at: Coordinate(column: 2, row: 3))
}

func placePortals() {
    world.place(pinkPortal, between: Coordinate(column: 0, row: 3), and: Coordinate(column: 2, row: 2))
    world.place(bluePortal, between: Coordinate(column: 4, row: 3), and: Coordinate(column: 2, row: 4))
}

func placeBlocks() {
    let topBottomRows = world.coordinates(inRows:[6,0])
    world.removeNodes(at: topBottomRows)
    world.placeWater(at: topBottomRows)
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,4], intersectingRows: 1...5))
    
    let obstacles = [
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 1, row: 2),
                        
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 3, row: 4),
                        Coordinate(column: 3, row: 2),
                        
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
}

func placeRandomPlaceholders() {
    let gem = Gem()
    for coordinate in gemCoords {
        world.place(RandomNode(resembling: gem), at: coordinate)
    }
}

func realizeRandomGems() {
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
        guard existingGemCount < 5 && gemsPlaced < randomNumberOfGems else { return }
        

        for coordinate in Set(gemCoords) {
            if world.existingGems(at: [coordinate]).isEmpty {
                world.place(Gem(), at: coordinate)
                gemsPlaced += 1
                
                return
                
            }
        }
    }
    
    
}
