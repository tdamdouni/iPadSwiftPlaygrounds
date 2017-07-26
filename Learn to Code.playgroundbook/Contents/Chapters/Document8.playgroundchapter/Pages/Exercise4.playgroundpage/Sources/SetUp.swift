// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 10, rows: 9)
let world = loadGridWorld(named: "8.4")
public let actor = Actor()



public func playgroundPrologue() {
    
//    placeBlocks()
    placeItems()
    
    world.place(actor, facing: west, at: Coordinate(column: 8, row: 5))
    

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
    let items = [
                    Coordinate(column: 5, row: 0),
                    ]
    world.placeGems(at: items)
    
    let dzs = [
                  Coordinate(column: 0, row: 0),
                  Coordinate(column: 0, row: 3),
                  Coordinate(column: 2, row: 3),
                  Coordinate(column: 2, row: 7),
                  Coordinate(column: 6, row: 7),
                  Coordinate(column: 6, row: 5),
                  ]
    world.place(nodeOfType: Switch.self, at: dzs)
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 8),
                        Coordinate(column: 1, row: 8),
                        Coordinate(column: 2, row: 8),
                        Coordinate(column: 3, row: 8),
                        
                        Coordinate(column: 3, row: 6),
                        Coordinate(column: 3, row: 5),
                        Coordinate(column: 3, row: 4),
                        
                        Coordinate(column: 4, row: 4),
                        Coordinate(column: 5, row: 4),
                        
                        Coordinate(column: 5, row: 3),
                        Coordinate(column: 5, row: 2),
                        Coordinate(column: 5, row: 1),
                        
                        Coordinate(column: 6, row: 1),
                        Coordinate(column: 7, row: 1),
                        Coordinate(column: 8, row: 1),
                        
                        Coordinate(column: 8, row: 0),
                        Coordinate(column: 9, row: 0),
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 0, row: 7),
                    Coordinate(column: 1, row: 7),
                    Coordinate(column: 1, row: 7),
                    
                    Coordinate(column: 2, row: 7),
                    Coordinate(column: 3, row: 7),
                    Coordinate(column: 4, row: 7),
                    
                    Coordinate(column: 5, row: 8),
                    Coordinate(column: 6, row: 8),
                    Coordinate(column: 7, row: 8),
                    Coordinate(column: 5, row: 8),
                    Coordinate(column: 6, row: 8),
                    Coordinate(column: 7, row: 8),
                    Coordinate(column: 6, row: 8),
                    Coordinate(column: 7, row: 8),
                    
                    Coordinate(column: 6, row: 5),
                    Coordinate(column: 7, row: 5),
                    Coordinate(column: 8, row: 5),
                    Coordinate(column: 9, row: 5),
                    Coordinate(column: 9, row: 6),
                    Coordinate(column: 9, row: 7),
                    Coordinate(column: 9, row: 5),
                    Coordinate(column: 9, row: 6),
                    Coordinate(column: 9, row: 7),
                    
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 6, row: 0),
                    Coordinate(column: 7, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 6, row: 0),
                    Coordinate(column: 7, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 6, row: 0),
                    Coordinate(column: 7, row: 0),
                    
                    Coordinate(column: 0, row: 3),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 4, row: 3),
                    
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 4, row: 2),
                    
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 2, row: 6),
                    
                    Coordinate(column: 8, row: 2),
                    Coordinate(column: 8, row: 3),
                    Coordinate(column: 9, row: 2),
                    Coordinate(column: 9, row: 3),
                    Coordinate(column: 9, row: 3)
    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing: west, at: Coordinate(column: 2, row: 0))
    world.place(Stair(), facing: west, at: Coordinate(column: 3, row: 0))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 0))
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 1))
    world.place(Stair(), facing: west, at: Coordinate(column: 1, row: 3))
    world.place(Stair(), facing: east, at: Coordinate(column: 3, row: 2))
    world.place(Stair(), facing: east, at: Coordinate(column: 3, row: 3))
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 6))
    world.place(Stair(), facing: north, at: Coordinate(column: 2, row: 6))
    world.place(Stair(), facing: east, at: Coordinate(column: 5, row: 7))
    world.place(Stair(), facing: south, at: Coordinate(column: 6, row: 4))
    world.place(Stair(), facing: west, at: Coordinate(column: 5, row: 5))
    world.place(Stair(), facing: north, at: Coordinate(column: 6, row: 6))
    world.place(Stair(), facing: west, at: Coordinate(column: 7, row: 3))
}
