// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

let world = loadGridWorld(named: "3.2")
let actor = Actor()

public func playgroundPrologue() {

    world.place(actor, facing: .north, at: Coordinate(column: 0, row: 0))
    
    placeItems()
    
    

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

func placeItems() {
    let coordinates = [
                          Coordinate(column: 0, row: 1),
                          Coordinate(column: 1, row: 4),
                          Coordinate(column: 3, row: 0),
                          Coordinate(column: 4, row: 3),
                          ]
    world.placeGems(at: coordinates)
}

// MARK: Presentation

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}
