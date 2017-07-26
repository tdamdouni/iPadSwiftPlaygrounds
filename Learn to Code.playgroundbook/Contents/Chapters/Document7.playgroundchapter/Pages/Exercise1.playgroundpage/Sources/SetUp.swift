// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world: GridWorld = loadGridWorld(named: "7.1")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeActor()
    placeRandomItems()

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

func placeRandomItems() {
    let switchItem = Switch()
    for i in 0..<9 {
        world.place(RandomNode(resembling: switchItem), at: Coordinate(column: i, row: 1))
    }
}

func realizeRandomItems() {
    let randomLength = Int(arc4random_uniform(5)) + 3
    
    for i in 0...randomLength {
        world.place(nodeOfType: Switch.self, at: [Coordinate(column: i, row: 1)])
    }
    
    let switchNodes = world.place(nodeOfType: Switch.self, at: [Coordinate(column: (randomLength + 1), row: 1)])
    
    for switchNode in switchNodes {
        switchNode.isOn = true
    }
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 1))
    world.placeStartMarkerUnderActor = false
}

func placeBlocks() {
    let obstacles = [
                        Coordinate(column: 0, row: 0),
                        Coordinate(column: 1, row: 0),
                        Coordinate(column: 2, row: 0),
                        Coordinate(column: 3, row: 0),
                        Coordinate(column: 4, row: 0),
                        Coordinate(column: 5, row: 0),
                        Coordinate(column: 6, row: 0),
                        Coordinate(column: 7, row: 0),
                        Coordinate(column: 8, row: 0),
                        Coordinate(column: 9, row: 0),
                        
                        Coordinate(column: 0, row: 2),
                        Coordinate(column: 1, row: 2),
                        Coordinate(column: 2, row: 2),
                        Coordinate(column: 3, row: 2),
                        Coordinate(column: 4, row: 2),
                        Coordinate(column: 5, row: 2),
                        Coordinate(column: 6, row: 2),
                        Coordinate(column: 7, row: 2),
                        Coordinate(column: 8, row: 2),
                        Coordinate(column: 9, row: 2),
                        
                        Coordinate(column: 0, row: 4),
                        Coordinate(column: 1, row: 4),
                        Coordinate(column: 2, row: 4),
                        
                        Coordinate(column: 7, row: 4),
                        Coordinate(column: 8, row: 4),
                        Coordinate(column: 9, row: 4),
                        
                        Coordinate(column: 5, row: 3),
                        Coordinate(column: 6, row: 3),
                        ]
    world.removeNodes(at: obstacles)
    world.placeWater(at: obstacles)
    
    let tiers = [
                    Coordinate(column: 0, row: 1),
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 3, row: 1),
                    Coordinate(column: 4, row: 1),
                    Coordinate(column: 5, row: 1),
                    Coordinate(column: 6, row: 1),
                    Coordinate(column: 7, row: 1),
                    Coordinate(column: 8, row: 1),
                    Coordinate(column: 9, row: 1),
                    
                    
                    Coordinate(column: 0, row: 3),
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 4, row: 3),
                    Coordinate(column: 7, row: 3),
                    Coordinate(column: 8, row: 3),
                    Coordinate(column: 9, row: 3),
                    
                    Coordinate(column: 1, row: 3),
                    Coordinate(column: 2, row: 3),
                    Coordinate(column: 3, row: 3),
                    Coordinate(column: 8, row: 3),
                    Coordinate(column: 9, row: 3),
                    
                    
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 5, row: 4),
                    Coordinate(column: 6, row: 4),
                    
                    Coordinate(column: 3, row: 4),
                    Coordinate(column: 4, row: 4),
                    Coordinate(column: 5, row: 4),
                    
                    Coordinate(column: 4, row: 4),
                    ]
    world.placeBlocks(at: tiers)
}
