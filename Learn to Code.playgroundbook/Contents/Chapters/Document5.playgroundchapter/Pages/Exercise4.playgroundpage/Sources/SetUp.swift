// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "5.5")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeRandomElements()
    placeActor()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
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


func placeRandomElements() {
    let itemCoordinates = [
        Coordinate(column: 3, row: 0),
        Coordinate(column: 5, row: 0),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 5, row: 3),
                              ]
    let gem = Gem()
    let switchItem = Switch()
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coord)
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
}

func realizeRandomElements() {
    let itemCoordinates = [
        Coordinate(column: 3, row: 0),
        Coordinate(column: 5, row: 0),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 5, row: 3),
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

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 0))
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 0, row: 1),
                        Coordinate(column: 0, row: 2),
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 1, row: 1),
                        Coordinate(column: 2, row: 1),
                        Coordinate(column: 3, row: 1),
                        Coordinate(column: 4, row: 1)
    ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 6, row: 0),
                    
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 5, row: 0),
                    
                    Coordinate(column: 6, row: 0),
                    Coordinate(column: 6, row: 0),
                    
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 5, row: 3),
                    Coordinate(column: 5, row: 3),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 6, row: 1),
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 6, row: 1),
                    
                    Coordinate(column: 5, row: 2),
                    Coordinate(column: 5, row: 1)
    ]
    world.placeBlocks(at: tiers)
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 0))
    world.place(Stair(), facing: north, at: Coordinate(column: 5, row: 1))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 2))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 3))
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 3))
}

