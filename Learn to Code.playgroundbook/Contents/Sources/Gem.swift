// 
//  Gem.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class Gem: Item, LocationConstructible, NodeConstructible {
    
    // MARK: Static
    
    static let moveKey = "MoveGem"
    static let spinKey = "Spin"
    
    static var template: SCNNode = {
        let gemPath = WorldConfiguration.gemDir + "NeutralPose"
        let url = Bundle.main().urlForResource(gemPath, withExtension: "scn")!
        
        let scene = try! SCNScene(url: url, options: nil)
        return scene.rootNode.childNodes[0]
    }()
    
    static var popEmitter: SCNNode = {
        let popAnimationPath = WorldConfiguration.gemDir + "PopAnimation"
        let url = Bundle.main().urlForResource(popAnimationPath, withExtension: "scn")!
        
        let scene = try! SCNScene(url: url, options: nil)
        let node = scene.rootNode.childNodes[0]
        node.position.y += 0.2
        
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .item
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    public var isLevelMoveable: Bool {
        return true
    }
    
    // MARK: Initialization
    
    public init() {
        node = NodeWrapper(identifier: .item)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .item else { return nil }
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
        let wait = SCNAction.wait(forDuration: halfDuration)
        let scale = SCNAction.scale(to: 0.0, duration: halfDuration / 2)
        let wait2 = SCNAction.wait(forDuration: halfDuration / 2)

        let emitterNode = Gem.popEmitter
        let emitterDuration = CGFloat(halfDuration)

        let system = emitterNode.particleSystems![0]
        system.emissionDuration = emitterDuration
        system.birthRate = emitterDuration
        system.particleLifeSpan = emitterDuration
        
        scnNode.addChildNode(emitterNode)

        guard let innerGeo = scnNode.childNodes.first else {
            log(message: "Failed to find inner geo for gem: \(self).")
            return
        }
        
        innerGeo.run(.sequence([wait, scale, wait2])) { [unowned self] _ in
            self.scnNode.removeFromParentNode()
            
            // Restore the node.
            emitterNode.removeFromParentNode()
            innerGeo.scale = SCNVector3Make(1, 1, 1)
        }
    }
    
    func move(up: Bool, withDuration duration: TimeInterval) {
        guard let world = world else { return }

        // Ensure starting position of the gem is correct.
        let height = world.height(at: coordinate)
        let startHeight = up ? height : height + WorldConfiguration.gemDisplacement
        let endHeight = up ? height + WorldConfiguration.gemDisplacement : height
        
        guard !duration.isLessThanOrEqualTo(0.0) else {
            // If the `duration` is <= 0, move the gem immediately and remove existing animations.
            scnNode.removeAction(forKey: Gem.moveKey)
            position.y = endHeight
            return
        }
        
        let deltaY = CGFloat(endHeight - startHeight)
        let duration = duration / 1.5
        let move = SCNAction.moveBy(x: 0, y: deltaY, z: 0, duration: duration)
        
        let bounceDelta: CGFloat = up ? 0.1 : -0.1
        let bounceDuration = duration / 6
        let bounce1 = SCNAction.moveBy(x: 0, y: bounceDelta, z: 0, duration: bounceDuration)
        let bounce2 = SCNAction.moveBy(x: 0, y: -bounceDelta, z: 0, duration: bounceDuration)
        bounce2.timingMode = up ? .easeOut : .easeIn
        
        let delay = up ? 0 : duration / 6
        scnNode.run(.sequence([.wait(forDuration: delay), move, bounce1, bounce2]), forKey: Gem.moveKey)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        let gem = Gem.template.clone()
        scnNode.addChildNode(gem)
        
        scnNode.add(.spinAnimation(), forKey: Gem.spinKey)
    }
    
    // MARK: Animations
    
    public func placeAction(withDuration duration: TimeInterval) -> SCNAction {
        scnNode.scale = SCNVector3Zero
        scnNode.opacity = 0.0
        
        return .group([.scale(to: 1.0, duration: duration), .fadeIn(withDuration: duration)])
    }
}

import PlaygroundSupport

extension Gem: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}

