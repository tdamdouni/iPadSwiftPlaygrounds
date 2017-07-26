//
//  Gem.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

public final class Gem: Item, LocationConstructible, NodeConstructible {
    // MARK: Static
    
    static let moveKey = "MoveGem"
    static let spinKey = "Spin"
    
    static var template = Asset.neutralPose(in: .item(.gem), fileExtension: "scn")!
    
    static var popEmitter: SCNParticleSystem = {
        let node = Asset.node(named: "PopAnimation", in: .item(.gem), fileExtension: "scn")!
        return node.particleSystems![0]
    }()
    
    static let collectSound = Asset.sound(named: "GemTouch", in: .environmentSound)!
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .gem
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    var animationNode: SCNNode? {
        return scnNode.childNodes.first
    }
    
    // MARK: Initialization
    
    public init() {
        node = NodeWrapper(identifier: .gem)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .gem else { return nil }
        self.node = NodeWrapper(node)
    }
    
    /// Animates the removal of the gem from the world.
    func collect(withDuration animationDuration: TimeInterval) {
        guard isInWorld else {
            log(message: "Attempting to collect a gem \(self) which is not in a world.")
            return
        }
        
        // Remove the gem from the world immediately.
        world = nil
        
        let halfDuration = animationDuration / 2
        
        let emitter = Gem.popEmitter
        emitter.particleLifeSpan = CGFloat(halfDuration)
        emitter.emissionDuration = CGFloat(halfDuration)
        emitter.birthRate = 1
        emitter.loops = false
        emitter.particleVelocity = 0.5
        scnNode.addParticleSystem(emitter)
        
        Gem.collectSound.rate = Actor.commandSpeed
        
        let shrinkGem: [SCNAction] = [
            .wait(duration: halfDuration),
            .playSoundEffect(Gem.collectSound),
            .scale(to: 0.0, duration: halfDuration / 2),
            .wait(duration: halfDuration)
        ]
        
        animationNode?.runAction(.sequence(shrinkGem)) { [unowned self] in
            self.scnNode.removeAllParticleSystems()
            self.scnNode.removeFromParentNode()
            
            // Restore the animationNode.
            self.animationNode?.scale = SCNVector3Make(1, 1, 1)
        }
    }
    
    func move(up: Bool, withDuration duration: TimeInterval) {
        guard let world = world else { return }

        // Ensure starting position of the gem is correct.
        let height = world.nodeHeight(at: coordinate)
        let startHeight = up ? height : height + WorldConfiguration.gemDisplacement
        let endHeight = up ? height + WorldConfiguration.gemDisplacement : height
        
        guard !duration.isLessThanOrEqualTo(0.0) else {
            // If the `duration` is <= 0, move the gem immediately and remove existing animations.
            scnNode.removeAction(forKey: Gem.moveKey)
            position.y = endHeight
            return
        }
        
        let deltaY = CGFloat(endHeight - startHeight)
        let duration = duration / 1.8
        let move = SCNAction.moveBy(x: 0, y: deltaY, z: 0, duration: duration)
        
        let bounceDelta: CGFloat = up ? 0.1 : -0.1
        let bounceDuration = duration / 6
        let bounce1 = SCNAction.moveBy(x: 0, y: bounceDelta, z: 0, duration: bounceDuration)
        let bounce2 = SCNAction.moveBy(x: 0, y: -bounceDelta, z: 0, duration: bounceDuration)
        bounce2.timingMode = up ? .easeOut : .easeIn
        
        let delay = up ? 0 : duration / 6
        scnNode.runAction(.sequence([.wait(duration: delay), move, bounce1, bounce2]), forKey: Gem.moveKey)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        let gem = Gem.template.clone()
        
        scnNode.addChildNode(gem)
    }
    
    // MARK: Animations
    
    public func reset() {
        scnNode.opacity = 1.0
        scnNode.scale = SCNVector3(x: 1, y: 1, z: 1)
        
        animationNode?.scale = SCNVector3Make(1, 1, 1)
        animationNode?.removeAllActions()
        
        scnNode.removeAllParticleSystems()
    }
    
    public func placeAction(withDuration duration: TimeInterval) -> SCNAction {
        scnNode.scale = SCNVector3Zero
        scnNode.opacity = 0.0
        
        return .group([.scale(to: 1.0, duration: duration), .fadeIn(duration: duration)])
    }
}

extension Gem: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

