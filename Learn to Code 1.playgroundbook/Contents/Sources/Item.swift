// 
//  Item.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit
import PlaygroundSupport

/// A type which can be expressed with just a location and rotation upon placement.
public protocol LocationConstructible {
    init()
}

public protocol Animatable {
    func reset()
    
    /// Each `Item` describes it's own actions.
    func placeAction(withDuration duration: TimeInterval) -> SCNAction
    func removeAction(withDuration duration: TimeInterval) -> SCNAction
}

// MARK: Identifiable

public typealias ItemID = Int

enum Identifier {
    static let undefined = -1
    static let world = 0
}

public protocol Identifiable {
    /// A unique identifier that is used to describe items when
    /// sending and receiving commands.
    var id: ItemID { get }
}

// `Item` may only be applied to class types because it holds an
// ObjC reference type (`scnNode`), which would break copy-on-write semantics.
public protocol Item: class, Animatable, Identifiable, CustomDebugStringConvertible {
    static var identifier: WorldNodeIdentifier { get }
    
    var id: ItemID { get set }
    
    weak var world: GridWorld? { get set }
    
    var node: NodeWrapper { get }
    
    /// The amount of offset to the top of the item when stacking. 
    /// e.g. Blocks stack with 0.5 verticalOffset.
    var verticalOffset: SCNFloat { get }
    
    /// Determines if the item can stacked on itself and other items.
    var isStackable: Bool { get }
    
    /// A description of the item suitable for VoiceOver.
    var speakableDescription: String { get }
    
    /// Used to defer the loading of underlying geometry.
    /// This may be called multiple times, it's important to 
    /// check if the geometry needs to be reloaded.
    func loadGeometry()
}

// MARK: Internal Protocols

/// NodeConstructible refines Performer to allow nodes to be
/// moved after they have been placed in the world.
protocol NodeConstructible: Performer {
    init?(node: SCNNode)
}

protocol Controllable {
    /// Returns the duration of the requested state change.
    @discardableResult
    func setState(_ state: Bool, animated: Bool) -> TimeInterval
}

// MARK: Extensions

extension Item {
    
    var identifier: WorldNodeIdentifier {
        return Self.identifier
    }
    
    var isInWorld: Bool {
        return world != nil && scnNode.parent != nil
    }
    
    /// Internal access to underlying `SCNNode`.
    var scnNode: SCNNode {
        return node.backingNode
    }
    
    var position: SCNVector3 {
        get {
            return scnNode.position
        }
        set {
            scnNode.position = newValue
        }
    }
    
    /// Manually calculate the rotation to ensure `w` component is correctly calculated.
    var rotation: SCNFloat {
        get {
            return scnNode.rotation.y * scnNode.rotation.w
        }
        set {
            scnNode.rotation = SCNVector4(0, 1, 0, newValue)
        }
    }
    
    public var heading: Direction {
        return Direction(radians: rotation)
    }
    
    public var coordinate: Coordinate {
        return Coordinate(position)
    }
    
    public var height: Int {
        return Int(round(position.y / WorldConfiguration.levelHeight))
    }
    
    public var isStackable: Bool {
        return false
    }
    
    public var verticalOffset: SCNFloat {
        return 0
    }
    
    // MARK: Methods
    
    public func removeFromWorld() {
        world?.remove(self)
    }
}

extension Item {
    /**
     A message containing the minimum set of info necessary to
     describe an Item.
     
     [WorldNodeIdentifier, ItemID, Position, Rotation]
     */
    public var baseMessage: [PlaygroundValue] {
        return [
            .string(identifier.rawValue),
            .integer(id),
            position.message,
            rotation.message,
        ]
    }
}

extension Item {
    public var debugDescription: String {
        let name = scnNode.name ?? ""
        let coordinateDescription = "at: " + coordinate.description
        let suffix = isInWorld ? "" : "(not in world)"
        
        return "<\(id)> \(name) \(coordinateDescription) \(suffix)"
    }
}

extension Item {
    /// Restore animatable state of the SCNNode.
    public func reset() {
        scnNode.opacity = 1.0
        scnNode.scale = SCNVector3(x: 1, y: 1, z: 1)
    }
    
    public func placeAction(withDuration duration: TimeInterval) -> SCNAction {
        scnNode.opacity = 0.0
        return .fadeIn(duration: duration)
    }
    
    public func removeAction(withDuration duration: TimeInterval) -> SCNAction {
        return .fadeOut(duration: duration)
    }
}

// MARK: NodeWrapper

/// NodeWrapper provides a level of abstraction over SCNNode so that
/// interaction with the node must be routed through the world building API.
public class NodeWrapper {
    fileprivate let backingNode: SCNNode
    
    init(_ node: SCNNode) {
        backingNode = node
    }
    
    init(identifier: WorldNodeIdentifier) {
        backingNode = identifier.makeNode()
    }
}
