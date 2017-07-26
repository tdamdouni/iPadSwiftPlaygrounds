// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "7.6")
let actor = Actor()



public func playgroundPrologue() {
    
    // zero we add zero blocks
    let numberOfBlocksToAdd = Int(arc4random_uniform(3)) // 0, 1 or 2
    
    placeActor()
    placeItems()
    placeRandomBlocks()
    placeRandomItems()
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomBlocks(randomNumber: numberOfBlocksToAdd)
        realizeRandomItems(randomNumber: numberOfBlocksToAdd)
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

func placeRandomItems() {
    let switchItem = Switch()
    let gem = Gem()
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 1, row: 5))
    world.place(RandomNode(resembling: gem), at: Coordinate(column: 2, row: 5))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 3, row: 5))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 1, row: 6))
    world.place(RandomNode(resembling: gem), at: Coordinate(column: 2, row: 6))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 3, row: 6))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 3, row: 4))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 3, row: 3))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 3, row: 2))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 1, row: 4))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 1, row: 3))
    world.place(RandomNode(resembling: switchItem), at: Coordinate(column: 1, row: 2))
}

func realizeRandomItems(randomNumber: Int) {
    // if random number is 2 we place nothing
    // if randomNumber is 1 we place stuff
    // if randomNumber is 0 we place 2 thing
    var switchCoords = [Coordinate]()
    var gemCoords = [Coordinate]()
    
    if randomNumber < 2 {
        switchCoords.append(Coordinate(column: 3, row: 5))
        switchCoords.append(Coordinate(column: 1, row: 5))
        gemCoords.append(Coordinate(column: 2, row: 5))
    }
    if randomNumber < 1 {
        switchCoords.append(Coordinate(column: 3, row: 6))
        switchCoords.append(Coordinate(column: 1, row: 6))
        gemCoords.append(Coordinate(column: 2, row: 6))
    }
    
    let switches = world.place(nodeOfType: Switch.self, at: world.coordinates(inColumns: [1,3], intersectingRows: [2,3,4]))
    for eachSwitch in switches {
        if arc4random_uniform(6) % 2 == 0 {
            eachSwitch.isOn = true
        } else {
            eachSwitch.isOn = false
        }
    }
    
    world.place(nodeOfType: Gem.self, at: gemCoords)
    let switchNodes = world.place(nodeOfType: Switch.self, at: switchCoords)
    for switchNode in switchNodes {
        if arc4random_uniform(6) % 2 == 0 {
            switchNode.isOn = true
        } else {
            switchNode.isOn = false
        }
    }
    

}

func placeItems() {
    world.placeGems(at: world.coordinates(inColumns: [2], intersectingRows: [2,3,4]))
}



func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 1))
}

func placeRandomBlocks() {
    let columns = [1,2,3]
    let rows = [7, 6] // reversing these makes the below eaiser
    let block = Block()
    
    for i in columns {
        for j in rows {
            world.place(RandomNode(resembling: block), at: Coordinate(column: i, row: j))
        }
    }
}

func realizeRandomBlocks(randomNumber: Int) {
    let columns = [1,2,3]
    let rows = [7, 6] // reversing these makes the below eaiser
    for i in columns {
        for j in 0..<randomNumber {
            world.place(Block(), at: Coordinate(column: i, row: rows[j]))
        }
    }
}

func oldBuild() {
    let randomNumber = Int(arc4random_uniform(3) + 1)
    
    let tiers = [
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 1, row: 5),
                    
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 2, row: 5),
                    
                    Coordinate(column: 3, row: 1),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 3, row: 5),
                    
                    ]
    world.placeBlocks(at: tiers)
    
    let randomCoordinates = (1...randomNumber).flatMap {
        world.coordinates(inColumns: 1...3, intersectingRows: [5 + $0])
    }
    world.placeBlocks(at: randomCoordinates)
    
    for coordinate in randomCoordinates {
        if coordinate.column % 2 == 0 {
            world.place(Gem(), at: coordinate)
        } else {
            let switchNodes = world.place(nodeOfType: Switch.self, at: [coordinate])
            for switchNode in switchNodes {
                if arc4random_uniform(6) % 2 == 0 {
                    switchNode.isOn = true
                } else {
                    switchNode.isOn = false
                }
            }
        }
    }
    
    world.removeNodes(at: world.coordinates(inColumns: 1...3, intersectingRows: [5 + randomNumber]))
    world.placeBlocks(at: world.coordinates(inColumns: 1...3, intersectingRows: [5 + randomNumber]))
    world.placeBlocks(at: world.coordinates(inColumns: 1...3, intersectingRows: [5 + randomNumber]))
    
    
    
    var allObstacles = Set(world.allPossibleCoordinates)
    allObstacles.subtract(tiers)
    allObstacles.subtract(randomCoordinates)
    
    
    world.removeNodes(at: Array(allObstacles))
    world.placeWater(at: Array(allObstacles))
    
    let items = [
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 2, row: 5),
                    
                    ]
    world.placeGems(at: items)
    
    let switches = [
                       Coordinate(column: 1, row: 2),
                       Coordinate(column: 1, row: 3),
                       Coordinate(column: 1, row: 4),
                       Coordinate(column: 1, row: 5),
                       
                       Coordinate(column: 3, row: 2),
                       Coordinate(column: 3, row: 3),
                       Coordinate(column: 3, row: 4),
                       Coordinate(column: 3, row: 5),
                       
                       ]
    let switchNodes = world.place(nodeOfType: Switch.self, at: switches)
    for switchNode in switchNodes {
        if arc4random_uniform(6) % 2 == 0 {
            switchNode.isOn = true
        } else {
            switchNode.isOn = false
        }
    }
}
