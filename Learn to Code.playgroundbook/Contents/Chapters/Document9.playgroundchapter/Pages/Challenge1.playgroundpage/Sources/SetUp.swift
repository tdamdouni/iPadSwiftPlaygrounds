// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

// MARK: Globals
let world = loadGridWorld(named: "9.2")
let actor = Actor()

public func playgroundPrologue() {
    placeActor()
    placeItems()
    

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
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 1))
}

func placeItems() {
    let itemCoords = [
                         Coordinate(column: 1, row: 1),
                         Coordinate(column: 2, row: 1),
                         Coordinate(column: 3, row: 1),
                         Coordinate(column: 4, row: 1),
                         Coordinate(column: 5, row: 1),
                         
                         ]
    world.placeGems(at: itemCoords)
}

func placeBlocks() {
    world.placeBlocks(at: world.coordinates(inColumns: 0...5, intersectingRows: [2]))
    world.placeBlocks(at: world.coordinates(inColumns: 0...5, intersectingRows: [2]))
    world.placeBlocks(at: world.coordinates(inColumns: 0...5, intersectingRows: [2]))
    
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: 0...1))
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: 0...1))
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: 0...1))
    world.placeBlocks(at: world.coordinates(inColumns: [0], intersectingRows: 0...1))
    
    
    world.removeNodes(at: world.coordinates(inColumns: 1...5, intersectingRows: [0]))
    
    
    let tiers = [
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 1),
                    Coordinate(column: 1, row: 1),
                    
                    
                    Coordinate(column: 2, row: 1),
                    Coordinate(column: 2, row: 1),
                    
                    Coordinate(column: 3, row: 1),
                    
                    
                    
                    
                    ]
    world.placeBlocks(at: tiers)
    world.place(Stair(), facing: east, at: Coordinate(column: 1, row: 1))
    world.place(Stair(), facing: east, at: Coordinate(column: 2, row: 1))
    world.place(Stair(), facing: east, at: Coordinate(column: 3, row: 1))
    world.place(Stair(), facing: east, at: Coordinate(column: 4, row: 1))
}
