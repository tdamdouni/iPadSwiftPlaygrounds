// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 7, rows: 5)
let world = loadGridWorld(named: "9.7")
let actor = Actor()
public var numberOfGems = 0


public func playgroundPrologue() {
    
//    placeBlocks()
    placeRandomPlaceholderGems()
    placeSwitches()
    placePortals()
    
    world.place(actor, facing: north, at: Coordinate(column: 0, row: 0))


    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomGems()
    }
    //// ----
    world.successCriteria = GridWorldSuccessCriteria(gems: numberOfGems, switches: numberOfGems)

}

public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}


func placeRandomPlaceholderGems() {
    let itemCoords = [
                         Coordinate(column: 0, row: 4),
                         Coordinate(column: 0, row: 3),
                         Coordinate(column: 0, row: 2),
                         Coordinate(column: 1, row: 4),
                         Coordinate(column: 2, row: 4),
                         Coordinate(column: 2, row: 3),
                         Coordinate(column: 2, row: 2),
                         
                         ]
    let gem = Gem()
    for coord in itemCoords {
        world.place(RandomNode(resembling:gem), at: coord)
    }
}

func placePortals() {
    world.place(Portal(color: .green), between: Coordinate(column: 1, row: 2), and: Coordinate(column: 5, row: 2))
}

func realizeRandomGems() {
    let itemCoords = [
                         Coordinate(column: 0, row: 4),
                         Coordinate(column: 0, row: 3),
                         Coordinate(column: 0, row: 2),
                         Coordinate(column: 1, row: 4),
                         Coordinate(column: 2, row: 4),
                         Coordinate(column: 2, row: 3),
                         Coordinate(column: 2, row: 2),
                         
                         ]
    for coor in itemCoords {
        if arc4random_uniform(6) % 2 == 0 {
            world.placeGems(at: [coor])
            numberOfGems += 1
        }
    }
}

func placeSwitches() {
    let dzCoords = [
                       Coordinate(column: 4, row: 4),
                       Coordinate(column: 4, row: 3),
                       Coordinate(column: 4, row: 2),
                       Coordinate(column: 5, row: 4),
                       Coordinate(column: 6, row: 4),
                       Coordinate(column: 6, row: 3),
                       Coordinate(column: 6, row: 2),
                       
                       ]
    world.place(nodeOfType: Switch.self, at: dzCoords)
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 5, row: 3),
                        Coordinate(column: 3, row: 4),
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 3, row: 1),
                        Coordinate(column: 2, row: 1),
                        Coordinate(column: 4, row: 1),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,2,4,6], intersectingRows: [2,3,4]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,5], intersectingRows: [2,4]))
    
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 1))
    world.place(Stair(), facing: south, at: Coordinate(column: 6, row: 1))
}
