// 
//  RandomNode.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class RandomNode: Item, NodeConstructible {
    // MARK: Static
    
    static let supportedRandomIds: [WorldNodeIdentifier] = [.block, .stair, .item, .switch]
    static let names = ["zon_prop_block_RAND", "zon_prop_stairs_RAND", "zon_prop_gem_RAND", "zon_prop_switchON_RAND", "zon_prop_switchOFF_RAND"]
    
    static var templates: [SCNNode] = {
        return names.map {
            RandomNode.template(for: $0)
        }
    }()
    
    static func template(for name: String) -> SCNNode {
        let url = Bundle.main().urlForResource(WorldConfiguration.randomElementsDir + name, withExtension: "dae")!
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        node.enumerateHierarchy { child, _ in
            child.castsShadow = false
        }
        
        return node
    }
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .randomNode
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper

    public var worldIndex = -1
    
    /// The item that this Random indicator resembles.
    let resemblingNode: Item
    
    // Use the offset of the node type this `RandomNode` represents.
    public var verticalOffset: SCNFloat {
        return resemblingNode.verticalOffset
    }
    
    public init(resembling node: Item) {
        resemblingNode = node
        self.node = NodeWrapper(identifier: .randomNode)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .randomNode else { return nil }
        
        // It doesn't matter for loaded nodes. Could be reconstructed from the name.
        resemblingNode = Block()
        
        self.node = NodeWrapper(node)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        let templateIndex: Int
        switch resemblingNode.identifier {
        case .block: templateIndex = 0
        case .stair: templateIndex = 1
        case .item: templateIndex = 2
        case .switch where (resemblingNode as! Switch).isOn: templateIndex = 3
        case .switch: templateIndex = 4
        default: templateIndex = -1
        }
        
        let template = templateIndex >= 0 ? RandomNode.templates[templateIndex] : SCNNode()
        template.name = RandomNode.identifier.rawValue + "-" + resemblingNode.identifier.rawValue
        
        // Slight offset to avoid z-fighting (on-Switch).
        template.position.y = -resemblingNode.verticalOffset + 0.01
        scnNode.addChildNode(template.clone())
    }
    
    // MARK: Animations
    
    public func removeAction(withDuration duration: TimeInterval) -> SCNAction {
        let fifthDuration = duration / 5
        
        let wait = SCNAction.wait(forDuration: fifthDuration)
        let scaleUp = SCNAction.scale(to: 1.2, duration: fifthDuration * 3)
        let scaleZero = SCNAction.scale(to: 0.0, duration: fifthDuration)
        
        return SCNAction.sequence([wait, scaleUp, scaleZero])
    }
}

import PlaygroundSupport

extension RandomNode: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.string(resemblingNode.identifier.rawValue)]
    }
}
