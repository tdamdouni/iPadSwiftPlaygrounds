//
//  AccessibilityExtensions.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import SceneKit

/// Describes the contents of each coordinate in the world.
class CoordinateAccessibilityElement: UIAccessibilityElement {
    
    let coordinate: Coordinate
    weak var world: GridWorld?
    
    /// Override `accessibilityLabel` to always return updated information about world state.
    override var accessibilityLabel: String? {
        get {
            return world?.speakableContents(of: coordinate)
        }
        set {}
    }
    
    override var accessibilityTraits: UIAccessibilityTraits {
        get {
            var traits = super.accessibilityTraits
            if world?.existingCharacter(at: coordinate) != nil {
                traits |= UIAccessibilityTraitStartsMediaSession
            }
            
            return traits
        }
        set {}
    }
    
    init(coordinate: Coordinate, inWorld world: GridWorld, view: UIView) {
        self.coordinate = coordinate
        self.world = world
        super.init(accessibilityContainer: view)
    }
}

/// Provides an overall description of the `GridWorld`.
class GridWorldAccessibilityElement: UIAccessibilityElement {
    weak var world: GridWorld?
    
    override var accessibilityLabel: String? {
        get {
            return world?.speakableDescription
        }
        set {}
    }
    
    override var accessibilityHint: String? {
        get {
            return "To repeat this description, tap outside of the world grid."
        }
        set {}
    }
    
    init(world: GridWorld, view: UIView) {
        self.world = world
        super.init(accessibilityContainer: view)
    }

    override func accessibilityActivate() -> Bool {
        return false
    }
}

// MARK: SceneController Accessibility

extension SceneController {
    
    func registerForAccessibilityNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(voiceOverStatusChanged), name: Notification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
    }
    
    func unregisterForAccessibilityNotifications() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
    }
    
    func voiceOverStatusChanged() {
        DispatchQueue.main.async {
            self.setVoiceOverForCurrentStatus(forceLayout: true)
        }
    }
    
    /**
    Configures the scene to account for the current VoiceOver status.
     - parameters:
         - forceLayout: Passing `true` will force the accessibility elements
        to be recalculated for the current grid.
    */
    func setVoiceOverForCurrentStatus(forceLayout: Bool = false) {
        // Ensure the view is loaded and the `characterPicker` is not presented.
        guard isViewLoaded, characterPicker == nil else { return }
        
        if UIAccessibilityIsVoiceOverRunning() {
            scnView.gesturesEnabled = false

            // Lazily recompute the `accessibilityElements`.
            if forceLayout || view.accessibilityElements?.isEmpty == true {
                cameraController?.switchToOverheadView()
                let container = configureAccessibilityElementsForGrid()
                
                // Add buttons because we've removed the default elements.
                view.accessibilityElements?.append(audioButton)
                view.accessibilityElements?.append(speedButton)
                view.accessibilityElements?.append(goalCounter)
                
                UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, container)
            }
            
            // Add an AccessibilityComponent to each actor.
            for actor in scene.actors
                where actor.component(ofType: AccessibilityComponent.self) == nil {
                actor.addComponent(AccessibilityComponent(actor: actor))
            }
            
            // Add custom actions to provide details about the world.
            accessibilityCustomActions = [
                UIAccessibilityCustomAction(name: NSLocalizedString("Character Locations", comment: "AX action label"), target: self, selector: #selector(announceCharacterLocations)),
                UIAccessibilityCustomAction(name: NSLocalizedString("Goal Locations", comment: "AX action label"), target: self, selector: #selector(announceGoalLocations)),
            ]
            
            // Add an action for random items only when there are random items.
            if scene.gridWorld.grid.allItems.contains(where: { $0 is RandomNode }) {
                let action = UIAccessibilityCustomAction(name: NSLocalizedString("Random Item Locations", comment: "AX action label"), target: self, selector: #selector(announceRandomItems))
                accessibilityCustomActions?.append(action)
            }
        }
        else {
            scnView.gesturesEnabled = true
            cameraController?.resetFromVoiceOver()
            
            for actor in scene.actors {
                actor.removeComponent(ofType: AccessibilityComponent.self)
            }
        }
    }
    
    private func configureAccessibilityElementsForGrid() -> UIAccessibilityElement {
        view.isAccessibilityElement = false
        view.accessibilityElements = []
        
        for coordinate in scene.gridWorld.columnRowSortedCoordinates {
            let gridPosition = coordinate.position
            let rootPosition = scene.gridWorld.grid.scnNode.convertPosition(gridPosition, to: nil)
            
            let offset = WorldConfiguration.coordinateLength / 2
            let upperLeft = scnView.projectPoint(SCNVector3(rootPosition.x - offset, rootPosition.y, rootPosition.z - offset))
            let lowerRight = scnView.projectPoint(SCNVector3(rootPosition.x + offset, rootPosition.y, rootPosition.z + offset))
            
            let point = CGPoint(x: CGFloat(upperLeft.x), y: CGFloat(upperLeft.y))
            let size = CGSize (width: CGFloat(lowerRight.x - upperLeft.x), height: CGFloat(lowerRight.y - upperLeft.y))
            
            let element = CoordinateAccessibilityElement(coordinate: coordinate, inWorld: scene.gridWorld, view: view)
            element.accessibilityFrame = CGRect(origin: point, size: size)
            view.accessibilityElements?.append(element)
        }
        
        let container = GridWorldAccessibilityElement(world: scene.gridWorld, view: view)
        container.accessibilityFrame = view.bounds
        view.accessibilityElements?.append(container)
        
        return container
    }
    
    // MARK: Custom Actions
    
    func announce(speakableDescription: String) {
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, speakableDescription)
    }
    
    func announceCharacterLocations() -> Bool {
        announce(speakableDescription: scene.gridWorld.speakableActorLocations())
        return true
    }
    
    func announceGoalLocations() -> Bool {
        announce(speakableDescription: scene.gridWorld.speakableGoalLocations())
        return true
    }
    
    func announceRandomItems() -> Bool {
        let world = scene.gridWorld
        announce(speakableDescription: world.speakableRandomLocations())
        return world.grid.allItems.contains(where: { $0 is RandomNode })
    }
}

