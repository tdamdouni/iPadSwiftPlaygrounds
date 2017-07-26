//  WorldNodes.swift
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
    /// Each `WorldNode` describes it's own actions.
    func placeAction(withDuration duration: TimeInterval) -> SCNAction
    func removeAction(withDuration duration: TimeInterval) -> SCNAction
}

// `Item` may only be applied to class types because it holds an
// ObjC reference type (`scnNode`), which would break copy-on-write semantics.
public protocol Item: class, Animatable, CustomDebugStringConvertible {
    static var identifier: WorldNodeIdentifier { get }
    
    weak var world: GridWorld? { get set }
    
    var node: NodeWrapper { get }
    
    /// If the node has been added to a `GridWorld` the node will be
    /// suffixed with a unique index. This index is used to encode nodes when
    /// sending and receiving commands.
    var worldIndex: Int { get set }
    
    /// The amount of offset to the top of the item when stacking. 
    /// e.g. Blocks stack with 0.5 verticalOffset.
    var verticalOffset: SCNFloat { get }
    
    /// Determines if the item can stacked on itself and other items.
    var isStackable: Bool { get }
    
    /// Determines if the item can be vertically displaced.
    var isLevelMoveable: Bool { get }
    
    /// Used to defer the loading of underlying geometry.
    /// This may be called multiple times, it's important to 
    /// check if the geometry needs to be reloaded.
    func loadGeometry()
}

// MARK: Internal Protocols

protocol NodeConstructible {
    init?(node: SCNNode)
}

protocol Toggleable {
    func setActive(_ active: Bool, animated: Bool)
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
            #if DEBUG
            if let world = world {
                let height = world.height(at: coordinate)
                if !height.isClose(to: newValue.y) && !isLevelMoveable {
                    log(message: "Warning: \(self.dynamicType) setting \(newValue.y) != \(height)")
                }
            }
            #endif
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
    
    var level: Int {
        return Int(round(position.y / WorldConfiguration.levelHeight))
    }
    
    public var isStackable: Bool {
        return false
    }
    
    public var isLevelMoveable: Bool {
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
    /*
     [
     <WorldNodeIdentifier>,
     <WorldIndex>,
     <Position>,
     <Rotation>
     ]
     */
    public var baseMessage: [PlaygroundValue] {
        return [
            .string(identifier.rawValue),
            .integer(worldIndex),
            position.message,
            rotation.message,
        ]
    }
}

extension Item {
    public var debugDescription: String {
        let coordinateDescription = " at: " + coordinate.description
        let suffix = world == nil ? " (not in world)" : ""
        return "<\(worldIndex)> " + (scnNode.name ?? "") + coordinateDescription + suffix
    }
}

extension Item {
    /// Restore animatable state of the SCNNode.
    func reset() {
        scnNode.opacity = 1.0
        scnNode.scale = SCNVector3(x: 1, y: 1, z: 1)
    }
    
    public func placeAction(withDuration duration: TimeInterval) -> SCNAction {
        scnNode.opacity = 0.0
        return .fadeIn(withDuration: duration)
    }
    
    public func removeAction(withDuration duration: TimeInterval) -> SCNAction {
        return .fadeOut(withDuration: duration)
    }
}

// MARK: NodeWrapper

/// NodeWrapper provides a level of abstraction over SCNNode so that
/// interaction with the node must be routed through the world building API.
public class NodeWrapper {
    private let backingNode: SCNNode
    
    init(_ node: SCNNode) {
        backingNode = node
    }
    
    init(identifier: WorldNodeIdentifier) {
        backingNode = identifier.makeNode()
    }
}
