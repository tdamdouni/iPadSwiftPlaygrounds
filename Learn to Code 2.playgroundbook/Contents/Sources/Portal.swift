//
//  Portal.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import PlaygroundSupport

public final class Portal: Item, NodeConstructible {
    // MARK: Static
    
    static var directory: Asset.Directory {
        return .item(identifier)
    }
    
    static let enterAnimation: CAAnimation = {
        return Asset.animation(named: "PortalEnter", in: directory)!
    }()
    
    static let exitAnimation: CAAnimation = {
        return Asset.animation(named: "PortalExit", in: directory)!
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
    fileprivate var _isActive = true
    
    /// State of the portal. An active portal transports a character that moves onto it, while an inactive portal does not. Portals are active by default.
    public var isActive: Bool {
        get {
            return _isActive
        }
        set {
            guard _isActive != newValue else { return }
            _isActive = newValue
            
            linkedPortal?.isActive = isActive
            
            if world?.isAnimated == true {
                let controller = Controller(identifier: id, kind: .activate, state: isActive)
                world?.add(action: .control(controller))
            }
            else {
                setState(isActive, animated: false)
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
    
    public var id = Identifier.undefined
    
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
        
        let loadedColor = colorMaterials.first?.emission.contents as? _Color ?? _Color.blue
        self.color = Color(loadedColor)
    }
    
    func enter(atSpeed speed: Float = 1.0) {
        let animation = Portal.enterAnimation
        animation.speed = speed
        animationNode.addAnimation(animation, forKey: activateKey)
    }
    
    func exit(atSpeed speed: Float = 1.0) {
        let animation = Portal.exitAnimation
        animation.speed = speed
        animationNode.addAnimation(animation, forKey: activateKey)
    }
    
    // MARK: Setters
    
    func setColor() {
        // The color representing the portal's active and inactive states.
        let activeColor: Color = isActive ? self.color : .gray

        for material in colorMaterials {
            material.diffuse.contents = activeColor.rawValue
        }
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        let firstChild = Asset.neutralPose(in: .item(.portal))!
        firstChild.enumerateHierarchy { node, _ in
            node.castsShadow = false
        }
        
        scnNode.addChildNode(firstChild)
        setColor()
    }
}

extension Portal: Controllable {
    // MARK: Controllable
    
    @discardableResult
    func setState(_ state: Bool, animated: Bool) -> TimeInterval {
        _isActive = state
        
        let speed = Double(GridWorld.commandSpeed)
        let duration = animated ? 1 / speed : 0
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        setColor()
        SCNTransaction.commit()
        
        return duration
    }
}

extension Portal: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.boolean(isActive), color.message]
    }
}

