// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "6.5")
let actor = Actor()

public func playgroundPrologue() {

    placeWalls()
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

func placeWalls() {
    world.place(Wall(edges: [.right]), at: Coordinate(column: 1, row: 0))
    world.place(Wall(edges: [.top, .left]), at: Coordinate(column: 2, row: 1))

}

func placeItems() {
    let items = [
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 2, row: 5),
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 1, row: 5),
                    Coordinate(column: 1, row: 7),
                    Coordinate(column: 5, row: 4),
                    ]
    world.placeGems(at: items)
    
    
    let dropZones = [
                        Coordinate(column: 1, row: 2),
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 3, row: 4),
                        Coordinate(column: 3, row: 5),
                        Coordinate(column: 1, row: 5),
                        ]
    world.place(nodeOfType: Switch.self, at: dropZones)
    let openSwitch = Switch(open: true)
    world.place(openSwitch, at: Coordinate(column: 2, row: 2))
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 2))
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 2, row: 7),
                        Coordinate(column: 3, row: 7),
                        Coordinate(column: 4, row: 7),
                        Coordinate(column: 5, row: 7),
                        
                        Coordinate(column: 2, row: 6),
                        Coordinate(column: 5, row: 6),
                        
                        Coordinate(column: 3, row: 1),
                        Coordinate(column: 4, row: 1),
                        
                        Coordinate(column: 0, row: 3),
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 2, row: 3),
                        Coordinate(column: 0, row: 4),
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 2, row: 4),
                        
                        
                        ]
    world.removeItems(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 0, row: 5),
                    Coordinate(column: 1, row: 5),
                    
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 4, row: 6),
                    Coordinate(column: 4, row: 6),
                    
                    Coordinate(column: 4, row: 5),
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 5, row: 5),
                    Coordinate(column: 5, row: 4),
                    
                    
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 2, row: 2),
                    Coordinate(column: 3, row: 2),
                    
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 4, row: 2),
                    Coordinate(column: 4, row: 2),
                    
                    
                    Coordinate(column: 5, row: 2),
                    Coordinate(column: 5, row: 2),
                    
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 5, row: 0),
                    Coordinate(column: 5, row: 1),
                    Coordinate(column: 5, row: 1),
                    
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 3, row: 6),
                    Coordinate(column: 3, row: 6),
                    
                    Coordinate(column: 4, row: 0),
                    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), facing: south, at: Coordinate(column: 1, row: 1))
    world.place(Stair(), facing: south, at: Coordinate(column: 2, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 3, row: 3))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 4))
    world.place(Stair(), facing: east, at: Coordinate(column: 2, row: 5))
    world.place(Stair(), facing: north, at: Coordinate(column: 1, row: 6))
}
