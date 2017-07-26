// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 9, rows: 8)
let world = loadGridWorld(named: "8.3")
public let actor = Actor()



public func playgroundPrologue() {
    placeItems()
    world.place(actor, facing: south, at: Coordinate(column: 1, row: 7))
    

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
                    Coordinate(column: 7, row: 1),
                    ]
    world.placeGems(at: items)
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 0, row: 4),
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 1, row: 1),
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 2, row: 1),
                        Coordinate(column: 3, row: 6),
                        Coordinate(column: 5, row: 6),
                        
                        Coordinate(column: 7, row: 0),
                        Coordinate(column: 7, row: 2),
                        Coordinate(column: 7, row: 3),
                        Coordinate(column: 7, row: 4),
                        Coordinate(column: 7, row: 6),
                        
                        Coordinate(column: 8, row: 0),
                        Coordinate(column: 8, row: 1),
                        Coordinate(column: 8, row: 2),
                        Coordinate(column: 8, row: 3),
                        Coordinate(column: 8, row: 4),
                        Coordinate(column: 8, row: 7),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 2, row: 7),
                    Coordinate(column: 3, row: 7),
                    Coordinate(column: 4, row: 7),
                    Coordinate(column: 5, row: 7),
                    Coordinate(column: 6, row: 7),
                    Coordinate(column: 7, row: 7),
                    
                    Coordinate(column: 2, row: 7),
                    Coordinate(column: 3, row: 7),
                    Coordinate(column: 4, row: 7),
                    Coordinate(column: 5, row: 7),
                    Coordinate(column: 6, row: 7),
                    Coordinate(column: 7, row: 7),
                    
                    Coordinate(column: 7, row: 5),
                    Coordinate(column: 8, row: 5),
                    Coordinate(column: 8, row: 6),
                    Coordinate(column: 7, row: 5),
                    Coordinate(column: 8, row: 5),
                    Coordinate(column: 8, row: 6),
                    
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 4, row: 6),
                    Coordinate(column: 6, row: 6),
                    Coordinate(column: 6, row: 6),
                    
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 6, row: 5),
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 6, row: 5),
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 6, row: 5),
                    
                    Coordinate(column: 5, row: 3),
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 5, row: 3),
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 5, row: 5),
                    
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 3, row: 5),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 2, row: 5),
                    
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 1, row: 4),
                    
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 5, row: 2),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 5, row: 2),
                    
                    Coordinate(column: 0, row: 1),
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 0, row: 7),
                    
                    
                    
                    Coordinate(column: 3, row: 1),
                    Coordinate(column: 3, row: 0),
                    
                    Coordinate(column: 6, row: 0),
                    
                    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing: west, at: Coordinate(column: 0, row: 5))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 1, row: 6))
    
    world.place(Stair(), facing: south, at: Coordinate(column: 4, row: 6))
    
    world.place(Stair(), facing: north, at: Coordinate(column: 6, row: 6))
    
    world.place(Stair(), facing: east, at: Coordinate(column: 7, row: 5))
    
    world.place(Stair(), facing: east, at: Coordinate(column: 2, row: 4))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 4))
    world.place(Stair(), facing: west, at: Coordinate(column: 1, row: 2))
    world.place(Stair(), facing: west, at: Coordinate(column: 5, row: 2))
    world.place(Stair(), facing: south, at: Coordinate(column: 3, row: 1))
    world.place(Stair(), facing: south, at: Coordinate(column: 0, row: 0))
    world.place(Stair(), facing: east, at: Coordinate(column: 4, row: 0))
}

