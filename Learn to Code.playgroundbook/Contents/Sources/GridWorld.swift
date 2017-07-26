//
//  GridWorld.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

public class GridWorld {
    
    public var columnCount = 0
    
    public var rowCount = 0
    
    /// The node which all game nodes are added to (Blocks, Water, Gems, etc.)
    let grid: GridNode
    
    /// Indicates if adding/ removing additional `WorldNode`s should be animated.
    var isAnimated = false
    
    public var commandSpeed: Float = 1.0
    public let commandQueue = CommandQueue()
    
    public var placeStartMarkerUnderActor = true
    
    /**
     Returns all the possible coordinates (not accounting for those
     that may have been removed) within the grid.
     
     Set several times during key building phases of the world to ensure it's
     always up to date. 
     
     @see `calculateRowColumnCount()`
     */
    public var allPossibleCoordinates = [Coordinate]()
    
    public var successCriteria: GridWorldSuccessCriteria?
    
    // MARK: Initializers
    
    public init(columns: Int, rows: Int) {
        columnCount = columns
        rowCount = rows

        grid = GridNode()

        buildGridInScene()
        
        // Sets `allPossibleCoordinates`
        calculateRowColumnCount()
    }
    
    init(node: SCNNode) {
        grid = GridNode(node: node)
        
        // Map the node's children to `WorldNode`s.
        for child in node.childNodes {
            guard let item = NodeFactory.make(from: child) else {
                log(message: "Non-game node `\(child.name ?? "")` found in GridNode.")
                continue
            }
            // Set the world as these already exist in the GridWorld.
            grid.addNode(item, world: self)
        }
        
        // Calculate the row column count now that everything has been added.
        calculateRowColumnCount()
        
        // Link existing portals. 
        for portal in existingNodes(ofType: Portal.self, at: allPossibleCoordinates) {
            guard let connectingCoordinate = portal.scnNode.coordinateFromName else {
                log(message: "Failed to establish portal connection for: \(portal)")
                continue
            }
            
            let linkedPortal = existingNode(ofType: Portal.self, at: connectingCoordinate)
            portal.linkedPortal = linkedPortal
        }
    }
    
    func calculateRowColumnCount() {
        var maxColumn = 0
        var maxRow = 0
        for node in grid.allItems {
            if node.coordinate.row > maxRow {
                maxRow = node.coordinate.row
            }
            if node.coordinate.column > maxColumn {
                maxColumn = node.coordinate.column
            }
        }
        
        // +1 for zero based indices.
        columnCount = maxColumn + 1
        rowCount = maxRow + 1
        
        // Recalculate the possible coordinates as the column/row count may have changed.
        allPossibleCoordinates = coordinates(inColumns: 0..<columnCount, intersectingRows: 0..<rowCount)
    }
    
    // MARK: Item ID Accessors
    
    func item(forID index: Int) -> Item? {
        return items(from: [index]).first
    }
    
    func items(from indices: [Int]) -> [Item] {
        return indices.flatMap { index in
            return grid.itemsById[index]
        }
    }
    
    // MARK: Build Base
    
    func buildGridInScene() {
        // Place tiles in the root `grid`.
        for column in 0..<columnCount {
            let x = SCNFloat(column) * WorldConfiguration.coordinateLength
            
            for row in 0..<rowCount {
                let z = -SCNFloat(row) * WorldConfiguration.coordinateLength
                
                let block = Block()
                let position = SCNVector3(x: x, y: 0, z: z)
                place(block, at: Coordinate(position))
                block.position.y = 0 // Start the floor at zero.
            }
        }
        
        // Center the `grid` in the scene.
        let dx = -WorldConfiguration.coordinateLength * SCNFloat(columnCount - 1) / 2
        let dz = WorldConfiguration.coordinateLength * SCNFloat(rowCount - 1) / 2
        grid.scnNode.position = SCNVector3Make(dx, 0, dz)
    }
    
    func removeHiddenQuads() {
        let blocksRemoved = commandQueue.contains {
            // The `.remove(_:)` action is mapped to a `.pickUp` actor action.
            return $0.performer is GridWorld && $0.action.animation == .pickUp
        }
        guard !blocksRemoved else { return }
        
        for block in existingNodes(ofType: Block.self, at: allPossibleCoordinates) {
            block.removeHiddenQuads()
        }
    }
    
    // MARK: Node Verification

