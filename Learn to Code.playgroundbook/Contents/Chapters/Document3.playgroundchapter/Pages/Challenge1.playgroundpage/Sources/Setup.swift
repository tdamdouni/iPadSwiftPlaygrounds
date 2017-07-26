// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "3.3")
let actor = Actor()

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
    world.place(actor, facing: north, at: Coordinate(column: 3, row: 3))
}

func placeItems() {
    let items = [
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 5, row: 3),
                    
                    Coordinate(column: 3, row: 1),
                    Coordinate(column: 3, row: 5),
                    
                    
                    ]
    world.place(nodeOfType: Switch.self, at: items)
    
    
    let switches = [
                       Coordinate(column: 5, row: 5),
                       Coordinate(column: 1, row: 1),
                       Coordinate(column: 5, row: 1),
                       Coordinate(column: 1, row: 5),
                       
                       ]
    
    let switchNodes = world.place(nodeOfType: Switch.self, at: switches)
    
    for switchNode in switchNodes {
        
        switchNode.isOn = true
        
    }
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 4, row: 0),
                        Coordinate(column: 5, row: 0),
                        Coordinate(column: 6, row: 0),
                        
                        Coordinate(column: 0, row: 6),
                        Coordinate(column: 1, row: 6),
                        Coordinate(column: 2, row: 6),
                        Coordinate(column: 3, row: 6),
                        Coordinate(column: 4, row: 6),
                        Coordinate(column: 5, row: 6),
                        Coordinate(column: 6, row: 6),
                        
                        Coordinate(column: 0, row: 1),
                        Coordinate(column: 0, row: 2),
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 0, row: 4),
                        Coordinate(column: 0, row: 5),
                        
                        Coordinate(column: 6, row: 1),
                        Coordinate(column: 6, row: 2),
                        Coordinate(column: 6, row: 3),
                        Coordinate(column: 6, row: 4),
                        Coordinate(column: 6, row: 5),
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 3, row: 3),
                    
                    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 3))
    world.place(Stair(), facing: east, at: Coordinate(column: 4, row: 3))
    world.place(Stair(), facing: south, at: Coordinate(column: 3, row: 2))
    world.place(Stair(), facing: north, at: Coordinate(column: 3, row: 4))
}
