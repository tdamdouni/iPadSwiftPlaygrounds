//
//  Block.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

public final class Block: Item, LocationConstructible, NodeConstructible {
    
    // MARK: Static 
    
    /// The world pattern is based on `blockCount` repeating blocks.
    static let patternCount = 8
    
    static let topName = "Top"
    
    static let wallTemplates: [SCNNode] = {
        let blocksDir = Asset.Directory.item(.block).path
        guard let blockURLs = Bundle.main.urls(forResourcesWithExtension: "scn", subdirectory: blocksDir) else { return [] }
        
        return blockURLs.flatMap { url -> SCNNode? in
            // blocks scenes prefixed with "zon_block_half" contain removable faces.
            let fileName = url.lastPathComponent
            guard fileName.hasPrefix("zon_block_half_") else { return nil }
            let scene = try? SCNScene(url: url, options: nil)
            guard let baseNode = scene?.rootNode else { return nil }
            
            baseNode.name = fileName // Files have been renamed, ensure the node matches.
            baseNode.position.y -= WorldConfiguration.levelHeight // Block offset from DAE file.
            baseNode.enumerateHierarchy { child, _ in
                child.castsShadow = true
            }
            
            return baseNode
        }
    }()
    
    
    static let commonTopSceneNames = [
        "floor_grass_a",
        "floor_grass_b",
        "floor_grass_c",
        "floor_grass_d",
        "floor_grass_e",
        "floor_sand_a",
        "floor_sand_b",
        "floor_sand_c",
        ]
    
    static func rootNode(sceneNamed: String) -> SCNNode? {
        return Asset.node(named: sceneNamed, in: .floor , fileExtension: "scn")
    }
    
    static func wallGeo(forLevel level: Int) -> SCNNode? {
        let wrappedLevel = level % patternCount
        let index = wallTemplates.index {
            levelFromName(for: $0) == wrappedLevel
        }
        guard let templateIndex = index else { return nil }
        let template = wallTemplates[templateIndex].clone()

        // The base is made of two half blocks.
        if level == 0, let base = wallGeo(forLevel: patternCount - 1) {
            base.position.y = -WorldConfiguration.levelHeight
            base.rotation = SCNVector4Zero
            template.addChildNode(base)
        }
        
        return template
    }
    
    static func levelFromName(for node: SCNNode) -> Int {
        let name = node.name ?? ""
        for i in 1...Block.patternCount where name.contains("_v\(i)") {
            return i - 1 // Offset by -1 for 0 based indexing.
        }
        
        return -1
    }
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .block
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    // MARK: Properties
    
    public var isStackable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        return WorldConfiguration.levelHeight
    }
    
    // Only blocks which were initialized directly (not from an existing node) require geometry.
    let needsGeometry: Bool
    
    public init() {
        node = NodeWrapper(identifier: .block)
        needsGeometry = true
    }
    
    init?(node: SCNNode) {
        // Support maps exported with blocks named "Tile".
        guard node.identifier == .block
            || node.identifierComponents.first == "Tile" else { return nil }
        
        node.name = WorldNodeIdentifier.block.rawValue
        self.node = NodeWrapper(node)
        needsGeometry = false
    }
    
    public func loadGeometry() {
        guard needsGeometry && scnNode.childNodes.isEmpty else { return }
        
        addPatterenedGeo()
        
        // Only add a top to the top block.
        if self === world?.topBlock(at: coordinate) {
            addTop()
        }
    }

    func addTop() {
        // Avoid adding a second top.
        guard scnNode.childNode(withName: Block.topName, recursively: false) == nil else { return }

        let count = UInt32(Block.commonTopSceneNames.count)
        let randTopIndex = Int(arc4random_uniform(count))
        guard let topNode = Block.rootNode(sceneNamed: Block.commonTopSceneNames[randTopIndex]) else { return }
        
        let randOrientation = SCNFloat(arc4random_uniform(UInt32(4)))
        let yRotation = (π / 2.0) * randOrientation
        topNode.eulerAngles = SCNVector3(x: 90.toRadians, y: yRotation, z: 0)
        topNode.name = Block.topName
        
        scnNode.addChildNode(topNode)
    }
    
    func removeTop() {
        scnNode.childNode(withName: Block.topName, recursively: true)?.removeFromParentNode()
    }
    
    private func addPatterenedGeo() {
        guard let world = world else { return  }
        
        scnNode.rotation = SCNVector4Zero
        // Clear previous children.
        for child in scnNode.childNodes {
            child.removeFromParentNode()
        }
        
        // Describes the patterning rotation offset based on the coordinate.
        let coordinateOffset = world.rowCount - 1 // 0 offset at min x, z.
        let row = coordinate.row
        let col = coordinate.column
        
        let rotationDirection: SCNFloat
        if row > (coordinateOffset - col) {
            rotationDirection = 1.0
        } else {
            rotationDirection = -1.0
        }
        
        let a = SCNFloat(abs(row - coordinateOffset))
        let b = SCNFloat(col) + a
        let c = b * π
        let d = c / 2.0
        
        // π offset for underworld to match.
        let rotationMagnitude = d + π
        
        guard let wallForLevel = Block.wallGeo(forLevel: height) else { return }
        wallForLevel.eulerAngles.y = rotationDirection * rotationMagnitude
        scnNode.addChildNode(wallForLevel)
    }
    
    func removeHiddenQuads() {
        guard let world = world else { return }
        guard let wallsNode = scnNode.childNodes.first else { return }
        
        let level = SCNFloat(height) * WorldConfiguration.levelHeight
        
        // Surrounding heights in order N, S, E, W.
        let surroundingHeights = coordinate.neighbors.map {
            world.topBlock(at: $0)?.position.y ?? -1
        }
        
        let facesToRemove = Direction.all.filter {
            surroundingHeights[$0.index] > (level - 1e-3)
        }
        
        // Note this must be called after the node has been added to the `Block`
        removeFaces(from: wallsNode, in: facesToRemove)
    }
    
    private func removeFaces(from node: SCNNode, in directions: [Direction]) {
        let rotatedDirections = directions.map { dir -> Direction in
            let rotation = node.eulerAngles.y
            return Direction(radians: dir.radians - rotation)
        }
        
        // If the root block has child block's (like the base) remove the faces.
        for _ in 0..<node.childNodes.count {
            for direction in rotatedDirections {
                switch direction {
                case .north:
                    node.childNode(withName: "side_u3_GEO", recursively: true)?.removeFromParentNode()
                    
                case .south:
                    node.childNode(withName: "side_u1_GEO", recursively: true)?.removeFromParentNode()
                    
                case .east:
                    node.childNode(withName: "side_u2_GEO", recursively: true)?.removeFromParentNode()
                    
                case .west:
                    node.childNode(withName: "side_u4_GEO", recursively: true)?.removeFromParentNode()
                }
            }
        }
    }
    
}

extension Block: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}


