//
//  Switch.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

public final class Switch: Item, LocationConstructible, NodeConstructible {
    // MARK: Static Properties
    
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
    
    fileprivate var switchOnNode: SCNNode?
    fileprivate var switchOffNode: SCNNode!
    fileprivate var switchContainerNode = SCNNode()
    
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
        let switchRoot  = Asset.neutralPose(in: .item(.switch), fileExtension: "scn")!
        
        switchOnNode = switchRoot.childNode(withName: "switch_poka_ON", recursively: false)
        switchOffNode = switchRoot.childNode(withName: "switch_poka_OFF", recursively: false)
        
        switchContainerNode.position.y = 0.02
        
        // Add a random rotation (so all Switches don't look the same).
        switchContainerNode.rotation = SCNVector4(x: 0, y: 1, z: 0, w: SCNFloat(randomInt(from: 0, to: 40) % 4) * π / 2)
        
        scnNode.addChildNode(switchContainerNode)
        
        // Apply the animation now that the node has loaded.
        setState(isOn, animated: false)
    }
    
}

extension Switch: Controllable {
    // MARK: Controllable
    
    @discardableResult
    func setState(_ state: Bool, animated: Bool) -> TimeInterval {
        // Update the state of the switch.
        _isOn = state
        
        let switchAction: SCNAction = .run { [weak self] _ in
            // pick correct geo for current state.
            if let onNode = self?.switchOnNode,
                let offNode = self?.switchOffNode,
                let _isOn = self?._isOn,
                let switchContainerNode = self?.switchContainerNode {
                (_isOn ? offNode : onNode).removeFromParentNode()
                switchContainerNode.addChildNode(_isOn ? onNode : offNode)
            }
        }
        
        
        // If not animated, set the speed so that state change does not appear animated,
        let speed = animated ? Actor.commandSpeed : Float.infinity
        let animationDelay = TimeInterval(animated ? 1.2/speed : 0)
        let waitAction = SCNAction.wait(duration: animationDelay)
        
        let animation: CAAnimation
        if animated  {
            
            if _isOn {
                Switch.openSound.rate = speed
                let action: SCNAction = .sequence([waitAction,
                                                   .group([switchAction,
                                                           .playSoundEffect(Switch.openSound)])])
                switchContainerNode.runAction(action)
            }
            else {
                Switch.closeSound.rate = speed
                let action: SCNAction = .sequence([waitAction,
                                                   .group([switchAction,
                                                           .playSoundEffect(Switch.closeSound)])])
                switchContainerNode.runAction(action)
            }
        }
        else {
            switchContainerNode.runAction(switchAction)
        }
        return animationDelay
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
