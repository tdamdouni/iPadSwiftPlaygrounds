// 
//  LiveView.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

// Indicate that this is the LiveView process.
Process.configureForAlwaysOnLiveView()

// Load the scene and add any additional elements.
playgroundPrologue()

// Set up the initial SceneController. Another world instances will be created
// for calculations. 
presentWorld()

// Start running the LiveView. 
startPlayback()
