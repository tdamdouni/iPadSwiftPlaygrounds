//
//  Actor.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

public class Actor: Item, NodeConstructible {
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .actor
    
    public weak var world: GridWorld? {
        didSet {
            removeComponent(WorldActionComponent.self)
            addComponent(WorldActionComponent.self)
            
            let worldComponent = componentForType(WorldActionComponent.self)
            worldComponent?.world = world
            
            commandDelegate = world
        }
    }
    
    public let node: NodeWrapper
    
    public var worldIndex = -1
    
    public var isLevelMoveable: Bool {
        return true
    }
    
    var type: ActorType
    
    /// Convenience accessor for world's `commandSpeed`
    var commandSpeed: Float {
        return world?.commandSpeed ?? 1.0
    }
    
    var components = [ActorComponent]()
    var runningComponents = [ActorComponent]()
    
    weak var commandDelegate: PerformerDelegate? = nil
    
    lazy var actorCamera: SCNNode = {
        // Programmatically add an actor camera.
        let actorCamera = SCNNode()
        actorCamera.position = SCNVector3Make(0, 0.785, 3.25)
        actorCamera.eulerAngles.x = -0.1530727
        actorCamera.camera = SCNCamera()
        actorCamera.name = "actorCamera"
        self.scnNode.addChildNode(actorCamera)
        
        return actorCamera
    }()
    
    /// If the a `CharacterName` is not provided, the saved character will be used.
    public init(name: CharacterName? = nil) {
        self.type = name?.type ?? ActorType.loadDefault()
        node = NodeWrapper(identifier: .actor)
        
        commonInit()
    }
    
    public required init?(node: SCNNode) {
        guard node.identifier == .actor
            && node.identifierComponents.count >= 2 else { return nil }
        guard let type = ActorType(rawValue: node.identifierComponents[1]) else { return nil }
        self.type = type
        self.node = NodeWrapper(node)
        
        commonInit()
    }
    
    func commonInit() {
        addComponent(AnimationComponent.self)
//        addComponent(AudioComponent.self)
        
        scnNode.categoryBitMask = WorldConfiguration.characterLightBitMask
    }
    
    // MARK: ActorComponent
    
    func addComponent(_ performer: ActorComponent.Type) {
        components.append(performer.init(actor: self))
    }
    
    func componentForType<T : ActorComponent>(_ componentType: T.Type) -> T? {
        for component in components where component is T {
            return component as? T
        }
        return nil
    }
    
    func removeComponent<T : ActorComponent>(_ componentType: T.Type) {
        guard let index = components.index(where: { $0 is T }) else { return }
        components.remove(at: index)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(type.createNode())
    }
    
    // MARK: Jump
    
    /**
     Instructs the character to jump forward and either up or down one block. 
     
     If the block the character is facing is one block higher than the block the character is standing on, the character will jump on top of it.
     If the block the character is facing is one block lower than the block the character is standing on, the character will jump down to that block.
     */
    @discardableResult
    public func jump() -> Coordinate {
        guard let world = world else { return coordinate }
        let movementResult = world.movementResult(heading: heading, from: position)
        
        let nextCoordinate = nextCoordinateInCurrentDirection
        let deltaY = heightDisplacementMoving(to: nextCoordinate)
        
        // Determine if the y displacement is small enough such that the character can
        // cover it with a jump.
        let toleranceY = abs(deltaY) - WorldConfiguration.heightTolerance
        let isJumpableDisplacement = toleranceY < WorldConfiguration.levelHeight
        
        switch movementResult {
        case .valid, 
             .raisedTile where isJumpableDisplacement,
             .edge where isJumpableDisplacement:
            
            let point = nextCoordinate.position
            let destination = SCNVector3Make(point.x, position.y + deltaY, point.z)
            add(action: .jump(from: position, to: destination))
            
            // Check for portals.
            addCommandForPortal(at: nextCoordinate)
            
            return nextCoordinate
        default:
            // Error cases evaluate to the same result as `moveForward()`.
            return moveForward()
        }
    }
    
