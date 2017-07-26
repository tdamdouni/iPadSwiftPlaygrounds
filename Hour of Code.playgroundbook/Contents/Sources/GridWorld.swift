//
//  GridWorld.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import SceneKit

/**
 GridWorld contains all methods and properties of the puzzle world itself. This includes methods such as `place(item:at:)` and `removeItems(at:)` as well as properties such as `allPossibleCoordinates`.
*/
public class GridWorld {
    // MARK: Types
    public typealias AssessmentHandler = () -> Bool
    
    /// The final conditions which define a successful run of the `GridWorld`.
    public enum SuccessCriteria {
        /// All switches are left open, and all gems have been collected.
        case all
        
        /// A count of collected Gems, and a count of switches left open.
        case count(collectedGems: Int, openSwitches: Int)
        
        /// A function used to evaluate page specific assessment.
        case pageSpecific(AssessmentHandler)
    }
    
    // MARK: Static Properties
    
    static var commandSpeed: Float = WorldConfiguration.Scene.possibleSpeeds[0]

    // MARK: Properties

    public var successCriteria: SuccessCriteria = .all
    
    public var columnCount = 0
    
    public var rowCount = 0
    
    /// The node which all game nodes are added to (Blocks, Water, Gems, etc.)
    let grid: GridNode
    
    /// Indicates if adding/ removing additional `WorldNode`s should be animated.
    var isAnimated = false
    
    public var commandQueue = CommandQueue()
    
    /// Determines if a start marker should be placed under the actor. 
    /// (Only applies for actors who are placed during world construction).
    public var placeStartMarkerUnderActor = true
    
    /**
     Returns all the possible coordinates (not accounting for those
     that may have been removed) within the grid.
     
     Set several times during key building phases of the world to ensure it's
     always up to date. 
     
     @see `calculateRowColumnCount()`
     */
    public var allPossibleCoordinates = [Coordinate]()
    
    var components = [Performer]()
    fileprivate var result : PerformerResult?
    fileprivate let counterQueue = DispatchQueue(label: "components_counter_queue")
    fileprivate var activeComponents : Int = 0
    
    /// Indicates that any initial setup has been completed and any subsequent changes originated from learner code
    internal var worldBuildComplete : Bool = false

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
        for portal in existingItems(ofType: Portal.self, at: allPossibleCoordinates) {
            guard let connectingCoordinate = portal.scnNode.coordinateFromName else {
                log(message: "Failed to establish portal connection for: \(portal)")
                continue
            }
            
            let linkedPortal = existingItem(ofType: Portal.self, at: connectingCoordinate)
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
    
    // MARK: ItemID Accessors
    
    func item(forID index: ItemID) -> Item? {
        return items(from: [index]).first
    }
    
    func items(from indices: [ItemID]) -> [Item] {
        return indices.flatMap { index in
            return grid.itemsById[index]
        }
    }
    
    /// Convenience to create an `Command` by bundling in `self` with the provided action.
    func add(action: Action, applyingState: Bool = true) {
        let command = Command(performer: self, action: action)
        
        commandQueue.append(command, applyingState: applyingState)
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
            return $0.performer is GridWorld && $0.action.event == .pickUp
        }
        guard !blocksRemoved else { return }
        
        for block in existingItems(ofType: Block.self, at: allPossibleCoordinates) {
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
            for actor in existingItems(ofType: Actor.self, at: allPossibleCoordinates) {
                guard existingItem(ofType: StartMarker.self, at: actor.coordinate) == nil else { continue }

                let marker = StartMarker(type: actor.type)
                place(marker, facing: actor.heading, at: actor.coordinate)
            }
        }
        
        // Make sure portals are not covered. 
        for portal in existingItems(ofType: Portal.self) {
            removeTop(at: portal.coordinate)
        }
        
        // Remove blocks that conflict with water.
        for water in existingItems(ofType: Water.self) {
            water.position.y = -WorldConfiguration.levelHeight
            
            for block in existingItems(ofType: Block.self, at: [water.coordinate]) {
                block.removeFromWorld()
            }
        }
    }
    
    func removeRandomNodes() {
        let randomNodes = existingItems(ofType: RandomNode.self, at: allPossibleCoordinates)
        if !randomNodes.isEmpty {
            remove(items: randomNodes)
        }
    }
    
