// 
//  Stair.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class Stair: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static var template: SCNNode = {
        let url = Bundle.main().urlForResource(WorldConfiguration.resourcesDir + "blocks/zon_stairs_a_half", withExtension: "dae")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        node.position.y = -WorldConfiguration.levelHeight
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .stair
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    public var isStackable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        return WorldConfiguration.levelHeight
    }
    
    // Only stairs which were initialized directly (not from an existing node) require geometry.
    let needsGeometry: Bool
    
    public init() {
        needsGeometry = true
        
        node = NodeWrapper(identifier: .stair)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .stair else { return nil }
        needsGeometry = false
        
        self.node = NodeWrapper(node)
    }
    
    // MARK: 
    
    public func loadGeometry() {
        guard needsGeometry && scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(Stair.template.clone())
    }
}

import PlaygroundSupport

extension Stair: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