    /// Creates a new command if a portal exists at the specified coordinate.
    private func addCommandForPortal(at coordinate: Coordinate) {
        let portal = world?.existingNode(ofType: Portal.self, at: coordinate)
        if let destinationPortal = portal?.linkedPortal where portal!.isActive {
            add(action: .teleport(from: position, to: destinationPortal.position))
        }
    }
}

// MARK: Movement Commands

extension Actor {
    
    /**
     Moves the character forward one tile.
     */
    @discardableResult
    public func moveForward() -> Coordinate {
        guard let world = world else { return coordinate }
        let movementResult = world.movementResult(heading: heading, from: position)
        
        switch movementResult {
        case .valid:
            let nextCoordinate = nextCoordinateInCurrentDirection
            
            // Check for stairs.
            let yDisplacement = position.y + heightDisplacementMoving(to: nextCoordinate)
            let point = nextCoordinate.position
            
            let destination = SCNVector3Make(point.x, yDisplacement, point.z)
            add(action: .move(from: position, to: destination))
            
            // Check for portals.
            addCommandForPortal(at: nextCoordinate)
            
        case .edge, .obstacle:
            add(action: .incorrect(.offEdge))
            
        case .wall, .raisedTile, .occupied:
            add(action: .incorrect(.intoWall))
        }
        
        return Coordinate(position)
    }
    
    /**
     Turns the character left.
     */
    public func turnLeft() {
        turnBy(90)
    }
    
    /**
     Turns the character right.
     */
    public func turnRight() {
        turnBy(-90)
    }
    
    /**
     Moves the character forward by a certain number of tiles, as determined by the `distance` parameter.
     */
    public func move(distance: Int) {
        for _ in 1 ... distance {
            moveForward()
        }
    }
    
    // MARK: Action Helpers
    
    /**
     Rotates the actor by `degrees` around the y-axis.
     
     - turnLeft() = 90
     - turnRight() = -90/ 270
     */
    @discardableResult
    func turnBy(_ degrees: Int) -> SCNFloat {
        // Convert degrees to radians.
        let nextDirection = (rotation + degrees.toRadians).truncatingRemainder(dividingBy: 2 * π)
        
        let currentDir = Direction(radians: rotation)
        let nextDir = Direction(radians: nextDirection)
        
        let clockwise = currentDir.angle(to: nextDir) < 0
        add(action: .turn(from: rotation, to: nextDirection, clockwise: clockwise))
        
        return nextDirection
    }
    
    /// Returns the next coordinate moving forward 1 tile in the actors `currentDirection`.
    var nextCoordinateInCurrentDirection: Coordinate {
        return coordinateInCurrentDirection(displacement: 1)
    }
    
    func coordinateInCurrentDirection(displacement: Int) -> Coordinate {
        let heading = Direction(radians: rotation)
        let coordinate = Coordinate(position)
        
        return coordinate.advanced(by: displacement, inDirection: heading)
    }
    
    func heightDisplacementMoving(to coordinate: Coordinate) -> SCNFloat {
        guard let world = world else { return 0 }
        let startHeight = position.y
        let endHeight = world.height(at: coordinate)
        
        return endHeight - startHeight
    }
}

// MARK: Item Commands

extension Actor {
    
    /**
     Instructs the character to collect a gem on the current tile.
     */
    @discardableResult
    public func collectGem() -> Bool {
        guard let item = world?.existingGems(at: [coordinate]).first else {
            add(action: .incorrect(.missingGem))
            return false
        }
        
        add(action: .remove([item.worldIndex]))
        return true
    }
    
    /**
     Instructs the character to toggle a switch on the current tile.
     */
    @discardableResult
    public func toggleSwitch() -> Bool {
        guard let switchNode = world?.existingNode(ofType: Switch.self, at: coordinate) else {
            add(action: .incorrect(.missingSwitch))
            return false
        }
        
        // Toggle switch to the opposite of it's original value.
        let oldValue = switchNode.isOn
        add(action: .toggle(toggleable: switchNode.worldIndex, active: !oldValue))
        return true
    }
}

extension Actor: Equatable{}

public func ==(lhs: Actor, rhs: Actor) -> Bool {
    return lhs.type == rhs.type && lhs.node === rhs.node
}

// MARK: Boolean Commands

extension Actor {
    
