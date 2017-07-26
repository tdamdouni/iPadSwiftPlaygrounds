//
//  StartMarker.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

public final class StartMarker: Item, NodeConstructible {
    
    // MARK: Static
    
    static let template: SCNNode = {
        let node = Asset.node(named: "zon_prop_startTile_c", in: .item(.startMarker), fileExtension: "scn")!
        // Slight offset to avoid z-fighting.
        node.position.y = 0.01
        node.enumerateHierarchy { child, _ in
            child.castsShadow = false
        }
        
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .startMarker
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    /// The type of actor this startMarker is used for. 
    let type: ActorType
    
    public init(type: ActorType) {
        self.type = type
        
        node = NodeWrapper(identifier: .startMarker)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .startMarker
            && node.identifierComponents.count >= 2 else { return nil }
        guard let type = ActorType(rawValue: node.identifierComponents[1]) else { return nil }
        
        self.type = type
        
        self.node = NodeWrapper(node)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(StartMarker.template.clone())
    }
}

extension StartMarker: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.string(type.rawValue)]
    }
}
