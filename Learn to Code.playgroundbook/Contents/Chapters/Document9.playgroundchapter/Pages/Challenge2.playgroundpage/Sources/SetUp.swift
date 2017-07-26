// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "9.5")
let actor = Actor()

public func playgroundPrologue() {
    world.successCriteria = GridWorldSuccessCriteria(gems: 3, switches: 4)

    
    placeActor()
    placePortals()
    
    let dzCoords = [
        Coordinate(column: 1, row: 4),
        Coordinate(column: 0, row: 4),
        Coordinate(column: 0, row: 5),
        Coordinate(column: 0, row: 6),
        Coordinate(column: 0, row: 7),
        Coordinate(column: 1, row: 7),
        Coordinate(column: 2, row: 7),
        Coordinate(column: 3, row: 7),
        Coordinate(column: 4, row: 7),
        Coordinate(column: 5, row: 7),
        
        ]
    let itemCoords = [
        Coordinate(column: 2, row: 1),
        Coordinate(column: 2, row: 2),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 4, row: 2),
        Coordinate(column: 4, row: 3),
        Coordinate(column: 4, row: 4),
        Coordinate(column: 4, row: 5),
        Coordinate(column: 5, row: 5),
        Coordinate(column: 6, row: 5),
        Coordinate(column: 7, row: 5),
        Coordinate(column: 7, row: 4),
        Coordinate(column: 7, row: 3),
        Coordinate(column: 7, row: 2),
        Coordinate(column: 7, row: 1),
        
        ]
    
    placeRandomItems(dzCoords, itemCoords: itemCoords)

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems(dzCoords: dzCoords, itemCoords: itemCoords)
    }
    //// ----
}


// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}



func placeRandomItems(_ dzCoords: [Coordinate], itemCoords: [Coordinate]) {
    let switchItem = Switch()
    for coord in dzCoords {
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
    let gem = Gem()
    for coord in itemCoords {
        world.place(RandomNode(resembling: gem), at: coord)
    }
}

func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 2, row: 0))
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 6, row: 1), and: Coordinate(column: 2, row: 4))
}

func realizeRandomItems(dzCoords: [Coordinate], itemCoords: [Coordinate]) {
    for coor in dzCoords {
        if arc4random_uniform(6) % 2 == 0 || arc4random_uniform(10) % 3 == 0 {
            world.place(nodeOfType: Switch.self, at: [coor])
        }
    }
    for coor in itemCoords {
        if arc4random_uniform(6) % 2 == 0 || arc4random_uniform(10) % 3 == 0 {
            world.placeGems(at: [coor])
        }
    }
}

func placeBlocks() {
    let tiers = [
                    
                    Coordinate(column: 0, row: 7),
                    Coordinate(column: 0, row: 6),
                    Coordinate(column: 0, row: 5),
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 1, row: 7),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 2, row: 7),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 7),
                    Coordinate(column: 4, row: 7),
                    Coordinate(column: 5, row: 7),
                    
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 6, row: 5),
                    Coordinate(column: 7, row: 5),
                    Coordinate(column: 7, row: 4),
                    Coordinate(column: 7, row: 3),
                    Coordinate(column: 7, row: 2),
                    Coordinate(column: 7, row: 1),
                    Coordinate(column: 6, row: 1),
                    
                    ]
    
    let allPossibleCoordinates = Set(world.allPossibleCoordinates)
    let water = allPossibleCoordinates.subtracting(Set(tiers))
    
    world.removeNodes(at: Array(water))
    world.placeWater(at: Array(water))
    
    world.placeBlocks(at: tiers)
}
