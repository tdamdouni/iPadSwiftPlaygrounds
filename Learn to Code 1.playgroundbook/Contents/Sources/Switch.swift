//
//  Switch.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import PlaygroundSupport

public final class Switch: Item, LocationConstructible, NodeConstructible {
    // MARK: Static Properties
    
    static let turnOnAnimation = Asset.animation(named: "SwitchOn", in: directory)!

    static let turnOffAnimation = Asset.animation(named: "SwitchOff", in: directory)!
    
    static let openSound = Asset.sound(named: "Switch_Open", in: .environmentSound)!
    
    static let closeSound = Asset.sound(named: "Switch_Close", in: .environmentSound)!
    
    static var directory: Asset.Directory {
        return .item(identifier)
    }
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .switch
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    /// Private state to allow updating the switch without animation. 
    /// @see `setState(on:animated:)`
    fileprivate var _isOn = false
    
    /// The state of the Switch.
    public var isOn: Bool {
        get {
            return _isOn
        }
        set {
            guard newValue != _isOn else { return }
            _isOn  = newValue
            
            if world?.isAnimated == true {
                let controller = Controller(identifier: id, kind: .toggle, state: isOn)
                world?.add(action: .control(controller))
            }
            else {
                setState(isOn, animated: false)
            }
        }
    }
    
    fileprivate let onKey = "Switch-On"
    fileprivate let offKey = "Switch-Off"
    
    fileprivate var animationNode: SCNNode? {
        return scnNode.childNode(withName: "CHARACTER_Switch", recursively: true)
    }
    
    private var lightNode: SCNNode? {
        return scnNode.childNode(withName: "pointLight1", recursively: true)
    }
    
    var idleParticles: SCNParticleSystem = {
        return SCNParticleSystem(named: "ConstantEmitter", inDirectory: Switch.directory.path)!
    }()
    
    var vortexParticles: SCNNode = {
        guard let particles = Asset.node(named: "OpenParticles", in: Switch.directory, fileExtension: "scn") else {
            fatalError("Failed to find `OpenParticles` for Switch.")
        }
        return particles
    }()
    
    // MARK: Initializers
    
    public convenience init(open: Bool = false) {
        self.init()
        isOn = open
    }
    
    public init() {
        node = NodeWrapper(identifier: .switch)
    }
    
    init?(node: SCNNode) {
        guard let identifier = node.identifier, identifier == .switch else { return nil }
        self.node = NodeWrapper(node)
    }
    
    public func toggle() {
        isOn = !isOn
    }

    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        let firstChild = Asset.neutralPose(in: .item(.switch))!
        firstChild.position.y = 0.02
        
        firstChild.enumerateHierarchy { node, _ in
            node.castsShadow = false
        }
        
        // Add a random rotation (so all Switches don't look the same).
        firstChild.rotation = SCNVector4(x: 0, y: 1, z: 0, w: SCNFloat(randomInt(from: 0, to: 40) % 4) * π / 2)
        
        scnNode.addChildNode(firstChild)
        
        // Warm up the `Switch` animations. 
        let _ = Switch.turnOnAnimation
        let _ = Switch.turnOffAnimation
        
        // Apply the animation now that the node has loaded.
        setState(isOn, animated: false)
        lightNode?.light?.categoryBitMask = WorldConfiguration.characterLightBitMask
    }
    
    public func reset() {
        vortexParticles.removeFromParentNode()
        scnNode.removeAllParticleSystems()
    }
}

extension Switch: Controllable {
    // MARK: Controllable
    
    @discardableResult
    func setState(_ state: Bool, animated: Bool) -> TimeInterval {
        // Update the state of the switch.
        _isOn = state
        
        // If not animated, set the speed so that state change does not appear animated,
        // but we need the correct NeutralPose.
        let speed = animated ? Actor.commandSpeed : Float.infinity
        
        let animation: CAAnimation
        if _isOn {
            animation = Switch.turnOnAnimation
            animation.speed = speed

            var group: [SCNAction] = [
                .animate(with: animation, forKey: onKey, removeOnCompletion: false),
            ]
            
            // Add a vortex particle effect and audio if animated.
            if animated {
                Switch.openSound.rate = speed
                group += [
                    .playSoundEffect(Switch.openSound),
                    vortexAction(duration: animation.runDuration)
                ]
            }
            
            animationNode?.runAction(.group(group)) { [unowned self] in
                self.scnNode.addParticleSystem(self.idleParticles)
            }
        }
        else {
            animation = Switch.turnOffAnimation
            animation.speed = speed

            animationNode?.addAnimation(animation, forKey: offKey)
            
            if animated {
                Switch.closeSound.rate = speed
                animationNode?.runAction(.playSoundEffect(Switch.closeSound))
            }
            
            reset()
        }
        
        return animation.runDuration
    }
    
    func vortexAction(duration: TimeInterval) -> SCNAction {
        let addVortexParticles = SCNAction.run { node in
            node.addChildNode(self.vortexParticles)
        }
        
        let removeVortexParticles = SCNAction.run { node in
            self.vortexParticles.removeFromParentNode()
        }
        
        return SCNAction.sequence([
            .wait(duration: duration / 2),
            addVortexParticles,
            .wait(duration: duration / 2),
            removeVortexParticles
        ])
    }
}

extension Switch: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.boolean(isOn)]
    }
}