    /// Ensures that the world is configured correctly.
    func verifyNodePositions() {
        
        // Correct the height for every node currently in the scene.
        for coordinate in allPossibleCoordinates {
            percolateNodes(at: coordinate)
        }
        
        // Place a start marker under each actor.
        if placeStartMarkerUnderActor {
            for actor in existingNodes(ofType: Actor.self, at: allPossibleCoordinates) {
                guard existingNode(ofType: StartMarker.self, at: actor.coordinate) == nil else { continue }

                let marker = StartMarker(type: actor.type)
                place(marker, facing: actor.heading, at: actor.coordinate)
            }
        }
        
        // Make sure portals are not covered. 
        for portal in existingNodes(ofType: Portal.self) {
            removeTop(at: portal.coordinate)
        }
        
        // Remove blocks that conflict with water.
        for water in existingNodes(ofType: Water.self) {
            water.position.y = -WorldConfiguration.levelHeight
            
            for block in existingNodes(ofType: Block.self, at: [water.coordinate]) {
                block.removeFromWorld()
            }
        }
    }
    
    func removeRandomNodes() {
        let randomNodes = existingNodes(ofType: RandomNode.self, at: allPossibleCoordinates)
        if !randomNodes.isEmpty {
            remove(items: randomNodes)
        }
    }
    
    func percolateNodes(at coordinate: Coordinate) {
        let nodes = grid.nodes(at: coordinate)
        let contactHeight = height(at: coordinate)

        // Ignore the stackable nodes to avoid double stacking on top of the same nodes contact (Stair at 0.5 -> 1.0).
        for node in nodes where !node.isStackable && node.dynamicType != RandomNode.self {
            node.position.y = contactHeight + node.verticalOffset
        }
        
        // Move gems if actor is underneath.
        for gem in nodes.filter({ $0 is Gem }) {
            if nodes.contains({ $0 is Actor }) {
                gem.position.y = contactHeight + WorldConfiguration.gemDisplacement
            }
            else {
                gem.position.y = contactHeight
            }
        }
    }
    
    func addCommandToReplace(_ item: Item, atNewPosition newPosition: SCNVector3) {
        // Disabling the queue observers prevents a `RandomizedQueueObserver` from slipping a command in.
        let reports = commandQueue.reportsAddedCommands
        commandQueue.reportsAddedCommands = false
        
        // Add an atomic remove-place command combo to translate the actor.
        // This ordering is used by `GridWorld.perform(:)` to move the item.
        item.removeFromWorld()
        add(action: .move(from: item.position, to: newPosition))
        
        commandQueue.reportsAddedCommands = reports
    }
}

extension GridWorld {
    
    // MARK: World Probing
    
    /// Returns the first occurrence of the specified type at the coordinate.
    public func existingNode<Node: Item>(ofType type: Node.Type, at coordinate: Coordinate) -> Node? {
        return existingNodes(ofType: type, at: [coordinate]).first
    }
    
    /// Returns all nodes with the provided identifier that exist at the specified coordinates.
    public func existingNodes<Node: Item>(ofType type: Node.Type, at coordinates: [Coordinate]) -> [Node] {
        
        return coordinates.flatMap { coordinate -> [Node] in
            let candidateChildren = grid.nodes(at: coordinate)
            
            let nodes = candidateChildren.flatMap { node -> Node? in
                if node.dynamicType == type {
                    return node as? Node
                }
                return nil
            }
            
            return nodes
        }
    }
    
    public func existingNodes<Node: Item>(ofType type: Node.Type) -> [Node] {
        return existingNodes(ofType: type, at: allPossibleCoordinates)
    }
    
    /// Returns all nodes except the provided identifiers that exist at the specified coordinates.
    func excludingNodes<Node: Item>(ofTypes types: [Node.Type], at coordinates: [Coordinate]) -> [Item] {
        return coordinates.flatMap { coordinate -> [Item] in
            let candidateChildren = grid.nodes(at: coordinate)
            
            return candidateChildren.filter { child in
                return !types.contains {
                    $0 == child.dynamicType
                }
            }
        }
    }
    
    func excludingNodes<Node: Item>(ofType type: Node.Type, at coordinate: Coordinate) -> [Item] {
        return excludingNodes(ofTypes: [type], at: [coordinate])
    }
    
    // MARK: World Placement
    
    @discardableResult
    public func place(_ item: Item, facing: Direction, at coordinate: Coordinate) -> Item {
        item.rotation = facing.radians
        
        return place(item, at: coordinate)
    }

