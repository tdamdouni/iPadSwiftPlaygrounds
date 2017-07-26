// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation
import GameplayKit

//let world = GridWorld(columns: 7, rows: 5)
let world = loadGridWorld(named: "9.7")
let actor = Actor()
public var numberOfGems = 0

public func playgroundPrologue() {
//    placeBlocks()
    placeSwitches()
    placePortals()
    
    world.place(actor, facing: north, at: Coordinate(column: 0, row: 0))
    
    let gemCoords = [
        Coordinate(column: 0, row: 4),
        Coordinate(column: 0, row: 3),
        Coordinate(column: 0, row: 2),
        Coordinate(column: 1, row: 4),
        Coordinate(column: 2, row: 4),
        Coordinate(column: 2, row: 3),
        Coordinate(column: 2, row: 2),
    ]
    placeRandomPlaceholderGems(at: gemCoords)
    
    numberOfGems = randomInt(from: 1, to: gemCoords.count)

    // Match the number of switches with the `numberOfGems`.
    world.successCriteria = .count(collectedGems: numberOfGems, openSwitches: numberOfGems)
    registerAssessment(world, assessment: assessmentPoint)
    
    let randomSource = GKRandomSource.sharedRandom()
    let shuffledCoordinates = randomSource.arrayByShufflingObjects(in: gemCoords) as! [Coordinate]
    let randomPlacements = shuffledCoordinates.prefix(upTo: numberOfGems)
    
    finalizeWorldBuilding(for: world) {
        world.placeGems(at: Array(randomPlacements))
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


func placeRandomPlaceholderGems(at coordinates: [Coordinate]) {
    let gem = Gem()
    for coord in coordinates {
        world.place(RandomNode(resembling: gem), at: coord)
    }
}

func placePortals() {
    world.place(Portal(color: .green), between: Coordinate(column: 1, row: 2), and: Coordinate(column: 5, row: 2))
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
    world.removeItems(at: obstacles)
    world.placeWater(at: obstacles)
    
    
    world.placeBlocks(at: world.coordinates(inColumns: [0,2,4,6], intersectingRows: [2,3,4]))
    world.placeBlocks(at: world.coordinates(inColumns: [1,5], intersectingRows: [2,4]))
    
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 1))
    world.place(Stair(), facing: south, at: Coordinate(column: 6, row: 1))
}
