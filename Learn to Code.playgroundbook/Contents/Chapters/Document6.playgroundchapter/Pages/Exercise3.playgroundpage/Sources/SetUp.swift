// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation


// MARK: Globals
let world = loadGridWorld(named: "6.4")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeItems()
    placeActor()
    placeWalls()
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

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 3))
}

func placeItems() {
    world.place(Gem(), at: Coordinate(column: 6, row: 2))
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 0, row: 1), and: Coordinate(column: 7, row: 1))
}

func placeWalls() {
    world.place(Wall(edges: [.top, .bottom, .left]), at: Coordinate(column: 6, row: 2))
    world.place(Wall(edges: [.bottom]), at: Coordinate(column: 7, row: 2))
}

func placeBlocks() {
    let obstacles1 = world.coordinates(inColumns: 0...8, intersectingRows: [5])
    world.removeNodes(at: obstacles1)
    world.placeWater(at: obstacles1)
    
    let obstacles2 = world.coordinates(inColumns: [3], intersectingRows: 0...4)
    world.removeNodes(at: obstacles2)
    world.placeWater(at: obstacles2)
    
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 0, row: 2),
                        
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 2, row: 4),
                        
                        Coordinate(column: 4, row: 4),
                        Coordinate(column: 4, row: 0),
                        
                        Coordinate(column: 8, row: 0),
                        Coordinate(column: 8, row: 1),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 2, row: 1),
                    
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 2, row: 3),
                    
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 5, row: 0),
                    
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 5, row: 4),
                    
                    Coordinate(column: 7, row: 4),
                    Coordinate(column: 7, row: 4),
                    Coordinate(column: 7, row: 4),
                    
                    ]
    world.placeBlocks(at: tiers)
}