    func percolateNodes(at coordinate: Coordinate) {
        let items = existingItems(at: coordinate)
        let contactHeight = nodeHeight(at: coordinate)

        // Ignore the stackable nodes to avoid double stacking on top of the same nodes contact (Stair at 0.5 -> 1.0).
        for item in items where !item.isStackable && type(of: item) != RandomNode.self {
            item.position.y = contactHeight + item.verticalOffset
        }
        
        // Move gems if actor is underneath.
        for gem in items.filter({ $0 is Gem }) {
            if items.contains(where: { $0 is Actor }) {
                gem.position.y = contactHeight + WorldConfiguration.gemDisplacement
            }
            else {
                gem.position.y = contactHeight
            }
        }
    }
    
    /// Adds a command to remove the item from the world, a command to move the item 
    /// to the new position, and a command to rotate the item if necessary.
    func addCommandsToReplace(_ item: Item, newPosition: SCNVector3, newDirection: Direction?) {
        // Ignore the change if this item can't handle it.
        guard let performer = item as? Performer else { return }
        
        // Remove the item from the world.
        item.removeFromWorld()
        
        // Move the item to the new location.
        let dis = Displacement(from: item.position, to: newPosition)
        commandQueue.append(Command(performer: performer, action: .move(dis, type: .walk)))
        
        // Turn the item to the new direction.
        if let newDir = newDirection, newDir != item.heading {
            let dis = Displacement(from: item.rotation, to: newDir.radians)
            commandQueue.append(Command(performer: performer, action: .turn(dis, clockwise: false)))
        }
    }
    
    // MARK: CharacterPicker 
    
    /**
     The character picker is available when the `commandQueue` is finished
     (no pending commands remain), and there
     is only 1 actor in the world (additional experts are allowed).
     */
    func shouldShowPicker(from node: SCNNode) -> Bool {
        // Check that all commands have been processed/ received, and the queue is finished running them.
        let commandQueueIsReady = isFinishedProcessingCommands && commandQueue.isFinished
        
        let rootNode = node.anscestorNode(named: "Actor") ?? node
        
        // Filter out experts.
        let onlyActors = grid.actors.filter {
            return type(of: $0) == Actor.self
        }
        
        let isMainActor = onlyActors.first?.scnNode == rootNode
        
        return commandQueueIsReady
            && isMainActor
            && onlyActors.count == 1
    }

    func addComponent<T: Performer>(_ component: T) {
        // Remove any component of the same type.
        removeComponent(ofType: T.self)
        
        components.append(component)
    }

    func component<T : Performer>(ofType componentType: T.Type) -> T? {
        for component in components where component is T {
            return component as? T
        }
        return nil
    }

    @discardableResult
    func removeComponent<T : Performer>(ofType componentType: T.Type) -> T? {
        guard let index = components.index(where: { $0 is T }) else { return nil }
        
        let component = components.remove(at: index) as? T
        return component
    }
}

extension GridWorld: Performer {
    // MARK: Performer
    
    public var id: ItemID {
        return Identifier.world
    }
    
    func applyStateChange(for action: Action) {
        switch action {
        case .add(let indices):
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
            
        case let .control(contr):
            contr.setStateForItem(in: self, animated: false)
            
        default:
            break
        }
    }
    
