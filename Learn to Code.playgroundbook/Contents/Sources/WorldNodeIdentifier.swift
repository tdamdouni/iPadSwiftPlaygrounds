// 
//  WorldNodeIdentifier.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

public enum WorldNodeIdentifier: String {
    case block = "Block"
    case stair = "Stair"
    case wall = "Wall"
    case water = "Water"
    case item = "Item"
    case `switch` = "Switch"
    case portal = "Portal"
    case platformLock = "PlatformLock"
    case platform = "Platform"
    case startMarker = "StartMarker"
    case randomNode = "RandomNode"
    case actor = "Actor"
    
    static var allIdentifiers: [WorldNodeIdentifier] {
        return [
            .block, .stair, .wall, .water,
            .item, .switch,
            .portal, .platformLock, .platform,
            .startMarker, .actor, .randomNode
        ]
    }
    
    func makeNode() -> SCNNode {
        let scnNode = SCNNode()
        scnNode.name = self.rawValue
        return scnNode
    }
}

extension WorldNodeIdentifier {
    // Used to calculate solution in GridSolutions.swift.
    static var goals: [WorldNodeIdentifier] {
        return [ .item, .switch ]
    }
}

// MARK: GridNodeIdentifier

// Important nodes pertaining to the construction of the grid
let GridNodeName = "GridNode"
let CameraHandleName = "CameraHandle"
let CameraNodeName = "camera"
let DirectionalLightName = "directional"
let ActorStartMarker = "ActorStartMarker"
