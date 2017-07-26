// 
//  Water.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import PlaygroundSupport

public final class Water: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static let template = Asset.node(named: "zon_barrier_water_1x1", in: .item(.water), fileExtension: "scn")!
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .water
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
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

extension Water: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

