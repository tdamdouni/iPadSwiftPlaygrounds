// 
//  GridWorld+Border.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

extension Scene {
    func addBorder(around world: GridWorld) {
        // Retrieve scenery elements.
        
        guard let waterFallNode = SCNScene(named: "")?.rootNode.childNodes[0] else { return }
        
        let waterFallOffset: SCNFloat = 3 * WorldConfiguration.coordinateLength / 4.0
        
        let cols = world.columnCount
        let rows = world.rowCount
        let topCoors = (0..<cols).map { Coordinate(column: $0, row: rows - 1) } // -z
        let backCoors = (0..<cols).map { Coordinate(column: $0, row: 0) } // +z
        let leftCoors = (0..<rows).map { Coordinate(column: 0, row: $0) }
        let rightCoors = (0..<rows).map { Coordinate(column: cols - 1, row: $0) }
        
        var boarderCoordinates = topCoors
        boarderCoordinates.append(contentsOf: backCoors)
        boarderCoordinates.append(contentsOf: leftCoors)
        boarderCoordinates.append(contentsOf: rightCoors)
        
        // Find the boarder nodes.
        for coor in boarderCoordinates {
            guard let water = world.existingNode(ofType: Water.self, at: coor) else { continue }
                
            // Refrain from adding scenery nodes to the grid for efficiency reasons (the grid is inspected by the diff).
            let scenePosition = world.grid.scnNode.convertPosition(water.position, to: nil)
            let template = waterFallNode.clone()
            
            var yRotation: SCNFloat = 0
            var xOffset: SCNFloat = 0
            var zOffset: SCNFloat = 0

            switch (coor.column, coor.row) {
            case (cols - 1, let r) where r != 0:
                xOffset = waterFallOffset
                yRotation = π / 2
                
            case (0, let r) where r != rows - 1:
                xOffset = -waterFallOffset
                yRotation = π / 2
                
            case (let c, rows - 1) where c != cols - 1:
                zOffset = -waterFallOffset

            case (let c, 0) where c != 0:
                zOffset = waterFallOffset
            
            default: break
            }
            
            template.position.x = scenePosition.x + xOffset
            template.position.z = scenePosition.z + zOffset
            template.eulerAngles.y = yRotation
            
            water.scnNode.addChildNode(template)
        }
        
        
        
        // Lower left
        let lowerLeft = Coordinate(column: 0, row: 0)
        if let water = world.existingNode(ofType: Water.self, at: lowerLeft) {
            let template = waterFallNode.clone()
            let scenePosition = world.grid.scnNode.convertPosition(water.position, to: nil)
            
            template.position.x = scenePosition.x + -waterFallOffset
            template.eulerAngles.y = π / 2
            water.scnNode.addChildNode(template)
        }
    }
}
