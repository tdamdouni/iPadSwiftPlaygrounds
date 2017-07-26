//
//  _LiveViewConfiguration.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
// Note: This is not included in the project target and is only
// used within the Playground to present the liveView.

import PlaygroundSupport

// MARK: Scene Loading

/// A global reference to the loaded scene.
private var _scene: Scene? = nil
public func loadGridWorld(named name: String) -> GridWorld {
    do {
        _scene = try Scene(named: name)
    }
    catch {
        presentAlert(title: "Failed To Load `\(name)`", message: "\(error)")
        return GridWorld(columns: 0, rows: 0)
    }
    
    return _scene!.gridWorld
}

// MARK: Scene Presentation

/// A reference to the loaded controller, held here for presentation in `startPlayback()`.
private var sceneController: WorldViewController!
public func setUpLiveViewWith(_ gridWorld: GridWorld) {
    guard sceneController == nil else {
        presentAlert(title: "Warning", message: "Mulitiple calls to \(#function).")
        return
    }
    
    // Attempt to use the loaded scene or create one from the world.
    let loadedScene = _scene ?? Scene(world: gridWorld)
    _scene = nil
    
    // Create the controller, but don't display it until `startPlayback`.
    sceneController = WorldViewController.makeController(with: loadedScene)
}

/**
 Marks the end of unanimated world building, collapsing any placement commands 
 provided in the `collapsingCommands` closure, before removing `RandomItems`.
*/
public func finalizeWorldBuilding(for world: GridWorld, collapsingCommands: (@noescape () -> Void)? = nil) {
    // Animate any additional world elements that are added or removed.
    world.isAnimated = true
    
    let queue = world.commandQueue
    
    // Start after the current command.
    let startIndex = queue.isEmpty ? 0 : queue.endIndex + 1
    collapsingCommands?()
    let endIndex = queue.endIndex
    
    if startIndex < endIndex {
        queue.collapsePlacementCommands(in: startIndex..<endIndex)
    }
    
    // Add commands to remove the random nodes after the world is built.
    world.removeRandomNodes()
}

/// Used to present the world as the `currentPage`'s liveView.
public func startPlayback() {
    PlaygroundPage.current.liveView = sceneController
    sceneController.startPlayback()
}