    /**
     Condition that checks if the character is currently on a tile with a gem on it.
     */
    public var isBlocked: Bool {
        guard let world = world else { return false }
        return !world.isValidActorTranslation(heading: heading, from: position)
    }
    
    /**
     Condition that checks if the character is blocked on the left.
     */
    public var isBlockedLeft: Bool {
        return isBlocked(heading: .west)
    }
    
    /**
     Condition that checks if the character is blocked on the right.
     */
    public var isBlockedRight: Bool {
        return isBlocked(heading: .east)
    }
    
    func isBlocked(heading: Direction) -> Bool {
        guard let world = world else { return false }
        let blockedCheckDir = Direction(radians: rotation - heading.radians)
        
        return !world.isValidActorTranslation(heading: blockedCheckDir, from: position)
    }
    
    // MARK: isOn
    
    /**
     Condition that checks if the character is currently on a tile with that contains a WorldNode of a specific type.
     */
    public func isOnNode<Node: Item>(ofType type: Node.Type) -> Bool {
        return nodeAtCurrentPosition(ofType: type) != nil
    }
    
    /**
     Condition that checks if the character is currently on a tile with a gem on it.
     */
    public var isOnGem: Bool {
        return isOnNode(ofType: Gem.self)
    }
    
    /**
     Condition that checks if the character is currently on a tile with an open switch on it.
     */
    public var isOnOpenSwitch: Bool {
        if let switchNode = nodeAtCurrentPosition(ofType: Switch.self) {
            return switchNode.isOn
        }
        return false
    }
    
    /**
     Condition that checks if the character is currently on a tile with a closed switch on it.
     */
    public var isOnClosedSwitch: Bool {
        if let switchNode = nodeAtCurrentPosition(ofType: Switch.self) {
            return !switchNode.isOn
        }
        return false
    }
    
    func nodeAtCurrentPosition<Node: Item>(ofType type: Node.Type) -> Node?  {
        guard let world = world else { return nil }
        return world.existingNode(ofType: type, at: coordinate)
    }
}

// MARK: Performer

extension Actor: Performer {
    
    var id: Int {
        return worldIndex
    }
    
    var isRunning: Bool {
        return !runningComponents.isEmpty
    }
    
    func applyStateChange(for action: Action) {
        for performer in components {
            performer.applyStateChange(for: action)
        }
    }
    
    /// Cycles through the actors components allowing each component to respond to the action.
    func perform(_ action: Action) {
        if !runningComponents.isEmpty {
            for performer in runningComponents {
                performer.cancel(action)
            }
        }
        runningComponents = self.components
        
        for performer in runningComponents {
            performer.perform(action)
        }
    }
    
    func cancel(_ action: Action) {
        // Cancel all components.
        // A lot of components don't hold as running, but need to be reset with cancel.
        for performer in components {
            performer.cancel(action)
        }
    }
    
    /// Convenience to create an `Command` by bundling in `self` with the provided action.
    func add(action: Action) {
        guard let world = world else { return }
        let command = Command(performer: self, action: action)
        world.commandQueue.append(command, applyingState: true)
    }
}

// MARK: PerformerDelegate

extension Actor: PerformerDelegate {
    
    func performerFinished(_ performer: Performer) {
        
        assert(Thread.isMainThread())
        
        let addressPredicate: (ActorComponent) -> Bool = { unsafeAddress(of: $0) == unsafeAddress(of: performer) }
        guard let index = runningComponents.index(where: addressPredicate) else { return }
        
        runningComponents.remove(at: index)
        if runningComponents.isEmpty {
            commandDelegate?.performerFinished(self)
        }
    }
}


import PlaygroundSupport

extension Actor: MessageConstructor {
    
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.string(type.rawValue)]
    }

}

    // MARK: Swap
extension Actor {
    
    func swap(with actor: Actor) {
        self.type = actor.type
        actor.scnNode.removeAllAnimations()
        actor.scnNode.removeAllActions()
        removeComponent(AnimationComponent.self)
        addComponent(AnimationComponent.self)
        
        for child in scnNode.childNodes { child.removeFromParentNode() }
        for child in actor.scnNode.childNodes { scnNode.addChildNode(child) }
        
    }
    
}

