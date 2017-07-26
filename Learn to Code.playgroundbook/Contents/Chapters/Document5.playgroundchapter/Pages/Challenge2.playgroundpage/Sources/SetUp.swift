// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "5.6")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeRandomElements()
    placeActor()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        // Realize random elements after the world has been built.
        realizeRandomElements()
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


func placeActor() {
    world.place(actor, facing: north, at: Coordinate(column: 2, row: 2))
}

func placeRandomElements() {
    let itemCoordinates = [
        Coordinate(column: 1, row: 1),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 1, row: 3),
        Coordinate(column: 2, row: 3),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 2, row: 1),
    ]
    let gem = Gem()
    let switchElement = Switch()
    
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coord)
        world.place(RandomNode(resembling: switchElement), at: coord)
    }
}

func realizeRandomElements() {
    let itemCoordinates = [
        Coordinate(column: 1, row: 1),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 1, row: 3),
        Coordinate(column: 2, row: 3),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 3, row: 1),
        Coordinate(column: 2, row: 1),
        
    ]
    for coor in itemCoordinates {
        if arc4random_uniform(6) % 2 == 0 {
            world.placeGems(at: [coor])
        } else {
            let switchNodes = world.place(nodeOfType: Switch.self, at: [coor])
            
            for switchNode in switchNodes {
                if arc4random_uniform(6) % 2 == 0 {
                    switchNode.isOn = true
                } else {
                    switchNode.isOn = false
                }
            }
        }
    }
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 4, row: 0),
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 0, row: 1),
                        Coordinate(column: 4, row: 1)
        
    ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 4, row: 4),
                    
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 4, row: 4),
                    
                    
                    Coordinate(column: 0, row: 3),
                    Coordinate(column: 0, row: 3),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 4, row: 3),
                    
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 4, row: 2),
                    
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 3, row: 1)
    ]
    world.placeBlocks(at: tiers)
}
