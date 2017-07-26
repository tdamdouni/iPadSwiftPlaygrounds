//
//  Actor.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit
import PlaygroundSupport

/**
 The type representing the different characters that can move about in the world.
*/
public class Actor: Item, NodeConstructible {
    // MARK: Static
    
    static var commandSpeed: Float = WorldConfiguration.Actor.idleSpeed
    
    public static let identifier: WorldNodeIdentifier = .actor
    
    // MARK: Item
    
    public var id = Identifier.undefined
    
    public let node: NodeWrapper
    
    public weak var world: GridWorld? {
        didSet {
            if let world = world {
                // Create a new `WorldActionComponent` when setting the world.
                addComponent(WorldActionComponent(actor: self, world: world))
                if !scnNode.childNodes.isEmpty {
                    // Start idling when placed in the world (if the geometry is loaded).
                    idleQueue.start(breathingOnly: true)
                }
            }
            else {
                removeComponent(ofType: WorldActionComponent.self)
                stopContinuousIdle()
            }
        }
    }
    
    // MARK: Actor Properties
    
    var type: ActorType
    
    /// The action that is currently running, if any.
    fileprivate(set) var currentAction: Action?
    
    var components = [ActorComponent]()
    
    var result: PerformerResult?
    
    /// Indicates if the actor has components currently running.
    var isRunning: Bool {
        return runningComponents.isEmpty == false
    }
    
    /// A flag to indicate if this character is currently being presented in the character picker. 
    var isInCharacterPicker = false
    
    /// A driver which causes the actor to idle indefinitely.
    lazy var idleQueue: ContinuousIdleQueue = ContinuousIdleQueue(actor: self)
    
    var isIdle: Bool {
        return idleQueue.isRunning
    }
    
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
    
    // Private properties
    
    /// Used to synchronously access `runningComponents`.
    private let componentsQueue = DispatchQueue(label: "com.LTC.RunningComponents")
    private var _runningComponents = [ActorComponent]()
    
    /// Returns the components that are still running for this actor.
    /// Note: This synchronously blocks for access to the underlying array.
    fileprivate var runningComponents: [ActorComponent] {
        get {
            var runningComponents: [ActorComponent]!
            componentsQueue.sync { runningComponents = _runningComponents }
            return runningComponents
        }
        
        set {
            componentsQueue.sync { _runningComponents = newValue }
        }
    }
    
    // MARK: Initialization
    
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
        addComponent(AnimationComponent(actor: self))
        
        // Check if audio is enabled.
        if Persisted.areSoundEffectsEnabled {
            addComponent(AudioComponent(actor: self))
        }

        scnNode.categoryBitMask = WorldConfiguration.characterLightBitMask
    }
    
    // MARK: Components
    
    /// Adds an ActorComponent to this Actor.
    /// There may only be one component instance for each component type.
    func addComponent<T: ActorComponent>(_ component: T) {
        // Remove any component of the same type.
        removeComponent(ofType: T.self)
        
        components.append(component)
    }
    
    func component<T : ActorComponent>(ofType componentType: T.Type) -> T? {
        for component in components where component is T {
            return component as? T
        }
        return nil
    }
    
    @discardableResult
    func removeComponent<T : ActorComponent>(ofType componentType: T.Type) -> T? {
        guard let index = components.index(where: { $0 is T }) else { return nil }
        
        let component = components.remove(at: index) as? T
        
        // If a current action is running, make sure this component gets cancelled.
        if let action = currentAction {
            component?.cancel(action)
        }
        
        return component
    }
    
    // MARK: Geometry
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        scnNode.addChildNode(type.createNode())
    }
    
    // MARK: Creating Commands
    
    /// Convenience to create an `Command` by bundling in `self` with the provided action.
    func add(action: Action) {
        guard let world = world else { return }
        let command = Command(performer: self, action: action)
        world.commandQueue.append(command, applyingState: true)
    }
    
    func animationCommands(_ types: [EventGroup]) -> [Command] {
        return types.map { animationCommand($0) }
    }
    
    func animationCommand(_ group: EventGroup, variation: Int? = nil) -> Command {
        return Command(performer: self, action: .run(group, variation: variation))
    }
    
    // MARK: Animation
    
    /// Starts running the continuous idle. Reset by asking the scene to run.
    func startContinuousIdle() {
        guard !idleQueue.isRunning || idleQueue.isBreathingOnly else { return }
            
        idleQueue.start(initialAnimations: [.idle])
    }
    
    func stopContinuousIdle() {
        idleQueue.stop()
    }
    
    /// Stops the continuous idle,
    /// clears the SCNNode for the actor of actions and animations,
    /// and cancels the running action.
    public func reset() {
        // Stop any upcoming idle animations.
        stopContinuousIdle()
        
        // Make sure all animations are cleared. 
        let animation = component(ofType: AnimationComponent.self)
        animation?.removeAnimations()
        scnNode.removeAllActions()
        
        // Cancel any `currentAction` that is running.
        guard let action = currentAction else { return }
        cancel(action)
        currentAction = nil
    }
    
    // MARK: CharacterPicker Swap
    
    func swap(with actor: Actor) {
        actor.scnNode.removeAllAnimations()
        actor.scnNode.removeAllActions()
        
        for child in scnNode.childNodes { child.removeFromParentNode() }
        for child in actor.scnNode.childNodes { scnNode.addChildNode(child) }
        
        type = actor.type
    }
    
    // MARK: Jump
    
    /**
     Instructs the character to jump forward and either up or down one block. 
     
     If the block the character is facing is one block higher than the block the character is standing on, the character will jump on top of it.
     If the block the character is facing is one block lower than the block the character is standing on, the character will jump down to that block.
     */
    @discardableResult
    public func jump() -> Coordinate {
        return _jump()
    }
}

