//
//  Portal.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

fileprivate enum PortalShape {
    case circle
    case square
    case star
    case triangle
    
    func geometrySCNFileName()-> String {
        switch  self {
        case .circle:   return "portal_circle_on"
        case .square:   return "portal_square_on"
        case .star:     return "portal_star_on"
        case .triangle: return "portal_triangle_on"
        }
    }
    
    static func allShapes()-> [PortalShape] {
        return [.circle, .square, .star, .triangle]
    }
}

public final class Portal: Item, NodeConstructible {
    
    // MARK: Static
    private static var currentPortalShapeIndex: Int = 0
    
    private static func nextShape()-> PortalShape {
        if Portal.currentPortalShapeIndex >= PortalShape.allShapes().count {
            Portal.currentPortalShapeIndex = 0
        }
        let returnIndex = Portal.currentPortalShapeIndex
        Portal.currentPortalShapeIndex += 1
        return PortalShape.allShapes()[returnIndex]
    }
    
    static var directory: Asset.Directory {
        return .item(identifier)
    }
    
    static let portalAnimation: CAAnimation = {
        return Asset.animation(named: "portal_animation", in: directory)!
    }()
    
    
    // MARK: Private
    
    private var particlesNode:SCNNode?
    private static let activateEnterKey = "PortalEnter-Key"
    private static let activateExitKey = "PortalExit-Key"
    private static let portalMainSCNFile = "portal_main"
    private static let portalCustomNodeName = "eyeGEO_01_poka" // This is the node to look for in the customized scn files.
    private static let outerGlowNodeName = "OuterGlow"
    private static let dialNodeName = "dialGEO01_01_poka"
    private static let portalParticlesNodeName = "portal_particles"
    
    private var animationNode: SCNNode {
        return scnNode.childNode(withName: "CHARACTER_Portal", recursively: true) ?? scnNode
    }
    
    // If the Portal is initalized via the public initializer API, it's being placed in the world atop existing geometry which is now atlased, and needs a vertical displacement.
    private let shouldVerticallyDisplacePosition: Bool
    private let verticalPositionDisplacementValue = Float(0.008)
    
    private var applyColorToNodes:((_ color: UIColor)->())? = nil // a block called everytime color is set. Used to set node material color values.
    
    private var shape: PortalShape? {
        didSet {
            setShape()
        }
    }
    
    // MARK: Properties
    
    public var linkedPortal: Portal? {
        didSet {
            // Automatically set the reverse link.
            linkedPortal?.linkedPortal = self
            linkedPortal?.color = color
            if shape != nil {
                linkedPortal?.shape = shape
            }
            
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
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    
    // MARK: Initialization
    
    public init(color: Color) {
        self.color = color
        shouldVerticallyDisplacePosition = true
        self.node = NodeWrapper(identifier: .portal)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .portal else { return nil }
        self.color = .blue
        shouldVerticallyDisplacePosition = true
        self.node = NodeWrapper(node)
    }
    
    func enter(atSpeed speed: Float = 1.0, actorType: ActorType) {
        let animation = Portal.portalAnimation
        animation.speed = speed
        animation.beginTime = CACurrentMediaTime() + (TimeInterval(1.0 / speed) * actorType.portalEnterDelay)
        animation.startCompletionBlock = { [weak self] in
            self?.triggerArriveParticles()
        }
        animationNode.addAnimation(animation, forKey: Portal.activateEnterKey)
    }
    
    func exit(atSpeed speed: Float = 1.0, actorType: ActorType) {
        let animation = Portal.portalAnimation
        animation.speed = speed
        animation.beginTime = CACurrentMediaTime() + (TimeInterval(1.0 / speed) * actorType.portalExitDelay)
        animation.startCompletionBlock = { [weak self] in
            self?.triggerArriveParticles()
        }
        animationNode.addAnimation(animation, forKey: Portal.activateExitKey)
    }
    
    // MARK: Setters
    
    func setColor() {
        // The color representing the portal's active and inactive states.
        let activeColor: Color = isActive ? self.color : .gray
        applyColorToNodes?(activeColor.rawValue)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        shape = Portal.nextShape()
    }
    
    fileprivate func triggerArriveParticles() {
        guard
            let pSystems = particlesNode?.particleSystems,
            pSystems.count > 0  else { return }
        
        //TODO: fix crash here:  pSystems[0].reset()
    }
    
    
    func setShape() {
        for childNode in scnNode.childNodes {
            childNode.removeFromParentNode()
        }
        
        guard let shape = shape else { return }
        
        let portalRootNode = Asset.node(named: Portal.portalMainSCNFile, in: .item(.portal), fileExtension: "scn")!
        let shapeSceneRootNode = Asset.node(named: shape.geometrySCNFileName(), in: .item(.portal), fileExtension: "scn")!
        let shapeNode = shapeSceneRootNode.childNode(withName: Portal.portalCustomNodeName, recursively: true)!
        
        portalRootNode.addChildNode(shapeNode)
        
        self.applyColorToNodes  =  { [unowned self] appliedColor in
            let ringNode = portalRootNode.childNode(withName: Portal.outerGlowNodeName, recursively: true)!
            let dialNode = portalRootNode.childNode(withName: Portal.dialNodeName, recursively: true)!
            let mainParticlesNode = portalRootNode.childNode(withName: Portal.portalParticlesNodeName, recursively: true)!
            
            shapeNode.geometry?.materials[0].multiply.contents = appliedColor
            ringNode.geometry?.materials[0].multiply.contents = appliedColor
            dialNode.geometry?.materials[0].multiply.contents = appliedColor
            mainParticlesNode.particleSystems?[0].particleColor = appliedColor
        }
        
        portalRootNode.enumerateHierarchy { node, _ in
            node.castsShadow = true
        }
        
        setColor()
        if let linkedPortal = linkedPortal, linkedPortal.shape != shape {
            linkedPortal.shape = shape
        }
        
        if shouldVerticallyDisplacePosition {
            var position = portalRootNode.position
            position.y = verticalPositionDisplacementValue
            portalRootNode.position = position
        }
        
        prepare([portalRootNode, shapeSceneRootNode]) { [unowned self] (successful) in
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0
            self.scnNode.addChildNode(portalRootNode)
            self.setColor()
            SCNTransaction.commit()
        }
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

extension ActorType {
    
    var portalEnterDelay: TimeInterval {
        return TimeInterval(0.1)
    }
    
    var portalExitDelay: TimeInterval {
        var delay: TimeInterval = 0
        
        switch self {
        case .expert:
            delay = 1.25
        case .byte, .octet:
            delay  = 1.45
        case .blu:
            delay = 1.19
        case .hopper:
            delay = 1.35
        }
        return delay
    }
}

