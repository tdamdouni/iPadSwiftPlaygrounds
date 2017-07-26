// 
//  Water.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

public final class Water: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static var template: SCNNode = {
        let url = Bundle.main().urlForResource(WorldConfiguration.resourcesDir + "barrier/zon_barrier_water_1x1", withExtension: "scn")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        node.name = WorldNodeIdentifier.water.rawValue

        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .water
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    public var isStackable: Bool {
        return true
    }
    
    public init() {
        node = NodeWrapper(identifier: .water)
    }
    
    init?(node: SCNNode) {
        // Support maps exported with blocks named "Obstacle".
        guard node.identifier == .water
            || node.identifierComponents.first == "Obstacle" else { return nil }
        
        self.node = NodeWrapper(node)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(Water.template.clone())
    }
}

import PlaygroundSupport

extension Water: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

