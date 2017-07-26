// 
//  Platform.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class Platform: Item, NodeConstructible {
    // MARK: Static
    
    static var template: SCNNode = {
        let url = Bundle.main().urlForResource(WorldConfiguration.platformDir + "zon_prop_platform_a", withExtension: "dae")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        // Offset in container. 0.005 less than the levelHeight to avoid z-fighting when in water.
        node.position.y = -(WorldConfiguration.levelHeight - 0.005)
        
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .platform
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    public var isStackable: Bool {
        return true
    }
    
    public var isLevelMoveable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        return SCNFloat(startingLevel - 1) * WorldConfiguration.levelHeight
    }
    
    private var glyphNode: SCNNode? {
        return scnNode.childNode(withName: "zon_prop_platformSign_a_GEO", recursively: true)
    }
    
    private var glyphMaterial: SCNMaterial? {
        return glyphNode?.geometry?.firstMaterial
    }
    
    // MARK: Properties
    
    var startingLevel: Int
    
    public weak var lock: PlatformLock? = nil {
        didSet {
            guard let lock = lock else { return }
            
            // Configure the reverse connection.
            lock.platforms.insert(self)
            
            setColor()
        }
    }
    
    public convenience init(onLevel level: Int = 0, controlledBy lock: PlatformLock) {
        self.init(onLevel: level)
        
        self.lock = lock

        // Configure the reverse connection.
        lock.platforms.insert(self)
    }
    
    init(onLevel level: Int = 0) {
        self.startingLevel = level
        node = NodeWrapper(identifier: .platform)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .platform else { return nil }
        self.startingLevel = Int(round(node.position.y / WorldConfiguration.levelHeight))
        
        self.node = NodeWrapper(node)
    }
    
    // MARK: Methods
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        let child = Platform.template.clone()
        scnNode.addChildNode(child)
        
        // Create a copy of the underlying material so the color is not shared.
        let geoCopy = self.glyphNode?.createUniqueFirstGeometry()
        let materialCopy = geoCopy?.firstMaterial?.copy() as? SCNMaterial
        geoCopy?.firstMaterial = materialCopy
        self.glyphNode?.geometry = geoCopy
        
        setColor()
    }

    /// Grabs the color from the current lock.
    func setColor() {
        if let lock = lock {
            glyphMaterial?.diffuse.contents = lock.color.rawValue
        }
        
        // Remove shadows for children.
        glyphNode?.castsShadow = false
    }
}

extension Platform: Hashable {
    public var hashValue: Int {
        return scnNode.hashValue
    }
}

public func ==(lhs: Platform, rhs: Platform) -> Bool {
    return lhs.scnNode === rhs.scnNode
}

import PlaygroundSupport

extension Platform: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        let index = lock?.worldIndex ?? -1
        return [.integer(level), .integer(index)]
    }
}