    /**
     Places the item into the world at the provided `coordinate`.
     */
    @discardableResult
    public func place(_ item: Item, at coordinate: Coordinate) -> Item {
        // Search for the top contact to stack this node on.
        let baseHeight = height(at: coordinate)
        let position = coordinate.position
        let newPosition = SCNVector3(position.x, baseHeight + item.verticalOffset, position.z)
        
        // If the item is already in the world, add a remove command to fade it out.
        if item.isInWorld && isAnimated {
            addCommandToReplace(item, atNewPosition: newPosition)
        }
        
        item.position = newPosition
        
        // Reset the node when it's added to the world. 
        item.reset()
        
        // Add the node directly to the world.
        grid.addNode(item, world: self)
        percolateNodes(at: coordinate)
        
        if isAnimated {
            add(action: .place([item.worldIndex]))
        }
        
        return item
    }
    
    /// Places a node of the specified type at the provided coordinates.
    @discardableResult
    public func place<Node: Item where Node: LocationConstructible>(nodeOfType type: Node.Type, facing: Direction = .south, at coordinates: [Coordinate]) -> [Node] {
        
        var nodes = [Node]()
        for coordinate in coordinates {
            let node = type.init()
            place(node, facing: facing, at: coordinate)
            nodes.append(node)
        }
        
        return nodes
    }
    
    /// Places a bidirectional portal into the world.
    public func place(_ portal: Portal, between start: Coordinate, and end: Coordinate) {
        place(portal, at: start)
        
        let linkedPortal = Portal(color: portal.color)
        place(linkedPortal, at: end)
        
        // Link the portals together. 
        portal.linkedPortal = linkedPortal
    }
    
    // MARK: Node Removal
    
    public func remove<T: Item>(_ item: T) {
        remove(items: [item])
    }
    
    public func remove<T: Item>(items: [T]) {
        if isAnimated {
            let indices = items.map { $0.worldIndex }
            add(action: .remove(indices))
        }
        else {
            // NOTE: This is called from Item `removeFromWorld()` so the `scnNode` needs to be accessed directly.
            for item in items {
                item.world = nil
                item.scnNode.removeFromParentNode()
            }
        }
    }
    
    /// Removes all nodes at the provided coordinates leaving a big hole in your world.
    public func removeNodes(at coordinates: [Coordinate]) {
        for coordinate in coordinates {
            for node in grid.nodes(at: coordinate) {
                node.removeFromWorld()
            }
        }
    }
    
    public func removeNodes(at coordinate: Coordinate) {
        removeNodes(at: [coordinate])
    }
    
    func removeTop(at coordinate: Coordinate, fadeDuration: Double = 0.0) {
        let fadeOut = SCNAction.fadeOut(withDuration: fadeDuration)
        let sequence = SCNAction.sequence([fadeOut, .removeFromParentNode()])
        
        let topNames = [
            "Top",
            "zon_floor_"
        ]
        
        for node in hitNodes(containingNames: topNames, at: coordinate) {
            node.run(sequence)
        }
    }
    
    // MARK: Hit Testing
    
    func hitNodes(containingNames nodeNames: [String], at coordinate: Coordinate) -> [SCNNode] {
        guard let rootNode = grid.scnNode.anscestorNode(named: "rootNode") else { return [] }
        let positionInWorld = rootNode.convertPosition(coordinate.position, from: grid.scnNode)
        
        // Probe slightly above and below the provided coordinate.
        var abovePosition = positionInWorld; abovePosition.y += 3
        var belowPosition = positionInWorld; belowPosition.y -= 3
        
        return rootNode.hitTestWithSegment(fromPoint: abovePosition, toPoint: belowPosition).flatMap { hit -> SCNNode? in
            let node = hit.node
            let name = node.name ?? ""
            
            for nodeName in nodeNames where name.contains(nodeName) {
                return node
            }
            
            for nodeName in nodeNames {
                if let child = node.childNode(withName: nodeName, recursively: true) {
                    return child
                }
            }
            return nil
        }
    }

    // MARK: Helper
    
    /// Checks if the coordinate is within the grid `dimensions`.
    func gridContains(coordinate: Coordinate) -> Bool {
        let isWithinGrid = coordinate.column < columnCount && coordinate.row < rowCount
        return isWithinGrid
    }
    
    /// Provided as a convenience to make changes to the world while easily
    /// configuring if the changes should/should not be animated.
    func applyChanges(animated: Bool = false, within changes: @noescape () -> Void) {
        let animating = isAnimated
        isAnimated = animated
        
        changes()
        
        isAnimated = animating
    }
}

