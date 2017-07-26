// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "5.7")
public let actor = Actor()



public func playgroundPrologue() {
    
    placeItems()
    placeActor()
    

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
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
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))
}

func placeItems() {
    let itemCoordinates = [
                              Coordinate(column: 0, row: 5),
                              Coordinate(column: 0, row: 2),
                              Coordinate(column: 1, row: 4),
                              Coordinate(column: 1, row: 1),
                              Coordinate(column: 4, row: 5),
                              Coordinate(column: 4, row: 2)
    ]
    world.placeGems(at: itemCoordinates)
    
    let dz = [
                 Coordinate(column: 1, row: 5),
                 Coordinate(column: 1, row: 2)
    ]    
    let switchNodes = world.place(nodeOfType: Switch.self, at: dz)
    
    for switchNode in switchNodes {
        switchNode.isOn = false
    }
    
    let switchNode = Switch()
    world.place(switchNode, at: Coordinate(column: 1, row: 3))
    switchNode.isOn = true
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 0, row: 1),
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 0, row: 4),
                        Coordinate(column: 0, row: 6),
                        
                        Coordinate(column: 5, row: 0),
                        Coordinate(column: 5, row: 1),
                        Coordinate(column: 5, row: 2),
                        Coordinate(column: 5, row: 3),
                        Coordinate(column: 5, row: 4),
                        Coordinate(column: 5, row: 5),
                        Coordinate(column: 5, row: 6),
                        
                        Coordinate(column: 4, row: 3),
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 2, row: 3),
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 2, row: 2)
    ]
    world.removeItems(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 1, row: 6),
                    
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 0, row: 5),
                    
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 4, row: 0),
                    
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 4, row: 6),
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 4, row: 6),
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 3, row: 5),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 3, row: 5)
    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing: east, at: Coordinate(column: 2, row: 1))
    world.place(Stair(), facing: east, at: Coordinate(column: 2, row: 4))
}
