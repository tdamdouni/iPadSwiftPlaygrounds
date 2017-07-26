// 
//  StartMarker.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class StartMarker: Item, NodeConstructible {
    
    // MARK: Static
    
    static var template: SCNNode = {
        let url = Bundle.main().urlForResource(WorldConfiguration.propsDir + "zon_prop_startTile_c", withExtension: "dae")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        
        // Slight offset to avoid z-fighting.
        node.position.y = 0.01
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .startMarker
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    /// The type of actor this startMarker is used for. 
    let type: ActorType
    
    init(type: ActorType) {
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

import PlaygroundSupport

extension StartMarker: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.string(type.rawValue)]
    }
}
