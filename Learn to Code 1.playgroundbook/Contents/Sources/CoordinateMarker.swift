//
//  CoordinateMarker.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

class CoordinateMarker: SCNNode {
    
    static let sideColor: Color = #colorLiteral(red: 0.9116834998, green: 0.9118586779, blue: 0.9116543531, alpha: 1)
    
    static let northColor: Color = #colorLiteral(red: 0.9755242467, green: 0.2155249864, blue: 0.2382360697, alpha: 1)
    
    static let markerNode: SCNNode = {
        // Make a square grid indicator.
        let max = WorldConfiguration.coordinateLength
        let container = SCNNode()
        
        let northGeo = SCNCylinder(radius: 0.01, height: 1)
        northGeo.firstMaterial?.diffuse.contents = northColor.rawValue
        
        let top = SCNNode(geometry: northGeo)
        top.position = SCNVector3(x: 0, y: 0, z: -max / 2)
        top.eulerAngles.z = π / 2
        container.addChildNode(top)
        
        let geo = northGeo.copy() as! SCNGeometry
        geo.firstMaterial = geo.firstMaterial?.copy() as? SCNMaterial
        geo.firstMaterial?.diffuse.contents = sideColor.rawValue

        let sideTemplate = SCNNode(geometry: geo)

        let left = sideTemplate.clone()
        left.position = SCNVector3(x: -max / 2, y: 0, z: 0)
        left.eulerAngles.x = π / 2
        container.addChildNode(left)

        let right = sideTemplate.clone()
        right.position = SCNVector3(x: max / 2, y: 0, z: 0)
        right.eulerAngles.x = π / 2
        container.addChildNode(right)
        
        let bottom = sideTemplate.clone()
        bottom.position = SCNVector3(x: 0, y: 0, z: max / 2)
        bottom.eulerAngles.z = π / 2
        container.addChildNode(bottom)

        return container
    }()
    
    unowned let label: SCNNode
    
    init(coordinate: Coordinate) {
        // Create the label node.
        let labelGeo = SCNText(string: "\(coordinate.column, coordinate.row)", extrusionDepth: 0)
        labelGeo.flatness = 0.5
        labelGeo.firstMaterial?.diffuse.contents = Color.white.rawValue
        labelGeo.firstMaterial?.specular.contents = Color.white.rawValue
        labelGeo.firstMaterial?.selfIllumination.contents = Color.white.rawValue
        label = SCNNode(geometry: labelGeo)
        
        super.init()
        
        // Add the square marker around the coordinate.
        let marker = CoordinateMarker.markerNode.flattenedClone()
        marker.castsShadow = false
        marker.position.y = 0.01
        addChildNode(marker)
        
        // Create a billboard constraint so that the text always faces the camera.
        let labelContainer = SCNNode()
        addChildNode(labelContainer)
        
        let constraint = SCNBillboardConstraint()
        constraint.freeAxes = [.X, .Y]
        labelContainer.constraints = [constraint]
        
        // Add the coordinate label.
        let scaleSize: Float = 0.03
        label.scale = SCNVector3(x: scaleSize, y: scaleSize, z: scaleSize)
        
        let (vMin, vMax) = label.boundingBox
        label.position.x = (vMin.x - vMax.x) / 2 * scaleSize
        label.position.z = WorldConfiguration.coordinateLength
        labelContainer.addChildNode(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
