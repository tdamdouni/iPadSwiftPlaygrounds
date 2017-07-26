// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
public let world = loadGridWorld(named: "10.4")
let actor = Actor()
public var greenPortal = Portal(color: .green)
public var orangePortal = Portal(color: .orange)

public func playgroundPrologue() {
    
    placeActor()
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

func placeActor() {
    world.place(actor, facing: south, at: Coordinate(column: 3, row: 4))
}

func placePortals() {
    world.place(greenPortal, between: Coordinate(column: 1, row: 1), and: Coordinate(column: 5, row: 4))
    world.place(orangePortal, between: Coordinate(column: 1, row: 4), and: Coordinate(column: 5, row: 1))
}

func placeItems() {
    let dzCoords = [
                       Coordinate(column: 1, row: 0),
                       Coordinate(column: 0, row: 1),
                       Coordinate(column: 1, row: 2),
                       Coordinate(column: 2, row: 1),
                       
                       Coordinate(column: 1, row: 5),
                       Coordinate(column: 0, row: 4),
                       
                       
                       ]
    world.place(nodeOfType: Switch.self, at: dzCoords)
    
    let itemCoords = [
                         Coordinate(column: 5, row: 0),
                         Coordinate(column: 4, row: 1),
                         Coordinate(column: 5, row: 2),
                         Coordinate(column: 6, row: 1),
                         
                         Coordinate(column: 5, row: 5),
                         Coordinate(column: 6, row: 4)
    ]
    world.placeGems(at: itemCoords)
}

func placeBlocks() {
    world.placeBlocks(at: world.coordinates(inColumns: [5], intersectingRows: 0...5))
    
    world.removeNodes(at: world.coordinates(inColumns: [2,3,4], intersectingRows: 0...3))
    world.placeWater(at: world.coordinates(inColumns: [2,3,4], intersectingRows: 0...3))
    
    
    let tiers = [
                    Coordinate(column: 0, row: 0),
                    
                    Coordinate(column: 4, row: 1),
                    Coordinate(column: 4, row: 1),
                    
                    Coordinate(column: 0, row: 2),
                    Coordinate(column: 2, row: 1),
                    
                    
                    Coordinate(column: 6, row: 1),
                    Coordinate(column: 6, row: 4),
                    
                    
                    Coordinate(column: 1, row: 4),
                    Coordinate(column: 0, row: 4),
                    Coordinate(column: 1, row: 5),
                    
                    
                    
                    
                    ]
    world.placeBlocks(at: tiers)
    world.place(Stair(), facing: east, at: Coordinate(column: 2, row: 4))
    world.place(Stair(), facing: west, at: Coordinate(column: 4, row: 4))
    world.place(greenPortal, between: Coordinate(column: 1, row: 1), and: Coordinate(column: 5, row: 4))
    world.place(orangePortal, between: Coordinate(column: 1, row: 4), and: Coordinate(column: 5, row: 1))
}
