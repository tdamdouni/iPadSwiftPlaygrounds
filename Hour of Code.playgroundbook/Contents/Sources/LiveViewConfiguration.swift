//
//  LiveViewConfiguration.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport

// MARK: Scene Loading

/// A global reference to the loaded scene.
private var loadedScene: Scene? = nil
public func loadGridWorld(named name: String) -> GridWorld {
    pageIdentifier = name

    do {
        loadedScene = try Scene(named: name)
    }
    catch {
        presentAlert(title: "Failed To Load `\(name)`", message: "\(error)")
        return GridWorld(columns: 0, rows: 0)
    }
    
    return loadedScene!.gridWorld
}

// MARK: Scene Presentation

public func setUpLiveViewWith(_ gridWorld: GridWorld) {
    // Attempt to use the loaded scene or create one from the world.
    let scene = loadedScene ?? Scene(world: gridWorld)
    
    // At this point the world is fully built.
    scene.state = .built
    
    // Assign the liveView.
    let sceneController = SceneController(scene: scene)
    PlaygroundPage.current.liveView = sceneController
}

/// Used to present the world as the `currentPage`'s liveView.
public func startPlayback() {
    guard let sceneController = PlaygroundPage.current.liveView as? SceneController else {
        fatalError("The liveView has not been assigned a `SceneController`")
    }
    
    // Start playing the scene.
    sceneController.startPlayback()
}

/**
 Marks the end of unanimated world building, collapsing any placement commands 
 provided in the `collapsingCommands` closure, before removing `RandomItems`.
*/
public func finalizeWorldBuilding(for world: GridWorld, collapsingCommands: (() -> Void)? = nil) {
    // Animate any additional world elements that are added or removed.
    world.isAnimated = true
    
    // Do not step though the commands added here. 
    sender?.shouldWaitForResponse = false
    
    let collapsingQueue = CommandQueue()
    let queue = world.commandQueue
    world.commandQueue = collapsingQueue
    
    // Collapse the commands onto the new queue.
    collapsingCommands?()

    if !collapsingQueue.isEmpty {
        collapsingQueue.collapsePlacementCommands(in: 0..<collapsingQueue.endIndex)
    }

    world.commandQueue = queue
    
    // Add the collapsed commands.
    for command in collapsingQueue {
        queue.append(command)
    }
    
    // Add commands to remove the random nodes after the world is built.
    world.removeRandomNodes()
    
    sender?.shouldWaitForResponse = true
    
    // If no additional commands are queued, mark the world's build as being complete
    if collapsingQueue.isEmpty || world.commandQueue.isEmpty {
        world.worldBuildComplete = true
    }

    Command.processingWorldBuildingCommands = false

    // Send the assessment critera for this run.
    liveViewMessageHandler?.send(world.successCriteria.message, forKey: .successCriteriaInfo)
}
