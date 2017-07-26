// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

//: Use this to test world configurations that would normally be done in `SetUp.swift`.

import Foundation

// MARK: Globals
let world = loadGridWorld(named: "6.2")
public let actor = Actor()

public func playgroundPrologue() {
    
    let randomCoords = generateRandomCoordinates()
    world.placeBlocks(at: [Coordinate(column: 1, row: 1)])

    placeRandomElements()
    
    placeActor()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomBlocks(at: randomCoords)
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

func placeRandomElements() {
    let block = Block()
    for coordinate in world.coordinates(inColumns: 2...7, intersectingRows: 1...6) {
        world.place(RandomNode(resembling: block) , at: coordinate)
    
    }
    
    
}


func generateRandomCoordinates() -> [Coordinate] {
    let platformArray = [
                            [6,4,3,2],
                            [5,5,3,2],
                            [4,5,4,2],
                            [4,5,3,3],
                            [5,4,4,2],
                            ]

    let randomPlatformPositions = platformArray.randomElement!
    var randomCoordinates = [Coordinate]()
    
    // - - - - -
    randomCoordinates += (2..<(2 + randomPlatformPositions[0])).map {
        return Coordinate(column: $0, row: 1)
    }
    
    // |
    // |
    // |
    // -
    let turn1Column = randomCoordinates.last!.column
    randomCoordinates += (2..<(1 + randomPlatformPositions[1])).map {
        return Coordinate(column: turn1Column, row: $0)
    }
    
    // Modify column
    // - - - |
    let turn2Row = randomCoordinates.last!.row
    randomCoordinates += ((turn1Column - randomPlatformPositions[2] + 1)..<turn1Column).map {
        return Coordinate(column: $0, row: turn2Row)
    }.reversed()
    
    // Modify row
    // -
    // |
    // |
    let turn3Column = randomCoordinates.last!.column
    randomCoordinates += ((turn2Row - randomPlatformPositions[3] + 1)..<turn2Row).map {
        return Coordinate(column: turn3Column, row: $0)
    }.reversed()
    
    return randomCoordinates
}

func realizeRandomBlocks(at randomCoordinates: [Coordinate]){
    world.placeBlocks(at: randomCoordinates)
    world.place(nodeOfType: Switch.self, at: [randomCoordinates.last!])
}

func placeBlocks(placedCoordinates: [Coordinate]) {
    // Remove all other tiles.
    var obstacleCoordinates = Set(world.allPossibleCoordinates)
    obstacleCoordinates.subtract(Set(placedCoordinates))
    
    let zeroColumn = obstacleCoordinates.filter {
        $0.column == 0
    }
    obstacleCoordinates.subtract(zeroColumn)
    obstacleCoordinates.subtract([Coordinate(column: 1, row: 1)])
    
    let obstacleArray = Array(obstacleCoordinates)
    world.removeItems(at: obstacleArray)
    world.placeWater(at: obstacleArray)
    world.place(Stair(), facing: west, at: Coordinate(column: 1, row: 1))
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 1))
}


