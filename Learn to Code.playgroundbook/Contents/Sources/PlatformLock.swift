// 
//  PlatformLock.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class PlatformLock: Item, NodeConstructible {
    // MARK: Static
    
    static var template: SCNNode = {
        let url = Bundle.main().urlForResource(WorldConfiguration.resourcesDir + "Lock/NeutralPose", withExtension: "dae")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .platformLock
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    // MARK: Private
    
    private var glyphMaterial: SCNMaterial? {
        return scnNode.childNode(withName: "lockAlpha_0001", recursively: true)?.firstGeometry?.firstMaterial
    }
    
    public var color: Color {
        didSet {
            setColor()
        }
    }
    
    var platforms = Set<Platform>()
    
    /// 0-4
    public var platformIndex = 0 {
        didSet {
            platformIndex = platformIndex.clamp(min: 0, max: 4)
        }
    }
    
    public init(color: Color = .yellow) {
        self.color = color
        node = NodeWrapper(identifier: .platformLock)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .platformLock else { return nil }
        self.color = .yellow
        self.node = NodeWrapper(node)
    }
    
    // MARK: 
    
    public func raisePlatforms() {
        guard let world = world else { return }

        for platform in platforms {
            platform.position.y += WorldConfiguration.levelHeight
            
            world.percolateNodes(at: platform.coordinate)
        }
    }
    
    public func lowerPlatforms() {
        guard let world = world else { return }

        for platform in platforms {
            platform.position.y -= WorldConfiguration.levelHeight
            
            world.percolateNodes(at: platform.coordinate)
        }
    }
    
    func setColor() {
        glyphMaterial?.diffuse.contents = color.rawValue
        
        for platform in platforms {
            // This will trigger a pass of `setColor()` on the platform.
            platform.lock = self
        }
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        // The geometry is reloaded every-time to workaround: rdar<>
        let url = Bundle.main().urlForResource(WorldConfiguration.lockDir + "NeutralPose", withExtension: "dae")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let child = scene.rootNode.childNodes[0]
        scnNode.addChildNode(child)
        
        setColor()
    }
}

import PlaygroundSupport

extension PlatformLock: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [color.message]
    }
}