extension GridWorld {
    
    // MARK: Coordinates
    
    /// Returns all coordinates contained in the specified columns.
    public func coordinates(inColumns columns: [Int]) -> [Coordinate] {
        return coordinates(inColumns: columns, intersectingRows: 0..<rowCount)
    }
    
    /// Returns all coordinates contained in the specified rows.
    public func coordinates(inRows rows: [Int]) -> [Coordinate] {
        return coordinates(inColumns: 0..<columnCount, intersectingRows: rows)
    }
    
    /**
     Returns the coordinates within the intersection between the specified columns and rows.
     
     Example usage:
     coordinatesBetween([0], rows: 0...2) // Returns (0,0), (0,1), (0,2)
     coordinatesBetween([1, 2], rows: [0, 3]) // Returns (1,0), (2,0), (1, 3), (2,3)
     */
    public func coordinates<Rows: Sequence, Columns: Sequence where Rows.Iterator.Element == Int, Columns.Iterator.Element == Int >(inColumns columns: Columns, intersectingRows rows: Rows) -> [Coordinate] {
        
        let columns = columns.filter { $0 >= 0 && $0 < columnCount }
        let rows = rows.filter { $0 >= 0 && $0 < rowCount }
        
        return rows.flatMap { row -> [Coordinate] in
            return columns.map { column in
                Coordinate(column: column, row: row)
            }
        }
    }
    
    func height(at coordinate: Coordinate) -> SCNFloat {
        let nodes = grid.nodes(at: coordinate).flatMap { item -> SCNNode? in
            if item.isStackable {
                return item.scnNode
            }
            return nil
        }
        
        let topNode = nodes.max { n1, n2 in
            n1.position.y < n2.position.y
        }
        
        return topNode?.position.y ?? -WorldConfiguration.levelHeight
    }
}

extension GridWorld {
    
    // MARK: Convenience Methods
    
    /**
    Method that returns the gems present on an array of given coordinates.
    */
    public func existingGems(at coordinates: [Coordinate]) -> [Gem] {
        return existingNodes(ofType: Gem.self, at: coordinates)
    }
    
    // MARK: Mass Placement
    
    /**
    Method that places multiple blocks into the puzzle world using an array of coordinates.
    */
    @discardableResult
    public func placeBlocks(at coordinates: [Coordinate]) -> [Block] {
        return place(nodeOfType: Block.self, at: coordinates)
    }
    
    /**
    Method that places multiple water tiles into the puzzle world using an array of coordinates.
    */
    @discardableResult
    public func placeWater(at coordinates: [Coordinate]) -> [Water] {
        return place(nodeOfType: Water.self, at: coordinates)
    }
    
    /**
    Method that places multiple gems into the puzzle world using an array of coordinates.
    */
    @discardableResult
    public func placeGems(at coordinates: [Coordinate]) -> [Gem] {
        return place(nodeOfType: Gem.self, at: coordinates)
    }

    // MARK: Non-Coordinate placement
    
    /**
    Method that places an item into the puzzle world.
    */
    public func place(_ item: Item, atColumn column: Int, row: Int) {
        self.place(item, at: Coordinate(column: column, row: row))
    }
    
    public func place(_ item: Item, facing: Direction, atColumn column: Int, row: Int) {
        self.place(item, facing: facing, at: Coordinate(column: column, row: row))
    }
    
    /**
    Method that places a portal into the puzzle world.
    */
    public func place(_ portal: Portal, atStartColumn: Int, startRow: Int, atEndColumn: Int, endRow: Int) {
        self.place(portal, between: Coordinate(column: atStartColumn, row: startRow), and: Coordinate(column: atEndColumn, row: endRow))
    }
    
    /**
    Method that removes all items from a specific coordinate on the puzzle world.
    */
    public func removeItems(atColumn column: Int, row: Int)  {
        self.removeNodes(at: Coordinate(column: column, row: row))
    }
    
    // MARK:
    
    /**
    Method that returns the top block on a stack of block.
    */
    public func topBlock(at coordinate: Coordinate) -> Block? {
        return existingNodes(ofType: Block.self, at: [coordinate]).max { b1, b2 in
            b1.position.y < b2.position.y
        }
    }
}

// MARK: Performer

extension GridWorld: Performer, PerformerDelegate {
    
    var id: Int {
        // 0 is reserved for the `GridWorld`. 
        return 0
    }
    
