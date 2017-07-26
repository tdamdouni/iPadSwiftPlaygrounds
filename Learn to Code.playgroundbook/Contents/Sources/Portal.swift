// 
//  Portal.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class Portal: Item, Toggleable, NodeConstructible {
    // MARK: Static
    
    static let enterAnimation: CAAnimation = {
        return loadAnimation(WorldConfiguration.portalDir + "PortalEnter")!
    }()
    
    static let exitAnimation: CAAnimation = {
        return loadAnimation(WorldConfiguration.portalDir + "PortalExit")!
    }()
    
    // MARK: Private
    
    private let activateKey = "PortalActivation-Key"
    
    private var animationNode: SCNNode {
        return scnNode.childNode(withName: "CHARACTER_PortalA", recursively: true) ?? scnNode
    }
    
    private var colorMaterials: [SCNMaterial] {
        return [
            "glyphGEO", "diskGEO", "eyebrowGEO", "cupGEO",
            "portalFlareGEO", "outerFlareGEO",
            "crackGlowGEO1", "crackGlowGEO2", "crackGlowGEO3", "crackGlowGEO4", "crackGlowGEO5", "crackGlowGEO6"
        ].flatMap { nodeName -> SCNMaterial? in
            return scnNode.childNode(withName: nodeName, recursively: true)?.firstGeometry?.firstMaterial
        }
    }
    
    // MARK: Properties
    
    public var linkedPortal: Portal? {
        didSet {
            // Automatically set the reverse link.
            linkedPortal?.linkedPortal = self
            linkedPortal?.color = color
            
            if let coordinate = linkedPortal?.coordinate {
                scnNode.setName(forCoordinate: coordinate)
            }
        }
    }

    /// Tracks the state of the portal seperate from its animation.
    private var _isActive = true
    
    /// The state of the portal. Active by default.
    public var isActive: Bool {
        get {
            return _isActive
        }
        set {
            guard _isActive != newValue else { return }
            _isActive = newValue
            
            linkedPortal?.isActive = isActive
            
            if world?.isAnimated == true {
                world?.add(action: .toggle(toggleable: worldIndex, active: isActive))
            }
            else {
                setActive(isActive, animated: false)
            }
        }
    }
    
    public var color: Color {
        didSet {
            setColor()
        }
    }
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .portal
    
    public weak var world: GridWorld? {
        didSet {
            if let world = world {
                // Remove tops of blocks where the portal will be.
                world.removeTop(at: coordinate)
            }
            else {
                // Add the top back when removing the portal.
                let topBlock = oldValue?.topBlock(at: coordinate)
                topBlock?.addTop()
            }
        }
    }
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    // MARK: Initialization
    
    public init(color: Color) {
        self.color = color
        node = NodeWrapper(identifier: .portal)
        
//        lightNode?.light?.categoryBitMask = WorldConfiguration.characterLightBitMask
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .portal else { return nil }
        self.color = .blue
        self.node = NodeWrapper(node)
        
        let loadedColor = colorMaterials.first?.emission.contents as? _Color ?? _Color.blue()
        self.color = Color(loadedColor)
    }
    
    func enter(atSpeed speed: Float = 1.0) {
        let animation = Portal.enterAnimation
        animation.speed = speed
        animationNode.add(animation, forKey: activateKey)
    }
    
    func exit(atSpeed speed: Float = 1.0) {
        let animation = Portal.exitAnimation
        animation.speed = speed
        animationNode.add(animation, forKey: activateKey)
    }
    
    // MARK: Setters
    
    func setActive(_ active: Bool, animated: Bool) {
        _isActive = active
        
        let speed = Double(world?.commandSpeed ?? 1)
        let duration = animated ? 1 / speed : 0
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        setColor()
        SCNTransaction.commit()
    }
    
    func setColor() {
        // The color representing the portal's active and inactive states.
        let activeColor: Color = isActive ? self.color : .gray

        for material in colorMaterials {
            material.diffuse.contents = activeColor.rawValue
        }
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        let switchURL = Bundle.main().urlForResource(WorldConfiguration.portalDir + "NeutralPose", withExtension: "dae")!
        
        guard let scene = try? SCNScene(url: switchURL, options: nil) else { return }
        let firstChild = scene.rootNode.childNodes[0]
        firstChild.enumerateHierarchy { node, _ in
            node.castsShadow = false
        }
        
        scnNode.addChildNode(firstChild)
        setColor()
    }
}

import PlaygroundSupport

extension Portal: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.boolean(isActive), color.message]
    }
}

