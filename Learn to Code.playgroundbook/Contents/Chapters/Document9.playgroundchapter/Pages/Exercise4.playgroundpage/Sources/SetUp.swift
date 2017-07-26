// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 5, rows: 9)
let world = loadGridWorld(named: "9.6")
let actor = Actor()
var gemRandomizer: RandomizedQueueObserver?
public var numberOfSwitches = 0

public func playgroundPrologue() {
    //    placeBlocks()
    placeWalls()
    placeRandomPlaceholders()
    
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomSwitches()
        realizeRandomGems()
    }
    //// ----
    world.successCriteria = GridWorldSuccessCriteria(gems: numberOfSwitches, switches: numberOfSwitches)
    
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

// MARK: Placement

func placeRandomPlaceholders() {
    let dzCoords = [
        Coordinate(column: 1, row: 6),
        Coordinate(column: 1, row: 7),
        Coordinate(column: 1, row: 8),
        Coordinate(column: 2, row: 6),
        Coordinate(column: 2, row: 7),
        Coordinate(column: 2, row: 8),
        Coordinate(column: 3, row: 6),
        Coordinate(column: 3, row: 7),
        Coordinate(column: 3, row: 8),
        
        ]
    let s = Switch()
    for coord in dzCoords {
        world.place(RandomNode(resembling: s), at: coord)
    }
    let g = Gem()
    var itemCoordinates = world.coordinates(inColumns: [1,2,3], intersectingRows: [0,1,2])
    if let cord = itemCoordinates.index(of: Coordinate(column: 2, row: 1)) {
        itemCoordinates.remove(at: cord)
    }
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: g), at: coord)
    }
}

func placeWalls() {
    world.place(Wall(edges: [.bottom, .top]), at: Coordinate(column: 2, row: 4))
    world.place(Wall(edges: [.bottom, .top, .left, .right]), at: Coordinate(column: 2, row: 1))
}

func placeBlocks() {
    world.removeNodes(at: world.coordinates(inColumns: [0, 1, 3, 4], intersectingRows: [3, 4, 5]))
    world.placeWater(at: world.coordinates(inColumns: [0, 1, 3, 4], intersectingRows: [3, 4, 5]))
    
    let tiers = [
        Coordinate(column: 0, row: 8),
        Coordinate(column: 0, row: 7),
        Coordinate(column: 0, row: 6),
        Coordinate(column: 0, row: 8),
        Coordinate(column: 4, row: 8),
        Coordinate(column: 4, row: 7),
        Coordinate(column: 4, row: 6),
        Coordinate(column: 4, row: 8),
        
        Coordinate(column: 0, row: 2),
        Coordinate(column: 0, row: 1),
        Coordinate(column: 0, row: 0),
        Coordinate(column: 4, row: 0),
        Coordinate(column: 4, row: 2),
        Coordinate(column: 4, row: 1),
        
        Coordinate(column: 2, row: 4),
        ]
    world.placeBlocks(at: tiers)
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 5))
    world.place(Stair(), facing: south, at: Coordinate(column: 2, row: 3))
}

func realizeRandomSwitches() {
    let dzCoords = [
        Coordinate(column: 1, row: 6),
        Coordinate(column: 1, row: 7),
        Coordinate(column: 1, row: 8),
        Coordinate(column: 2, row: 6),
        Coordinate(column: 2, row: 7),
        Coordinate(column: 2, row: 8),
        Coordinate(column: 3, row: 6),
        Coordinate(column: 3, row: 7),
        Coordinate(column: 3, row: 8),
        
        ]
    for coor in dzCoords {
        if arc4random_uniform(6) % 2 == 0 {
            let switchNodes = world.place(nodeOfType: Switch.self, at: [coor])
            numberOfSwitches += 1
            
            for switchNode in switchNodes {
                switchNode.isOn = true
            }
        }
    }
}
func realizeRandomGems() {
    let coordinates = world.coordinates(inColumns: [1,3], intersectingRows: [0,1,2])
    for coordinate in coordinates {
        let random = Int(arc4random_uniform(8))
        if random % 2 == 0 {
            world.place(Gem(), at: coordinate)
        }
    }
}

func placeGemsOverTime() {
    let randomGemCoords = [
        Coordinate(column: 1, row: 0),
        Coordinate(column: 1, row: 1),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 3, row: 0),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 2, row: 2),
        Coordinate(column: 2, row: 1),
        
        
        ]
    gemRandomizer = RandomizedQueueObserver(randomRange: 0...5, world: world) { world in
        let existingGemCount = world.existingGems(at: randomGemCoords).count
        guard existingGemCount < 5 else { return }
        
        for coordinate in Set(randomGemCoords) {
            if world.existingGems(at: [coordinate]).isEmpty {
                world.place(Gem(), at: coordinate)
                
                // Only place one gem.
                return
            }
        }
    }
}