extension Actor: Equatable{}

public func ==(lhs: Actor, rhs: Actor) -> Bool {
    return lhs.type == rhs.type && lhs.node === rhs.node
}

extension Actor {
    // MARK: Performer
    
    func applyStateChange(for action: Action) {
        for performer in components {
            performer.applyStateChange(for: action)
        }
    }
    
    /// Cycles through the actors components allowing each component to respond to the action.
    func perform(_ action: Action) -> PerformerResult {
        // Clear the `currentAction`.
        if isRunning, let currentAction = currentAction {
            cancel(currentAction)
        }
        currentAction = nil
        runningComponents.removeAll()
        
        // If the `currentCommand` is running for this actor, ensure the `idleQueue` is stopped.
        let command = world?.commandQueue.currentCommand
        if command?.performer === self {
            stopContinuousIdle()
        }
        
        // Not all commands apply to the actor, return immediately if there is no action.
        guard let event = action.event else {
            fatalError("The actor has been asked to perform \(action), but there is no valid event associated with this action.")
        }
        currentAction = action
        
        // Mark all the components as running.
        runningComponents = components
        
        let index = action.variationIndex
        for component in components {
            let componentResult = component.perform(event: event, variation: index)
            componentResult.completionHandler = { [weak self] performer in
                self?.performerFinished(performer)
            }
        }
        
        result = PerformerResult(self, isAsynchronous: isRunning)
        return result!
    }
    
    /// Performs the event only as an animation.
    func perform(event: EventGroup, variation: Int? = nil) -> PerformerResult {
        return perform(.run(event, variation: variation))
    }
    
    /// Cancels all components.
    func cancel(_ action: Action) {
        result = nil
        
        // A lot of components don't hold as running, but need to be reset with cancel.
        for performer in components {
            performer.cancel(action)
        }
        
        currentAction = nil
    }
    
    // MARK: Performer Finished
    
    func performerFinished(_ performer: Performer) {
        // Match the finished performer with the remaining `runningComponents`.
        guard let index = runningComponents.index(where: { $0 === performer }) else {
            log(message: "\(performer) reported it was finished, but does not belong to \(self)")
            return
        }
        runningComponents.remove(at: index)
        
        if !isRunning {
            currentAction = nil
            result?.complete()
            
            let nextCommand = world?.commandQueue.pendingCommands.first
            if !isIdle, nextCommand?.performer !== self {
                // Enter a neutral idle while waiting for the next command.
                idleQueue.start(breathingOnly: true)
            }
        }
    }
}

extension Actor {
    // MARK: Movement Commands
    
    /**
     Moves the character forward by a certain number of tiles, 
     as determined by the `distance` parameter value.
     
     Example usage:
     ````
     move(distance: 3)
     // Moves forward 3 tiles.
     ````
     
     - parameters:
        - distance: Takes an Int value specifying the number of times to call `moveForward()`.
     */
    public func move(distance: Int) {
        for _ in 1 ... distance {
            moveForward()
        }
    }
    
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
            let displacement = Displacement(from: position, to: destination)
            add(action: .move(displacement, type: .walk))
            
            // Check for portals.
            addCommandForPortal(at: nextCoordinate)
            
        case .edge, .obstacle:
            add(action: .fail(.offEdge))
            
