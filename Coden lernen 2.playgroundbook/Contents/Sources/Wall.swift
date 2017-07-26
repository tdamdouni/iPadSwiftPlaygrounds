// 
//  Wall.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

public final class Wall: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static let template: SCNNode = {
        let node = Asset.node(named: "zon_prop_fence_pebble_b", in: .item(.wall), fileExtension: "scn")!
        // Adjust the node's piviot point so that the wall sits in the center of the node.
        let pivotNode = SCNNode()
        node.position.x += WorldConfiguration.coordinateLength / 2
        pivotNode.addChildNode(node)
        
        return pivotNode
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .wall
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    // MARK: 
    
    let edges: Edge
    
    public convenience init() {
        self.init(edges: .top)
    }
    
    public init(edges: Edge) {
        self.edges = edges
        
        node = NodeWrapper(identifier: .wall)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .wall else { return nil }
        
        // Maps the old wall format (based on rotation and offset) to the new edge based format.
        // π offset to make edge correctly align with node after rotation.
        let direction = Direction(radians: node.eulerAngles.y + π)
        switch direction {
        case .north, .south:
            let offset = node.position.x.truncatingRemainder(dividingBy: 1)
            edges = abs(offset) < 0.5 ? .top : .bottom
            
        case .east, .west:
            let offset = node.position.z.truncatingRemainder(dividingBy: 1)
            edges = abs(offset) < 0.5 ? .left : .right
        }
        
        self.node = NodeWrapper(node)
    }

    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        addWallNodes(for: edges)
    }
    
    func addWallNodes(for edge: Edge) {
        let template = Wall.template
        let offset = WorldConfiguration.coordinateLength / 2 - 0.01
        
        if edge.contains(.top) {
            let top = template.clone()
            top.position.z += -offset
            top.eulerAngles.y = SCNFloat(M_PI_2)
            scnNode.addChildNode(top)
        }
        
        if edge.contains(.bottom) {
            let bottom = template.clone()
            bottom.position.z += offset
            bottom.eulerAngles.y = SCNFloat(M_PI_2)
            scnNode.addChildNode(bottom)
        }
        
        if edge.contains(.left) {
            let left = template.clone()
            left.position.x += -offset
            left.eulerAngles.y = 0
            scnNode.addChildNode(left)
        }
        
        if edge.contains(.right) {
            let right = template.clone()
            right.position.x += offset
            right.eulerAngles.y = 0
            scnNode.addChildNode(right)
        }
    }
    
    // MARK: 
    
    public func blocksMovement(from start: Coordinate, to end: Coordinate) -> Bool {
        let translationDirection = Direction(from: start, to: end)
        let direction: Direction = coordinate == start ? translationDirection : Direction(radians: translationDirection.radians + π) // Opposite direction
        
        // Account for base node rotation. 
        let rotatedDirection = Direction(radians: direction.radians + rotation)
        
        switch rotatedDirection {
        case .north: return edges.contains(.top)
        case .south: return edges.contains(.bottom)
        case .east: return edges.contains(.right)
        case .west: return edges.contains(.left)
        }
    }
}

extension Wall: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.integer(Int(edges.rawValue))]
    }
}