extension GridWorld {
    
    /// Returns all the possible coordinates sorted by column then row.
    var columnRowSortedCoordinates: [Coordinate] {
        return allPossibleCoordinates.sorted(by: columnRowSortPredicate)
    }
    
    var columnRowSortedItems: [Item] {
        return grid.allItemsInGrid.sorted(by: columnRowSortPredicate)
    }
    
    /// Describes the entire contents of the world including all the important locations.
    var speakableDescription: String {
        var description = "The world is \(columnCount) columns by \(rowCount) rows. "
        description += speakableActorLocations()
        description += ". The goals are: " + speakableGoalLocations()
        description += speakableRandomLocations()
        
        return description
    }
    
    // MARK: Specific queries
    
    func speakableActorLocations() -> String {
        let actors = grid.actors.sorted(by: columnRowSortPredicate)
        
        if actors.isEmpty {
            return "There is no character in this world. You must place your own."
        }
        
        return actors.reduce("") { result, actor in
            result + "\(actor.speakableDescription) on \(actor.locationDescription),"
        }
    }
    
    func speakableGoalLocations() -> String {
        let goals = columnRowSortedItems.filter {
            switch $0.identifier {
            case .switch, .portal, .gem, .platformLock: return true
            default: return false
            }
        }
        
        if goals.isEmpty {
            return "No switches or gems found."
        }
        
        var goalDescription = ""
        for (index, item) in goals.enumerated() {
            goalDescription += item.speakableDescription + " on \(item.locationDescription)"
            goalDescription += index == goals.endIndex ? "." : "; "
        }
        
        return goalDescription
    }
    
    /// Returns the description for all random items that are used for layout
    /// (including if the markers are not currently visible).
    func speakableRandomLocations() -> String {
        let allSortedItems = grid.allItems.sorted(by: columnRowSortPredicate)
        let randomItems = allSortedItems.filter { $0.identifier == .randomNode }
        
        if randomItems.isEmpty {
            // Ignore if no there are no random items.
            return ""
        }
        
        var description = ""
        for (index, item) in randomItems.enumerated() {
            description += item.speakableDescription + " on \(item.locationDescription)"
            description += index == randomItems.endIndex ? "." : "; "
        }
        
        return description
    }
    
    // MARK: Coordinate contents
    
    func speakableContents(of coordinate: Coordinate) -> String {
        let prefix = "\(coordinate.description), "
        
        let contents = excludingNodes(ofType: Block.self, at: coordinate).reduce("") { str, item in
            let suffix: String
            if type(of: item) == Actor.self, shouldShowPicker(from: item.scnNode) {
                suffix = ". Double-tap to switch characters."
            } else {
                suffix = ", "
            }
            return str + item.speakableDescription + suffix
        }
        
        let suffix = !contents.isEmpty ? contents : blockDescription(at: coordinate)
        return completeSentence(prefix + suffix)
    }
    
