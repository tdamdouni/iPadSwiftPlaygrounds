// 
//  BlockNode.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public final class Block: Item, LocationConstructible, NodeConstructible {
    
    // MARK: Static 
    
    /// The world pattern is based on `blockCount` repeating blocks.
    static let patternCount = 8
    
    static let topName = "Top"
    
    static let wallTemplates: [SCNNode] = {
        guard let blockURLs = Bundle.main().urlsForResources(withExtension: "dae", subdirectory: WorldConfiguration.resourcesDir + "blocks") else { return [] }
        
        return blockURLs.flatMap { url -> SCNNode? in
            // "zon_block_a_" blocks are blocks with removable faces.
            guard let fileName = url.lastPathComponent where fileName.hasPrefix("zon_block_half_") else { return nil }
            let scene = try? SCNScene(url: url, options: nil)
            guard let baseNode = scene?.rootNode.childNodes.first else { return nil }
            
            baseNode.name = fileName // Files have been renamed, ensure the node matches.
            baseNode.position.y -= WorldConfiguration.levelHeight // Block offset from DAE file.
            
            return baseNode
        }
    }()
    
    static let topTemplate: SCNNode = {
        let path = WorldConfiguration.customDir + "floor_template"
        let topURL = Bundle.main().urlForResource(path, withExtension: "dae")!
        let scene = try! SCNScene(url: topURL, options: nil)
        return scene.rootNode.childNodes.first!
    }()
    
    static let topTextures: [NSURL] = {
        let bundle = Bundle.main()
        let commonTopTextures = [
            "zon_floor_grass_a_DIFF",
            "zon_floor_grass_b_DIFF",
            "zon_floor_grass_d_DIFF",
            "zon_floor_grass_e_DIFF",
            "zon_floor_sand_a_DIFF",
            "zon_floor_sand_b_DIFF",
            "zon_floor_sand_c_DIFF",
        ]
        
        let pathPrefix = WorldConfiguration.resourcesDir + "textures/"
        return commonTopTextures.flatMap {
            bundle.urlForResource(pathPrefix + $0, withExtension: "png")
        }
    }()
    
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
    
    public var worldIndex = -1
    
    // MARK: Properties
    
    public var isStackable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        return WorldConfiguration.levelHeight
    }
    
    lazy var texturesForDirection: [Direction: URL] = {
        let textureURLs = Bundle.main().urlsForResources(withExtension: "png", subdirectory: WorldConfiguration.resourcesDir + "textures") ?? []
        let tileTextures = textureURLs.filter {
            $0.lastPathComponent?.hasPrefix("zon_block_a_rock_DIFF_") ?? false
        }
        
        var urlForDirection = [Direction: URL]()
        for dir in Direction.all {
            let textureLevel = Block.levelFromName(for: self.scnNode) % Block.patternCount
            let suffix = "u\(textureLevel)_v\(dir.index + 1).png"
            guard let url = tileTextures.filter({ $0.lastPathComponent!.hasSuffix(suffix) }).first else { continue }
            
            urlForDirection[dir] = url
        }
        
        return urlForDirection
    }()
    
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
        
        let top = Block.topTemplate.clone()
        top.name = Block.topName
        randomizeTileTexture(topNode: top)
        scnNode.addChildNode(top)
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
        
        guard let wallsForLevel = Block.wallGeo(forLevel: level) else { return }
        wallsForLevel.eulerAngles.y = rotationDirection * rotationMagnitude
        scnNode.addChildNode(wallsForLevel)
    }
    
    func removeHiddenQuads() {
        guard let world = world else { return }
        guard let wallsNode = scnNode.childNodes.first else { return }
        
        let levelHeight = SCNFloat(level) * WorldConfiguration.levelHeight
        
        // Surrounding heights in order N, S, E, W.
        let surroundingHeights = coordinate.neighboringCoordinates.map {
            world.topBlock(at: $0)?.position.y ?? -1
        }
        
        let facesToRemove = Direction.all.filter {
            surroundingHeights[$0.index] > (levelHeight - 1e-3)
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
    
    func randomizeTileTexture(topNode: SCNNode) {
        guard let geoCopy = topNode.createUniqueFirstGeometry() else { return }
        guard let material = geoCopy.firstMaterial?.copy() as? SCNMaterial else { return }
        
        let count = UInt32(Block.topTextures.count)
        let randTextureIndex = Int(arc4random_uniform(count))
        
        let topImage = Block.topTextures[randTextureIndex]
        material.diffuse.contents = topImage
        geoCopy.firstMaterial = material
        topNode.geometry = geoCopy
        
        let randOrientation = SCNFloat(arc4random_uniform(UInt32(4)))
        topNode.rotation = SCNVector4(0, 1, 0, (π / 2.0) * randOrientation)
    }
}

import PlaygroundSupport

extension Block: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage)
    }
}