    func applyStateChange(for action: Action) {
        switch action {
        case .place(let indices):
            applyChanges {
                for item in items(from: indices) {
                    item.reset()
                    grid.addNode(item, world: self)
                    percolateNodes(at: item.coordinate)
                }
            }
            
        case .remove(let indices):
            applyChanges {
                for item in items(from: indices) {
                    item.removeFromWorld()
                    percolateNodes(at: item.coordinate)
                }
            }
            
        case let .move(from, to):
            // Find nodes that were removed to then move.
            // Directly tied to `place(:at:)`.
            // Note: This would be much cleaner if each item was a Performer which
            // could handle it's own movement.
            
            // Find the index of the command (it may be reversed).
            let index = commandQueue.index(of: Command(performer: self, action: action)) ??
                        commandQueue.index(of: Command(performer: self, action: action.reversed))
            
            let previousIndex = (index ?? 0) - 1
            guard commandQueue.indices.contains(previousIndex) else {
                return
            }
            
            let previousCommand = commandQueue[previousIndex]
            if case let .remove(ids) = previousCommand.action {
                for item in items(from: ids) {
                    item.position = to
                }
                
                percolateNodes(at: Coordinate(from))
                percolateNodes(at: Coordinate(to))
            }
            
        case let .toggle(id, isActive):
            guard let toggleable = item(forID: id) as? Toggleable else { break }
            toggleable.setActive(isActive, animated: false)
            
        default:
            break
        }
    }
    
    func perform(_ action: Action) {
        var duration = Double(1.0 / commandSpeed)

        switch action {
        case .place(let indices):
            for item in items(from: indices) {
                // Add the node to the actual Grid. 
                applyChanges {
                    place(item, at: item.coordinate)
                }
                
                // Make sure the geometry is fully loaded.
                item.loadGeometry()
                
                let node = item.scnNode
                node.run(item.placeAction(withDuration: duration))
                
                // Percolate nodes up to ensure proper ordering.
                percolateNodes(at: item.coordinate)
            }
            
        case .remove(let indices):
            for item in items(from: indices) {
                let node = item.scnNode
                
                let remove = item.removeAction(withDuration: duration)
                node.run(.sequence([remove, .removeFromParentNode()]))
                
                // Mark the node as removed from the world so percolation can take place immediately.
                item.world = nil
                percolateNodes(at: item.coordinate)
            }
        
        case .move(_):
            // Immediately move the item (currently only used for `addCommandToReplace(:atNewPosition:)`.
            duration = 0
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = duration
            applyStateChange(for: action)
            SCNTransaction.commit()
            
        case let .toggle(id, isActive):
            guard let toggleable = item(forID: id) as? Toggleable else {
                fatalError("No `Toggleable` exists for id: \(id)")
            }
            // Use a shorter duration for the toggle behavior so randomization is quick.
            duration /= 2
            toggleable.setActive(isActive, animated: true)
            
        default:            
            #if DEBUG
            assertionFailure("GridWorld \(self) has been asked to handle \(action) which it cannot perform.")
            #endif
            break
        }
        
        dispatch_after(seconds: duration + 0.1) { [unowned self] in
            self.performerFinished(self)
        }
    }
    
    func cancel(_ action: Action) {
        switch action {
        case .place(let indices):
            for item in items(from: indices) {
                item.scnNode.removeAllActions()
            }
            
        case .remove(let indices):
            for item in items(from: indices) {
                item.scnNode.removeAllActions()
            }
            
        default:
            break
        }
    }
    
    /// Convenience to create an `Command` by bundling in `self` with the provided action.
    func add(action: Action, applyingState: Bool = true) {
        let command = Command(performer: self, action: action)
        
        commandQueue.append(command, applyingState: applyingState)
    }

    // MARK: PerformerDelegate
    
    func performerFinished(_ performer: Performer) {
        precondition(Thread.isMainThread())
        guard commandQueue.runMode == .continuous else { return }
        
        // Run the next action.
        commandQueue.runNextCommand()
    }
}

extension GridWorld: CustomDebugStringConvertible {
    
    public var debugDescription: String {
        return "(\(columnCount), \(rowCount)) \(unsafeAddress(of: self)) - \(grid.allItems.count) items"
    }
}

public let CriteriaAll = -1

public struct GridWorldSuccessCriteria {
    let collectedGems: Int
    let openedSwitches: Int
    
    public init() {
        self.init(gems: CriteriaAll, switches: CriteriaAll)
    }
    
    public init(gems: Int, switches: Int) {
        collectedGems = gems
        openedSwitches = switches
    }
}
