// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "7.3")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeItems()
    placeActor()
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
    world.place(actor, facing: south, at: Coordinate(column: 0, row: 3))
}

func placeItems() {
    let items = [
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 2, row: 1),
                    
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 5, row: 2),
                    Coordinate(column: 6, row: 1),
                    ]
    world.placeGems(at: items)
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 2, row: 0), and: Coordinate(column: 2, row: 4))
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 0, row: 1),
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 5, row: 3),
                        Coordinate(column: 6, row: 3),
                        Coordinate(column: 2, row: 3),
                        
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 3, row: 1),
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 4, row: 0),
                        Coordinate(column: 4, row: 1),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let remove = [
                     Coordinate(column: 7, row: 3),
                     Coordinate(column: 7, row: 2),
                     Coordinate(column: 7, row: 1),
                     Coordinate(column: 7, row: 0),
                     Coordinate(column: 7, row: 0),
                     
                     Coordinate(column: 6, row: 0),
                     Coordinate(column: 5, row: 0),
                     
                     Coordinate(column: 0, row: 4),
                     
                     Coordinate(column: 1, row: 4)
    ]
    world.removeNodes(at: remove)
    
    let tiers = [
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 4, row: 4),
                    
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 4, row: 3),
                    
                    Coordinate(column: 5, row: 2),
                    Coordinate(column: 6, row: 2),
                    Coordinate(column: 4, row: 2),
                    
                    Coordinate(column: 5, row: 1),
                    Coordinate(column: 6, row: 1),
                    
                    
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 7, row: 4),
                    
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 7, row: 4),
                    
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 7, row: 4),
                    
                    Coordinate(column: 7, row: 4),
                    Coordinate(column: 6, row: 4),
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 4, row: 4)
    ]
    world.placeBlocks(at: tiers)
}
