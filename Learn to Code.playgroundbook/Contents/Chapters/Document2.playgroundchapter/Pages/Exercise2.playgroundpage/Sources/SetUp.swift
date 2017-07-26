// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

//let world = GridWorld(columns: 5, rows: 7)
let world: GridWorld = loadGridWorld(named: "2.2")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 2))
    
    placeItems()
    placePortals()
    

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

func placeItems() {
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 1, row: 5)])
    
    let switches = [
                       Coordinate(column: 0, row: 1),
                       Coordinate(column: 4, row: 3)
    ]
    let switchNodes = world.place(nodeOfType: Switch.self, at: switches)
    
    for switchNode in switchNodes {
        switchNode.isOn = true
    }
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 3, row: 2), and: Coordinate(column: 3, row: 6))
}

func placeFloor() {
    let obstacles = [
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 1, row: 1),
                        
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 2, row: 5),
                        Coordinate(column: 3, row: 5),
                        
                        
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 3, row: 1),
                        Coordinate(column: 4, row: 1),
                        
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 4, row: 0),
                        
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    
    let tiers = [
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 2, row: 2),
                    
                    
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 4, row: 6),
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 4, row: 6),
                    Coordinate(column: 4, row: 6),
                    
                    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing:  south, at: Coordinate(column: 0, row: 3))
    world.place(Stair(), facing: north, at: Coordinate(column: 0, row: 5))
    world.place(Stair(), facing:  south, at: Coordinate(column: 2, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 3))
}