    // MARK: Helper Methods
    
    /// Returns if the coordinate contains a block, or is unreachable.
    func blockDescription(at coordinate: Coordinate) -> String {
        guard let block = topBlock(at: coordinate) else {
            return "is unreachable."
        }
        return block.description(with: [.name, .height])
    }
    
    /// Removes ", " from the end of a string and replaces it with ".".
    private func completeSentence(_ sentence: String) -> String {
        let chars = sentence.characters
        let end = chars.suffix(2)
        guard String(end) == ", " else { return sentence + "." }
        
        return String(chars.dropLast(2)) + "."
    }
    
    func columnRowSortPredicate(_ item1: Item, _ item2: Item) -> Bool {
        return columnRowSortPredicate(item1.coordinate, item2.coordinate)
    }
    
    func columnRowSortPredicate(_ coor1: Coordinate, _ coor2: Coordinate) -> Bool {
        if coor1.column == coor2.column {
            return coor1.row < coor2.row
        }
        return coor1.column < coor2.column
    }
}

// MARK: DescriptionComponents

struct ItemDescriptionComponents: OptionSet {
    let rawValue: Int
    
    static let name  = ItemDescriptionComponents(rawValue: 1 << 0)
    static let height  = ItemDescriptionComponents(rawValue: 1 << 1)
    static let direction  = ItemDescriptionComponents(rawValue: 1 << 2)
}

extension Item {
    
    var locationDescription: String{
        return "\(coordinate.description)"
    }
    
    func description(with components: ItemDescriptionComponents) -> String {
        var description = ""
        
        if components.contains(.name) {
            description += identifier.rawValue.lowercased()
        }
        
        if components.contains(.height) {
            description += " at height \(height)"
        }
        
        if components.contains(.direction) {
            description += " facing \(heading)"
        }
        
        return description
    }
}

// MARK: Speakable Descriptions

extension Actor {
    var speakableName: String {
        return type.rawValue
    }
    
    public var speakableDescription: String {
        let desc = description(with: [.height, .direction])
        return "\(speakableName) \(desc)"
    }
}

extension Stair {
    public var speakableDescription: String {
        var heightDesc = "stairs, leading to height \(height), from "
        
        let neighbor = coordinate.neighbor(inDirection: heading)
        if neighbor.column == coordinate.column {
            heightDesc += "row \(neighbor.row)"
        }
        else {
            heightDesc += "column \(neighbor.column)"
        }
        return heightDesc
    }
}

extension Switch {
    public var speakableDescription: String {
        let switchState = isOn ? "open" : "closed"
        return "\(switchState) " + description(with: [.name, .height])
    }
}

extension Portal {
    public var speakableDescription: String {
        var desc = description(with: [.name, .height])
        if let connected = linkedPortal {
            desc += " connected to \(connected.coordinate.description)" + connected.description(with: [.height])
        }
        return desc
    }
}

extension Wall {
    public var speakableDescription: String {
        var desc = description(with: [.name, .height])
        for neighbor in coordinate.neighbors
            where blocksMovement(from: coordinate, to: neighbor) {
                desc += " blocking movement to \(neighbor.description), "
        }
        return desc
    }
}

extension Water {
    public var speakableDescription: String {
        return description(with: [.name])
    }
}

extension StartMarker {
    public var speakableDescription: String {
        return description(with: [.name, .height, .direction])
    }
}

extension Block {
    public var speakableDescription: String {
        return description(with: [.name, .height])
    }
}

extension Platform {
    public var speakableDescription: String {
        return description(with: [.name, .height])
    }
}

extension RandomNode {
    public var speakableDescription: String {
        return "random \(resemblingNode.description(with: [.name])) marker"
    }
}

extension Gem {
    public var speakableDescription: String {
        return description(with: [.name, .height])
    }
}

extension PlatformLock {
    public var speakableDescription: String {
        let baseInfo = description(with: [.name, .height])
        
        let platformsDesc = platforms.reduce("") { result, platform in
            return result + platform.speakableDescription
        }
        
        let controllingDesc = platformsDesc.isEmpty ? "" : " Controlling \(platformsDesc)"
        
        return baseInfo + controllingDesc
    }
}

