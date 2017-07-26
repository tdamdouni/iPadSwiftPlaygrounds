//
//  GridOverlay.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import SceneKit

class GridOverlay {
    
    unowned let world: GridWorld
    
    init(world: GridWorld) {
        self.world = world
    }
    
    func displayMarkerFor(hit: SCNHitTestResult) {
        let node = world.grid.scnNode
        
        let hitNode = hit.node
        let scenePoint = hitNode.convertPosition(hit.localCoordinates, to: node)
        
        let coordinate = Coordinate(scenePoint)
        guard world.gridContains(coordinate: coordinate) else { return }
        
        var coordinatePosition = coordinate.position
        coordinatePosition.y = max(world.nodeHeight(at: coordinate), 0)

        let marker = CoordinateMarker(coordinate: coordinate)
        marker.position = coordinatePosition
        node.addChildNode(marker)
        
        marker.runAction(.sequence([
            .wait(duration: 1.0),
            .fadeOut(duration: 0.5),
            .removeFromParentNode()
        ]))
    }
}

