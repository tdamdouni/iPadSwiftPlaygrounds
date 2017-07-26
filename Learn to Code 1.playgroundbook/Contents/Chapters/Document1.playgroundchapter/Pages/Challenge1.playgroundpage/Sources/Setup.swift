// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 8, rows: 7)
let world: GridWorld = loadGridWorld(named: "1.4")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: north, at: Coordinate(column: 5, row: 0))
    
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
    world.place(nodeOfType: Switch.self, at: [Coordinate(column: 3, row: 3)])
    
    world.placeGems(at: [Coordinate(column: 0, row: 4)])
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 2, row: 3), and: Coordinate(column: 1, row: 6))
}

func placeFloor() {
    let obstacles = [
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 1, row: 1),
                        Coordinate(column: 1, row: 2),
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 1, row: 4),
                        
                        Coordinate(column: 2, row: 1),
                        Coordinate(column: 2, row: 2),
                        Coordinate(column: 2, row: 4),
                        Coordinate(column: 2, row: 5),
                        
                        Coordinate(column: 3, row: 1),
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 3, row: 4),
                        
                        Coordinate(column: 4, row: 6),
                        Coordinate(column: 4, row: 4),
                        Coordinate(column: 4, row: 2),
                        
                        Coordinate(column: 5, row: 6),
                        Coordinate(column: 6, row: 6),
                        Coordinate(column: 7, row: 6),
                        
                        Coordinate(column: 7, row: 6),
                        Coordinate(column: 7, row: 5),
                        Coordinate(column: 7, row: 4),
                        Coordinate(column: 7, row: 3),
                        Coordinate(column: 7, row: 2),
                        Coordinate(column: 7, row: 1),
                        Coordinate(column: 7, row: 0),
                        ]
    world.removeItems(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 0, row: 0),
                    Coordinate(column: 0, row: 1),
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 0, row: 2),
                    
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 6, row: 3),
                    Coordinate(column: 6, row: 3),
                    
                    Coordinate(column: 5, row: 3),
                    Coordinate(column: 5, row: 2),
                    
                    Coordinate(column: 2, row: 6),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 3, row: 5),
                    
                    ]
    world.placeBlocks(at: tiers)
    
    let stairsCoordinates = [
                                Coordinate(column: 1, row: 0),
                                Coordinate(column: 4, row: 5),
                                ]
    world.place(nodeOfType: Stair.self, facing: east, at: stairsCoordinates)
    
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 3))
    world.place(Stair(), facing: north, at: Coordinate(column: 5, row: 4))
    world.place(Stair(), at: Coordinate(column: 5, row: 1))
}