    func perform(_ action: Action) -> PerformerResult {
        let duration = Double(1.0 / GridWorld.commandSpeed)

        switch action {
        case .add(let indices):
            for item in items(from: indices) where !item.isInWorld {
                // Add the node to the actual Grid via an unanimated call to `place(_:at:)`.
                applyChanges {
                    place(item, at: item.coordinate)
                }
                
                // Make sure the geometry is fully loaded.
                item.loadGeometry()
                
                let node = item.scnNode
                node.runAction(item.placeAction(withDuration: duration))
                
                // Percolate nodes up to ensure proper ordering.
                percolateNodes(at: item.coordinate)

                for component in components {
                    // Add/remove actions on the world may apply to multiple items. Only perform an action for the item being modified.
                    let singleAction = Action.add([item.id])
                    let componentResult = component.perform(singleAction)
                    counterQueue.sync { self.activeComponents += 1 }
                    componentResult.completionHandler = { [weak self] performer in
                        self?.performerFinished(performer)
                    }
                }
            }
            
        case .remove(let indices):
            for item in items(from: indices) {
                let node = item.scnNode
                
                let remove = item.removeAction(withDuration: duration)
                node.runAction(.sequence([remove, .removeFromParentNode()]))
                
                // Mark the node as removed from the world.
                item.world = nil
                for component in components {
                    // Add/remove actions on the world may apply to multiple items. Only perform an action for the item being modified.
                    let singleAction = Action.remove([item.id])
                    let componentResult = component.perform(singleAction)
                    counterQueue.sync { self.activeComponents += 1 }
                    componentResult.completionHandler = { [weak self] performer in
                        self?.performerFinished(performer)
                    }
                }
            }
            
        case let .control(contr):
            contr.setStateForItem(in: self, animated: true)
            
        default:
            #if DEBUG
            assertionFailure("GridWorld \(self) has been asked to handle \(action) which it cannot perform.")
            #endif
            break
        }
        
        result = PerformerResult.differed(self)
        counterQueue.sync { self.activeComponents += 1 }
        
        let extendedDuration = duration * 1.5
        DispatchQueue.main.asyncAfter(deadline: .now() + extendedDuration) {
            self.performerFinished(self)
        }
        
        return result!
    }

