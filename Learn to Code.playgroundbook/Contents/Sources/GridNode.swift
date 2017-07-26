//
//  GridNode.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

class GridNode {
    
    /// The index appended to every node when it is added to the world.
    /// 0 is reserved for the GridNode.
    private var runningIndex = 1
    
    let scnNode: SCNNode

    private var itemsForCoordinate = [Coordinate: [Item]]()
    
    var itemsById = [Int: Item]()
    
    /// All items that are contained in the world and those which will be placed.
    /// Items are ordered and accessible by their `worldIndex`.
    var allItems: [Item] {
        return Array(itemsById.values)
    }
    
    //Returns all items contained currently within the grid
    var allItemsInGrid: [Item] {
        var x = [Item]()
        for (_, items) in itemsForCoordinate {
            x += items
        }
        return x
    }
    
    /// A special coordinate which groups nodes that move between coordinates (actors for now).
    private let dynamicCoordinate = Coordinate(column: -1, row: -1)
    
    var actors: [Actor] {
        let dynamicNodes = itemsForCoordinate[dynamicCoordinate] ?? []
        
        return dynamicNodes.flatMap { node in
            if let actor = node as? Actor where node.isInWorld {
                return actor
            }
            return nil
        }
    }
    
    init(node: SCNNode) {
        self.scnNode = node
        scnNode.name = GridNodeName
        
        // Ensure the node is not hidden.
        node.isHidden = false
    }
    
    init() {
        scnNode = SCNNode()
        scnNode.name = GridNodeName
    }
    
    // MARK: Item Accessors
    
    func nodes(at coordinate: Coordinate) -> [Item] {
        let nodes = nodesInWorld(at: coordinate)
        
        // Lazy removal of nodes NOT in the world.
        itemsForCoordinate[coordinate] = nodes
        
        return nodes + dynamicNodes(at: coordinate)
    }
    
    private func dynamicNodes(at coordinate: Coordinate) -> [Item] {
        let children = itemsForCoordinate[dynamicCoordinate] ?? []
        
        return children.filter {
            $0.isInWorld && $0.coordinate == coordinate
        }
    }
    
    // MARK: Add Item
    
    func addNode(_ child: Item, world: GridWorld) {
        let coordinate: Coordinate
        if child is Actor {
            coordinate = dynamicCoordinate
        }
        else {
            coordinate = Coordinate(child.position)
        }
        
        // Avoid adding the nodes twice.
        let nodes = itemsForCoordinate[coordinate] ?? []
        if !nodes.contains({ $0.scnNode == child.scnNode }) {
            itemsForCoordinate[coordinate] = nodes + [child]
        }

        // Ensure the world is correctly set on the child.
        child.world = world
        
        // Check if an index has already been assigned for this node. 
        // When rolling back changes it's important to replace the node
        // rather than creating a new one.
        if child.worldIndex < 0 {
            
            // Add a unique index to every node in the grid.
            child.worldIndex = runningIndex
            runningIndex += 1
        }
        
        // Set the child for the correct ID.
        itemsById[child.worldIndex] = child
        
        scnNode.addChildNode(child.scnNode)
    }
    
    // MARK: Removal
    
    func removeNodes(at coordinate: Coordinate) {
        for animatable in nodes(at: coordinate) {
            animatable.removeFromWorld()
        }
        itemsForCoordinate[coordinate] = []
    }
    
    /// Clears out items from the `GridNode` caches which are not currently
    /// in the world.
    func removeItemsNotInWorld() {
        let cachedIdItems = itemsById
        for (id, item) in cachedIdItems where !item.isInWorld {
            itemsById.removeValue(forKey: id)
        }
        
        let cachedItems = itemsForCoordinate
        for (coordinate, items) in cachedItems {
            var remainingItems = items
            for (index, item) in items.enumerated() where !item.isInWorld {
                remainingItems.remove(at: index)
            }
            
            itemsForCoordinate[coordinate] = remainingItems
        }
    }
    
    // MARK:
    
    /// Returns a `GridNode` with only the game marker nodes (no geometry).
    func copyMarkerNodes(world: GridWorld) -> GridNode {
        let grid = GridNode()
        
        for (_, nodes) in itemsForCoordinate {
            for node in nodes {
                let scnNodeCopy = node.scnNode.copy() as! SCNNode
                guard let item = NodeFactory.make(from: scnNodeCopy) else { continue }
                grid.addNode(item, world: world)
            }
        }
        
        return grid
    }
    
    // MARK: Convenience Methods
    
    /// Returns only the STATIC nodes contained in the world at the specified coordinate.
    private func nodesInWorld(at coordinate: Coordinate) -> [Item] {
        var children = itemsForCoordinate[coordinate] ?? []

        let allNodes = children
        for worldNode in allNodes where !worldNode.isInWorld {
            let index = children.index { $0.scnNode == worldNode.scnNode }
            children.remove(at: index!)
        }
        
        return children
    }
}