        case .wall, .raisedTile, .occupied:
            add(action: .fail(.intoWall))
        }
        
        return Coordinate(position)
    }
    
    // `_jump()` included only for organizational purposes
    // (`jump()` is overridden by Expert).
    fileprivate func _jump() -> Coordinate {
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
            let displacement = Displacement(from: position, to: destination)
            add(action: .move(displacement, type: .jump))
            
            // Check for portals.
            addCommandForPortal(at: nextCoordinate)
            
            return nextCoordinate
        default:
            // Error cases evaluate to the same result as `moveForward()`.
            return moveForward()
        }
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
    
    // MARK: Movement Helpers
    
    /// Creates a new command if a portal exists at the specified coordinate.
    private func addCommandForPortal(at coordinate: Coordinate) {
        let portal = world?.existingItem(ofType: Portal.self, at: coordinate)
        if let destinationPortal = portal?.linkedPortal, portal!.isActive {
            let displacement = Displacement(from: position, to: destinationPortal.position)
            
            add(action: .move(displacement, type: .teleport))
        }
    }

    /**
     Rotates the actor by `degrees` around the y-axis.
     
     - turnLeft() = 90
     - turnRight() = -90/ 270
     */
    @discardableResult
    private func turnBy(_ degrees: Int) -> SCNFloat {
        // Convert degrees to radians.
        let nextDirection = (rotation + degrees.toRadians).truncatingRemainder(dividingBy: 2 * π)
        
        let currentDir = Direction(radians: rotation)
        let nextDir = Direction(radians: nextDirection)
        
        let clockwise = currentDir.angle(to: nextDir) < 0
        let displacement = Displacement(from: rotation, to: nextDirection)
        add(action: .turn(displacement, clockwise: clockwise))
        
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
        let endHeight = world.nodeHeight(at: coordinate)
        
        return endHeight - startHeight
    }
}

extension Actor {
    // MARK: Item Commands
    
    /**
     Instructs the character to collect a gem on the current tile.
     */
    @discardableResult
    public func collectGem() -> Bool {
        guard let item = world?.existingGems(at: [coordinate]).first else {
            add(action: .fail(.missingGem))
            return false
        }
        
        add(action: .remove([item.id]))
        return true
    }
    
    /**
     Instructs the character to toggle a switch on the current tile.
     */
    @discardableResult
    public func toggleSwitch() -> Bool {
        guard let switchNode = world?.existingItem(ofType: Switch.self, at: coordinate) else {
            add(action: .fail(.missingSwitch))
            return false
        }
        
        // Toggle switch to the opposite of it's original value.
        let oldValue = switchNode.isOn
        let cont = Controller(identifier: switchNode.id, kind: .toggle, state: !oldValue)
        add(action: .control(cont))
        
        return true
    }
}

extension Actor {
    // MARK: Boolean Commands
    
    /**
     Condition that checks if the character is on a tile with a gem on it.
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
    public func isOnItem<Node: Item>(ofType type: Node.Type) -> Bool {
        return itemAtCurrentPosition(ofType: type) != nil
    }
    
    /**
     Condition that checks if the character is on a tile with a gem on it.
     */
    public var isOnGem: Bool {
        return isOnItem(ofType: Gem.self)
    }
    
    /**
     Condition that checks if the character is on a tile with an open switch on it.
     */
    public var isOnOpenSwitch: Bool {
        if let switchNode = itemAtCurrentPosition(ofType: Switch.self) {
            return switchNode.isOn
        }
        return false
    }
    
    /**
    Condition that checks if the character is on a tile with a closed switch on it.
     */
    public var isOnClosedSwitch: Bool {
        if let switchNode = itemAtCurrentPosition(ofType: Switch.self) {
            return !switchNode.isOn
        }
        return false
    }
    
    func itemAtCurrentPosition<T: Item>(ofType type: T.Type) -> T?  {
        guard let world = world else { return nil }
        return world.existingItem(ofType: type, at: coordinate)
    }
}

extension Actor {
    // MARK: Dance Actions
    
    /**
     Causes the character to bust out fancy move.
     */
    public func danceLikeNoOneIsWatching() {
        add(action: .run(.victory, variation: 1))
    }
    
    /**
     The character receives a burst of energy, turning up by several notches.
     */
    public func turnUp() {
        add(action: .run(.victory, variation: 0))
    }
    
    /**
     The character starts to feel real funky, breaking it down for all to witness.
     */
    public func breakItDown() {
        add(action: .run(.celebration, variation: nil))
    }
    
    
    // MARK: Defeat Actions
    
    /**
     The character feels a bit bummed.
     */
    public func grumbleGrumble() {
        add(action: .run(.defeat, variation: 0))
    }
    
    /**
     The character feels a wave of horror.
     */
    public func argh() {
        add(action: .run(.defeat, variation: 1))
    }
    
    /**
     The character performs a head scratch.
     */
    public func headScratch() {
        add(action: .run(.defeat, variation: 2))
    }
    
    // MARK: Misc Actions
    
    /**
     The character hits a metaphorical wall.
     */
    public func bumpIntoWall() {
        add(action: .run(.bumpIntoWall, variation: nil))
    }
}

extension Actor: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.string(type.rawValue)]
    }
}
