// 
//  Stair.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import PlaygroundSupport

public final class Stair: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static let template: SCNNode = {
        let node = Asset.node(named: "zon_stairs_a_half", in: .item(.stair))!
        node.position.y = -WorldConfiguration.levelHeight
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .stair
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
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

extension Stair: MessageConstructor {    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

