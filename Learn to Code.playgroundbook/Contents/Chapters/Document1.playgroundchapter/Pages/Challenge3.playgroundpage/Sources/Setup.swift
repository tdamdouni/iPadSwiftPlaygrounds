// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

//let world = GridWorld(columns: 9, rows: 6)
let world: GridWorld = loadGridWorld(named: "1.7")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: east, at: Coordinate(column: 3, row: 0))
    
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
    world.placeGems(at: [Coordinate(column: 6, row: 0)])
    world.place(nodeOfType: Switch.self, facing: east, at: [Coordinate(column: 4, row: 5)])
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 1, row: 2), and: Coordinate(column: 7, row: 5))
    world.place(Portal(color: .green), between: Coordinate(column: 2, row: 5), and: Coordinate(column: 8, row: 0))
}

func placeFloor() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 0, row: 1),
                        Coordinate(column: 0, row: 2),
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 0, row: 4),
                        
                        
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 2, row: 3),
                        Coordinate(column: 3, row: 3),
                        Coordinate(column: 4, row: 3),
                        Coordinate(column: 5, row: 3),
                        
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 1, row: 1),
                        
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 2, row: 1),
                        
                        Coordinate(column: 8, row: 2),
                        Coordinate(column: 8, row: 3),
                        Coordinate(column: 8, row: 4),
                        Coordinate(column: 8, row: 5),
                        
                        Coordinate(column: 7, row: 2),
                        Coordinate(column: 7, row: 3),
                        Coordinate(column: 7, row: 4),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 5, row: 2),
                    
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 3, row: 5),
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 6, row: 5),
                    Coordinate(column: 7, row: 5),
                    
                    Coordinate(column: 4, row: 5),
                    
                    ]
    world.placeBlocks(at: tiers)
    
    
    world.place(Stair(), at: Coordinate(column: 3, row: 1))
    world.place(Stair(), at: Coordinate(column: 6, row: 4))
    
    let stairsCoordinates = [
                                Coordinate(column: 2, row: 2),
                                Coordinate(column: 1, row: 5),
                                Coordinate(column: 3, row: 5),
                                
                                ]
    world.place(nodeOfType: Stair.self, facing: west, at: stairsCoordinates)
    world.place(Stair(), facing: east, at: Coordinate(column: 5, row: 5))
}
