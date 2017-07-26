// 
//  Platform.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import PlaygroundSupport

public final class Platform: Item, NodeConstructible {
    // MARK: Static
    
    static let template: SCNNode = {
        let node = Asset.node(named: "zon_prop_platform_a", in: .item(.platform))!
        // Offset in container. 0.005 less than the levelHeight to avoid z-fighting when in water.
        node.position.y = -(WorldConfiguration.levelHeight - 0.005)
        
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .platform
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    public var isStackable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        // Offset by `WorldConfiguration.levelHeight` to have 0 sit at water level.
        return (SCNFloat(startingLevel) * WorldConfiguration.levelHeight) - WorldConfiguration.levelHeight
    }
    
    var glyphNode: SCNNode? {
        return scnNode.childNode(withName: "zon_prop_platformSign_a_GEO", recursively: true)
    }
    
    private var glyphMaterial: SCNMaterial? {
        return glyphNode?.geometry?.firstMaterial
    }
    
    // MARK: Properties
    
    let startingLevel: Int
    
    var color: Color? {
        didSet {
            setColor()
        }
    }
    
    var isLowerable: Bool {
        let stackingItems = world?.existingItems(at: coordinate).filter {
            return $0.isStackable
        } ?? []
        
        // Do not lower the platform if there is a block or other "stackable" item
        // directly below it.
        return !stackingItems.contains(where: { $0.height == height - 1 })
    }
    
    public weak var lock: PlatformLock? = nil {
        didSet {
            guard let lock = lock else { return }
            
            // Configure the reverse connection to the lock.
            lock.add(self)
            
            setColor()
        }
    }
    
    public convenience init(onLevel level: Int = 2, controlledBy lock: PlatformLock) {
        self.init(onLevel: level)
        
        self.lock = lock

        // Configure the reverse connection.
        lock.add(self)
    }
    
    /// Creates a new platform.
    /// Providing a `level` will specify where the Platform starts.
    /// Level 2 positions the platform on top of blocks. 
    public init(onLevel level: Int = 2) {
        self.startingLevel = max(level, 0)
        node = NodeWrapper(identifier: .platform)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .platform else { return nil }
        self.startingLevel = Int(round(node.position.y / WorldConfiguration.levelHeight))
        
        self.node = NodeWrapper(node)
    }
    
    // MARK: Methods
    
    func raise(over duration: TimeInterval = 0) {
        animateMovement(duration: duration, up: true)
    }
    
    func lower(over duration: TimeInterval = 0) -> Bool {
        guard isLowerable else { return false }
        
        animateMovement(duration: duration, up: false)
        
        // Successfully able to move the platform down.
        return true
    }
    
    private func animateMovement(duration: TimeInterval, up: Bool) {
        guard let world = world else { return }
        let sign: SCNFloat = up ? 1 : -1
        let displacement = sign * WorldConfiguration.levelHeight
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        // Move "stackable" items stacked on top of the platform.
        for item in world.existingItems(at: coordinate) where item.isStackable {
            if item.height > height {
                item.position.y += displacement
            }
        }
        
        // Displace the platform.
        position.y += displacement
        
        // Move other the items on top of the platform.
        world.percolateNodes(at: coordinate)

        SCNTransaction.commit()
    }
    
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
        glyphMaterial?.diffuse.contents = color?.rawValue ?? lock?.color.rawValue
        
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

extension Platform: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        let index = lock?.id ?? Identifier.undefined
        return [.integer(startingLevel), .integer(index)]
    }
}