    func performerFinished(_ performer: Performer) {
        counterQueue.sync {
            self.activeComponents -= 1
            if self.activeComponents == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.result?.complete()
                }
            }
        }
    }
    
    func cancel(_ action: Action) {
        switch action {
        case .add(let indices):
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
}

extension GridWorld : AccessibilityComponentProtocol {
    func speakText(for command: Action) -> String {
        var text = ""

        switch command {
        case .add(let indices):
            for item in items(from: indices) {
                text.append(String(format: NSLocalizedString("Placed %@ at location %@", comment: "AX world description"), item.speakableDescription, item.coordinate.description))
            }

        case .remove(let indices):
            for item in items(from: indices) {
                text.append(String(format: NSLocalizedString("Removed %@ from location %@", comment: "AX world description"), item.speakableDescription, item.coordinate.description))
            }

        default:
            break
        }

        return text
    }

    func ignoreRequestToPerform(command: Action) -> Bool {
        return !worldBuildComplete
    }
}

extension GridWorld: CustomDebugStringConvertible {
    public var debugDescription: String {
        return "(\(columnCount), \(rowCount)) - \(grid.allItems.count) items"
    }
}

extension GridWorld {
    // MARK: World Probing
    
    public func existingGoals() -> (gems: [Gem], switches: [Switch]) {
        let gems = existingItems(ofType: Gem.self)
        let switches = existingItems(ofType: Switch.self)
        
        return (gems, switches)
    }
    
    /// Returns the Items present in at a given coordinate.
    public func existingItems(at coordinate: Coordinate) -> [Item] {
        return grid.nodes(at: coordinate)
    }
    
    /// Returns all existings items at any possible coordinate.
    public func existingItems<Child: Item>(ofType type: Child.Type) -> [Child] {
        return existingItems(ofType: type, at: allPossibleCoordinates)
    }
    
    /// Returns the first occurrence of the specified type at the coordinate.
    public func existingItem<Child: Item>(ofType type: Child.Type, at coordinate: Coordinate) -> Child? {
        return existingItems(ofType: type, at: [coordinate]).first
    }
    
    /// Returns all nodes with the provided identifier that exist at the specified coordinates.
    public func existingItems<Child: Item>(ofType type: Child.Type, at coordinates: [Coordinate]) -> [Child] {
        return coordinates.flatMap { coordinate -> [Child] in
            let candidateChildren = grid.nodes(at: coordinate)
            
            let nodes = candidateChildren.flatMap { node -> Child? in
                if type(of: node) == type {
                    return node as? Child
                }
                return nil
            }
            
            return nodes
        }
    }
    
    /// Returns all nodes except the provided identifiers that exist at the specified coordinates.
    func excludingNodes<Child: Item>(ofTypes types: [Child.Type], at coordinates: [Coordinate]) -> [Item] {
        return coordinates.flatMap { coordinate -> [Item] in
            let candidateChildren = grid.nodes(at: coordinate)
            
            return candidateChildren.filter { child in
                return !types.contains {
                    $0 == type(of: child)
                }
            }
        }
    }
    
    func excludingNodes<Node: Item>(ofType type: Node.Type, at coordinate: Coordinate) -> [Item] {
        return excludingNodes(ofTypes: [type], at: [coordinate])
    }
    
    // MARK: World Placement

    /**
     Method that places an item at a coordinate in the puzzle world.
     
     Example usage:
     ````
     place(Gem(), at: Coordinate(column: 3, row: 5))
     // Places an instance of type Gem at coordinate (3,5).
     ````
     
     - parameters:
        - item: Takes an input conforming to type `Item`, such as a `Gem`, `Switch`, `Character`, or `Expert`.
        - facing: Takes an enum value of type `Direction` including `.north`, `.south`, `.north`, or `.west`.
        - coordinate: Takes an instance of type `Coordinate` specifying a location in the puzzle world.
     */
    @discardableResult
    public func place(_ item: Item, facing: Direction? = nil, at coordinate: Coordinate) -> Item {
        // Search for the top contact to stack this node on.
        let baseHeight = nodeHeight(at: coordinate)
        let position = coordinate.position
        let newPosition = SCNVector3(position.x, baseHeight + item.verticalOffset, position.z)
        
        // If the item is already in the world, add a remove command to fade it out.
        if item.isInWorld && isAnimated {
            addCommandsToReplace(item, newPosition: newPosition, newDirection: facing)
        }
        
        item.position = newPosition
        if let newRot = facing?.radians {
            item.rotation = newRot
        }

        // Reset the node when it's added to the world.
        item.reset()
        
        // Add the node directly to the world.
        grid.addNode(item, world: self)
        percolateNodes(at: coordinate)
        
        if isAnimated {
            add(action: .add([item.id]))
        }
        
        return item
    }
    
    /**
     Method that places an item at an array of coordinates in the puzzle world.
     
     Example usage:
     ````
     place(Expert(), facing: .east, at: row(3))
     // Places an instance of type Expert facing east at each coordinate in row 3 of the puzzle world.
     ````
     
     - parameters:
        - item: Takes an input conforming to type `Item`, such as a `Gem`, `Switch`, `Character`, or `Expert`.
        - facing: Takes an enum value of type `Direction` including `.north`, `.south`, `.north`, or `.west`.
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    @discardableResult
    public func place<Node: Item>(nodeOfType type: Node.Type, facing: Direction = .south, at coordinates: [Coordinate]) -> [Node] where Node: LocationConstructible {
        
        var nodes = [Node]()
        for coordinate in coordinates {
            let node = type.init()
            place(node, facing: facing, at: coordinate)
            nodes.append(node)
        }
        
        return nodes
    }
    
    /**
     Method that places a bidirectional portal into the puzzle world.
     
     Example usage:
     ````
     place(Portal(color: .green), between: Coordinate(column: 2, row: 2), and: Coordinate(column: 4, row: 4))
     // Places a pair of portals, one at coordinate (2,2) and another at (4,4).
     ````
     - parameters:
        - portal: Takes an instance of type `Portal`.
        - start: Takes a `Coordinate` specifying the starting location the portal.
        - end: Takes a `Coordinate` specifying the ending location the portal.
     */
    public func place(_ portal: Portal, between start: Coordinate, and end: Coordinate) {
        place(portal, at: start)
        
        let linkedPortal = Portal(color: portal.color)
        place(linkedPortal, at: end)
        
        // Link the portals together. 
        portal.linkedPortal = linkedPortal
    }
    
    // MARK: Node Removal
    
    public func remove<Child: Item>(_ item: Child) {
        remove(items: [item])
    }
    
    public func remove<Child: Item>(items: [Child]) {
        if isAnimated {
            let indices = items.map { $0.id }
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
    
    /**
     Removes all items at the provided coordinates leaving a big hole in your world.
     
     Example usage:
     ````
     remove(at: allPossibleCoordinates)
     // Removes all items at every coordinate in the map.
     ````
     
     - parameters:
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    public func removeItems(at coordinates: [Coordinate]) {
        for coordinate in coordinates {
            for node in grid.nodes(at: coordinate) {
                node.removeFromWorld()
            }
        }
    }
    
    /**
     Removes all items at the provided coordinate leaving a big hole in your world.
     
     Example usage:
     ````
     remove(at: Coordinate(column: 3, row: 3))
     // Removes all items at coordinate (3,3).
     ````
     
     - parameters:
        - coordinate: Takes an instance of type `Coordinate` specifying a location in the puzzle world.
     */
    public func removeItems(at coordinate: Coordinate) {
        removeItems(at: [coordinate])
    }
    
    // MARK: Helper Methods

    func removeTop(at coordinate: Coordinate, fadeDuration: Double = 0.0) {
        let fadeOut = SCNAction.fadeOut(duration: fadeDuration)
        let sequence = SCNAction.sequence([fadeOut, .removeFromParentNode()])
        
        let topNames = [
            "Top",
            "zon_floor_"
        ]
        
        for node in hitNodes(containingNames: topNames, at: coordinate) {
            node.runAction(sequence)
        }
    }
    
    /// Returns the nodes matching the given `nodeNames` at the specified coordinate.
    func hitNodes(containingNames nodeNames: [String], at coordinate: Coordinate) -> [SCNNode] {
        guard let rootNode = grid.scnNode.anscestorNode(named: "rootNode") else { return [] }
        let positionInWorld = rootNode.convertPosition(coordinate.position, from: grid.scnNode)
        
        // Probe slightly above and below the provided coordinate.
        var abovePosition = positionInWorld; abovePosition.y += 3
        var belowPosition = positionInWorld; belowPosition.y -= 3
        
        return rootNode.hitTestWithSegment(from: abovePosition, to: belowPosition).flatMap { hit -> SCNNode? in
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
    
    /// Checks if the coordinate is within the grid `dimensions`.
    func gridContains(coordinate: Coordinate) -> Bool {
        let isWithinGrid = coordinate.column < columnCount && coordinate.row < rowCount
        let isPositive = coordinate.column >= 0 && coordinate.row >= 0
        return isWithinGrid && isPositive
    }
    
    /// Provided as a convenience to make changes to the world while easily
    /// configuring if the changes should/should not be animated.
    func applyChanges(animated: Bool = false, within changes: () -> Void) {
        let animating = isAnimated
        isAnimated = animated
        
        changes()
        
        isAnimated = animating
    }
}

extension GridWorld {
    // MARK: Coordinate Accessors
    
    /**
     Returns all coordinates in the specified column.
     
     Example usage:
     ````
     column(2)
     // Returns all coordinates in column 2.
     ````
     - parameters:
        - col: A column of the puzzle world, specified with an Int value.
     */
    public func column(_ col: Int) -> [Coordinate] {
        return coordinates(inColumns: [col])
    }
    
    /**
     Returns all coordinates in the specified row.
     
     Example usage:
     ````
     row(3)
     // Returns all coordinates in row 3.
     ````
     - parameters:
        - row: A row of the puzzle world, specified with an Int value.
     */
    public func row(_ row: Int) -> [Coordinate] {
        return coordinates(inRows: [row])
    }
    
    /**
     Returns all coordinates in the specified columns.
     
     Example usage:
     ````
     coordinates(inColumns: [2,3,4])
     // Returns all coordinates in columns 2, 3, and 4.
     ````
     - parameters:
        - columns: Specifies the array of columns in the puzzle world.
     */
    public func coordinates(inColumns columns: [Int]) -> [Coordinate] {
        return coordinates(inColumns: columns, intersectingRows: 0..<rowCount)
    }
    
    /**
     Returns all coordinates in the specified rows.
     
     Example usage:
     ````
     coordinates(inRows: [1,5,9])
     // Returns all coordinates in rows 1, 5, and 9.
     ````
     - parameters:
        - rows: Specifies the array of rows in the puzzle world.
     */
    public func coordinates(inRows rows: [Int]) -> [Coordinate] {
        return coordinates(inColumns: 0..<columnCount, intersectingRows: rows)
    }
    
    /**
     Returns the coordinates within the intersection between the specified columns and rows.
     
     Example usage:
    ````
    coordinatesBetween([0], rows: 0...2)
    // Returns (0,0), (0,1), (0,2).
    coordinatesBetween([1, 2], rows: [0, 3])
    // Returns (1,0), (2,0), (1, 3), (2,3).
    ````
     - parameters:
        - columns: Specifies the array of columns in the puzzle world.
        - rows: Specifies the array of intersecting rows in the puzzle world.
     */
    public func coordinates<Rows: Sequence, Columns: Sequence>(inColumns columns: Columns, intersectingRows rows: Rows) -> [Coordinate]
        where Rows.Iterator.Element == Int, Columns.Iterator.Element == Int  {
        
        let columns = columns.filter { $0 >= 0 && $0 < columnCount }
        let rows = rows.filter { $0 >= 0 && $0 < rowCount }
        
        return rows.flatMap { row -> [Coordinate] in
            return columns.map { column in
                Coordinate(column: column, row: row)
            }
        }
    }
    
    /**
     Returns the height of a stack of blocks at a given coordinate.
     
     Example usage:
    ````
    height(at: Coordinate(column: 3, row: 3))
    // Returns the height of a stack of blocks at (3,3).
    ````
     - parameters:
        - coordinate: Takes an input of type `Coordinate` specifying a location on the puzzle world.
     */
    public func height(at coordinate: Coordinate) -> Int {
        return Int(round(nodeHeight(at: coordinate) / WorldConfiguration.levelHeight))
    }
    
    public func topItem(at coordinate: Coordinate) -> Item? {
        let nodes = grid.nodes(at: coordinate).filter {
            return $0.isStackable
        }
        
        return nodes.max { n1, n2 in
            n1.position.y < n2.position.y
        }
    }
    
    func nodeHeight(at coordinate: Coordinate) -> SCNFloat {
        let item = topItem(at: coordinate)
        return item?.position.y ?? -WorldConfiguration.levelHeight
    }
}

extension GridWorld {
    // MARK: Convenience Methods
    
    /**
     Method that returns the gems present on an array of given coordinates.
     
     - parameters:
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    public func existingGems(at coordinates: [Coordinate]) -> [Gem] {
        return existingItems(ofType: Gem.self, at: coordinates)
    }
    
    /**
     Method that returns the switches present on an array of given coordinates.
     
     - parameters:
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    public func existingSwitches(at coordinates: [Coordinate]) -> [Switch] {
        return existingItems(ofType: Switch.self, at: coordinates)
    }
    
    /**
     Method that returns the characters present on an array of given coordinates.
     
     - parameters:
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    public func existingCharacters(at coordinates: [Coordinate]) -> [Character] {
        return existingItems(ofType: Character.self, at: coordinates)
    }
    
    public func existingCharacter(at coordinate: Coordinate) -> Character? {
        return existingItem(ofType: Character.self, at: coordinate)
    }
    
    /**
     Method that returns the experts present on an array of given coordinates.
     
     - parameters:
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    public func existingExperts(at coordinates: [Coordinate]) -> [Expert] {
        return existingItems(ofType: Expert.self, at: coordinates)
    }
    
    /**
     Method that returns true if an expert is present on a coordinate
     */
    public func existingExpert(at coordinate: Coordinate) -> Expert? {
        return existingItem(ofType: Expert.self, at: coordinate)
    }

    /**
     Method that returns the blocks present on an array of given coordinates.
     
     - parameters:
        - coordinates: Takes an array of type `Coordinate` specifying a list of locations in the puzzle world.
     */
    public func existingBlocks(at coordinates: [Coordinate]) -> [Block] {
        return existingItems(ofType: Block.self, at: coordinates)
    }
    
    /**
     Method that returns the the number of blocks present at a single coordinate.
     */
    public func numberOfBlocks(at coordinate: Coordinate) -> Int {
        return existingBlocks(at: [coordinate]).count
    }
    
    /**
     Method that returns the top block on a stack of block.
     */
    public func topBlock(at coordinate: Coordinate) -> Block? {
        return existingItems(ofType: Block.self, at: [coordinate]).max { b1, b2 in
            b1.position.y < b2.position.y
        }
    }
    
    /**
     Method that returns the water present in an array of given coordinates.
     */
    public func existingWater(at coordinates: [Coordinate]) -> [Water] {
        return existingItems(ofType: Water.self, at: coordinates)
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
     
     Example usage:
     ````
     place(Gem(), atColumn: 0, row: 0)
     // Places an instance of type Gem at coordinate (0,0).
     ````
     - parameters:
        - item: Takes an input conforming to type `Item`, such as a `Gem`, `Switch`, `Character`, or `Expert`.
        - column: Takes an Int specifying a column of the puzzle world.
        - row: Takes an Int specifying a row of the puzzle world.
     */
    public func place(_ item: Item, atColumn column: Int, row: Int) {
        self.place(item, at: Coordinate(column: column, row: row))
    }
    
    /**
     Method that places an item facing a certain direction into the puzzle world.
     
     Example usage:
     ````
     place(Character(), facing: .north, atColumn: 3, row: 2)
     // Places an instance of type Character, facing north at coordinate (3,2).
     ````
     - parameters:
        - item: Takes an input conforming to type `Item`, such as a `Gem`, `Switch`, `Character`, or `Expert`.
        - facing: Takes an enum value of type `Direction` including `.north`, `.south`, `.north`, or `.west`.
        - column: Takes an Int specifying a column of the puzzle world.
        - row: Takes an Int specifying a row of the puzzle world.
     */
    public func place(_ item: Item, facing: Direction, atColumn column: Int, row: Int) {
        self.place(item, facing: facing, at: Coordinate(column: column, row: row))
    }
    
    // MARK: Unavailable
    
    @available(*, unavailable, message: "You must correctly initialize all Items and Characters before placing them in the puzzle world. For example:\n    \n    let character = Character()\n    world.place(character, atColumn: 1, row: 1)\n    \n    world.place(Block(), atColumn: 2, row: 3)")
    public func place(_ item: Item.Type, facing: Direction? = nil, atColumn: Int, row: Int) {}
    
    @available(*, unavailable, message: "You must correctly initialize all Items and Characters before placing them in the puzzle world. For example:\n    \n    let character = Character()\n    world.place(character, atColumn: 1, row: 1)\n    \n    world.place(Block(), atColumn: 2, row: 3)")
    public func place(_ item: Item.Type, facing: Direction? = nil, at: Coordinate) {}
    
    /**
     Method that places a portal into the puzzle world.
     
     Example usage:
     ````
     place(Portal(color: .green), atStartColumn: 2, startRow: 2, atEndColumn: 4, endRow: 4)
     // Places a pair of portals, one at coordinate (2,2) and another at (4,4).
     ````
     - parameters:
        - portal: Takes an instance of type `Portal`.
        - atStartColumn: Takes an Int specifying the starting column of the portal.
        - startRow: Takes an Int specifying the starting row of the portal.
        - atEndColumn: Takes an Int specifying the ending column of the portal.
        - endRow: Takes an Int specifying the ending row of the portal.
     */
    public func place(_ portal: Portal, atStartColumn: Int, startRow: Int, atEndColumn: Int, endRow: Int) {
        self.place(portal, between: Coordinate(column: atStartColumn, row: startRow), and: Coordinate(column: atEndColumn, row: endRow))
    }
    

    /**
     Method that removes all items located at specific coordinates in the puzzle world.
     
     Example usage:
     ````
     remove(atColumn: 1, row: 3)
     // Removes all items at coordinate (1,3).
     ````
     - parameters:
        - column: Takes an Int specifying a column of the puzzle world.
        - row: Takes an Int specifying a row of the puzzle world.
     */
    public func removeItems(atColumn column: Int, row: Int)  {
        self.removeItems(at: Coordinate(column: column, row: row))
    }
}

extension GridWorld {
    // MARK: Randomized Placement
    
    /// Places a gem or switch at the provided location.
    /// Randomly sets the state of the switch to open or close with the option to 
    /// ensure at least one switch is closed.
    public func placeRandomGemOrSwitch(at locations: [Coordinate], ensureClosedSwitch: Bool = true) {
        var locations = locations
        
        if ensureClosedSwitch {
            let index = locations.randomIndex
            if locations.indices.contains(index) {
                let closedCoordinate = locations.remove(at: index)
                place(Switch(), at: closedCoordinate)
            }
        }
        
        for coor in locations {
            if randomBool() {
                placeGems(at: [coor])
            }
            else {
                let switchItem = Switch()
                switchItem.isOn = randomBool()
                
                // Place the switch after `isOn` has been set to avoid 
                // exccessive animation.
                place(switchItem, at: coor)
            }
        }
    }
}
