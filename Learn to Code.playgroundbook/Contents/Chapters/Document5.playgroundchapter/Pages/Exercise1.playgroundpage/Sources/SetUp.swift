// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "5.1")
public let actor = Actor()

let switchCoordinates = [
    Coordinate(column: 0, row: 2),
    Coordinate(column: 1, row: 2),
    Coordinate(column: 2, row: 2)
]

public func playgroundPrologue() {
    
    placeActor()
    placeRandomNodes()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems()
    }
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
    world.place(actor, facing: west, at: Coordinate(column: 4, row: 2))
}

func placeRandomNodes() {
    let switchItem = Switch()
    
    for coord in switchCoordinates {
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
}

func realizeRandomItems() {
    let switchNodes = world.place(nodeOfType: Switch.self, at: switchCoordinates)
    
    for switchNode in switchNodes {
        switchNode.isOn = randomBool
    }
    
    // Ensure at least one Switch is off.
    let switchNode = switchNodes.randomElement
    switchNode?.isOn = false
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 1, row: 1),
                        Coordinate(column: 1, row: 3),
                        Coordinate(column: 1, row: 4),
                        
                        Coordinate(column: 2, row: 1),
                        Coordinate(column: 3, row: 1),
                        
                        Coordinate(column: 2, row: 3),
                        Coordinate(column: 3, row: 3),
                        
                        
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 2, row: 0),
                    Coordinate(column: 3, row: 0),
                    Coordinate(column: 3, row: 0),
                    
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 4, row: 0),
                    Coordinate(column: 4, row: 0),
                    
                    Coordinate(column: 5, row: 0),
                    
                    Coordinate(column: 5, row: 0),
                    
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 1, row: 2),
                    Coordinate(column: 2, row: 2),
                    
                    
                    
                    Coordinate(column: 2, row: 4),
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 3, row: 4),
                    
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 4, row: 4),
                    
                    Coordinate(column: 5, row: 4),
                    
                    Coordinate(column: 5, row: 4),
                    ]
    world.placeBlocks(at: tiers)
    
    world.place(Stair(), at: Coordinate(column: 0, row: 1))
    world.place(Stair(), facing: north, at: Coordinate(column: 0, row: 3))
    world.place(Stair(), facing: east, at: Coordinate(column: 3, row: 2))
}
