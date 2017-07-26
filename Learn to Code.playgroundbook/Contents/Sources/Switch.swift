//
//  Switch.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class Switch: Item, Toggleable, LocationConstructible, NodeConstructible {
    // MARK: Static

    static let turnOnAnimation: CAAnimation = {
        let animation = loadAnimation(WorldConfiguration.switchDir + "SwitchOn")!
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        return animation
    }()
    
    static let turnOffAnimation: CAAnimation = {
        let animation = loadAnimation(WorldConfiguration.switchDir + "SwitchOff")!
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        return animation
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .switch
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    private var animationSpeed: Float {
        return world?.commandSpeed ?? 1
    }
    
    /// Private state to allow updating the switch without animation. 
    /// @see `setState(on:animated:)`
    private var _isOn = false
    
    /// The state of the Switch.
    public var isOn: Bool {
        get {
            return _isOn
        }
        set {
            guard newValue != _isOn else { return }
            _isOn  = newValue
            
            if world?.isAnimated == true {
                world?.add(action: .toggle(toggleable: worldIndex, active: isOn))
            }
            else {
                setActive(isOn, animated: false)
            }
        }
    }
    
    private let onKey = "Switch-On"
    private let offKey = "Switch-Off"
    
    private var animationNode: SCNNode? {
        return scnNode.childNode(withName: "CHARACTER_Switch", recursively: true)
    }
    
    private var lightNode: SCNNode? {
        return scnNode.childNode(withName: "pointLight1", recursively: true)
    }
    
    public convenience init(open: Bool = false) {
        self.init()
        isOn = open
    }
    
    public init() {
        node = NodeWrapper(identifier: .switch)
    }
    
    init?(node: SCNNode) {
        guard let identifier = node.identifier where identifier == .switch else { return nil }
        self.node = NodeWrapper(node)
    }
    
    public func toggle() {
        isOn = !isOn
    }
    
    func setActive(_ active: Bool, animated: Bool) {
        // Update the state of the switch.
        _isOn = active
        
        // 1000 so that the state change does not appear animated,
        // but we need the correct NeutralPose.
        let speed = animated ? animationSpeed : 1000
        
        if active {
            let animation = Switch.turnOnAnimation
            animation.speed = speed
            animationNode?.add(animation, forKey: onKey)
        }
        else {
            let animation = Switch.turnOffAnimation
            animation.speed = speed
            animationNode?.add(animation, forKey: offKey)
        }
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        let switchURL = Bundle.main().urlForResource(WorldConfiguration.switchDir + "NeutralPose", withExtension: "dae")!
        
        guard let scene = try? SCNScene(url: switchURL, options: nil) else { return }
        let firstChild = scene.rootNode.childNodes[0]
        firstChild.position.y = 0.02
        
        firstChild.enumerateHierarchy { node, _ in
            node.castsShadow = false
        }
        
        // Add a random rotation (so all Switches don't look the same).
        firstChild.rotation = SCNVector4(x: 0, y: 1, z: 0, w: SCNFloat(random() % 4) * π / 2)
        
        scnNode.addChildNode(firstChild)
        
        // Warm up the `Switch` animations. 
        let _ = Switch.turnOnAnimation
        let _ = Switch.turnOffAnimation
        
        // Apply the animation now that the node has loaded.
        setActive(isOn, animated: false)
        lightNode?.light?.categoryBitMask = WorldConfiguration.characterLightBitMask
    }
}

import PlaygroundSupport

extension Switch: MessageConstructor {

    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.boolean(isOn)]
    }
}
