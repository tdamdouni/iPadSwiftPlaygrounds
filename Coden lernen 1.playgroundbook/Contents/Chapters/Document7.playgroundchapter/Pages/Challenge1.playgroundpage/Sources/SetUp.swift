// 
//  SetUp.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

// MARK: Globals
//let world = GridWorld(columns: 9, rows: 7)
let world = loadGridWorld(named: "8.5")
public let actor = Actor()

public func playgroundPrologue() {
    world.place(actor, facing: west, at: Coordinate(column: 8, row: 1))
    placeWalls()
    placeAdditionalBlocks()
    placeGameItems()


    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}
    

func placeGameItems() {
    
    let items = [
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 0),
                    Coordinate(column: 3, row: 1),
                    Coordinate(column: 3, row: 2),
                    Coordinate(column: 7, row: 1),
                    Coordinate(column: 7, row: 2),
                    
                    Coordinate(column: 5, row: 1),
                    Coordinate(column: 5, row: 0),


                    ]
    world.placeGems(at: items)
    
    let dzs = [
                  Coordinate(column: 2, row: 4),
                  Coordinate(column: 2, row: 5),
                  
                  Coordinate(column: 4, row: 3),
                  Coordinate(column: 4, row: 4),

                  Coordinate(column: 6, row: 5),
                  Coordinate(column: 6, row: 6),
                  ]
    world.place(nodeOfType: Switch.self, at: dzs)
    
    let openSwitch = Switch()
    openSwitch.isOn = true
    
    world.place(openSwitch, at: Coordinate(column: 0, row: 4))
	  
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
    world.place(Wall(edges: [.right]), at: Coordinate(column: 6, row: 2))
    world.place(Wall(edges: [.right]), at: Coordinate(column: 6, row: 1))


}

func placeAdditionalBlocks() {
    let blocks = [
        Coordinate(column: 5, row: 3),
        Coordinate(column: 5, row: 3),
        Coordinate(column: 5, row: 4),
        
        Coordinate(column: 1, row: 4),
        Coordinate(column: 1, row: 4),
        Coordinate(column: 1, row: 3),



    ]
    
    world.placeBlocks(at: blocks)
    world.place(Stair(), facing: west, at: Coordinate(column: 5, row: 4))
    world.place(Stair(), facing: south, at: Coordinate(column: 1, row: 3))


}

