// 
//  SetUp.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

let world = loadGridWorld(named: "1.1")
let actor = Actor()

public func playgroundPrologue() {
    
    world.place(actor, facing: .north, at: Coordinate(column: 1, row: 1))
    world.place(Gem(), at: Coordinate(column: 1, row: 4))

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

public func presentWorld() {
    setUpLiveViewWith(world)
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}
