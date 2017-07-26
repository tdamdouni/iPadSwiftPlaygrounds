//
//  AccessibilityExtensions.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
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
            return NSLocalizedString("To repeat this description, tap outside of the world grid.", comment: "AX hint")
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
                where actor.component(ofType: AccessibilityComponent<Actor>.self) == nil {
                    actor.addComponent(AccessibilityComponent<Actor>(component: actor))
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

            if scene.gridWorld.component(ofType: AccessibilityComponent<GridWorld>.self) == nil {
                scene.gridWorld.addComponent(AccessibilityComponent<GridWorld>(component: scene.gridWorld))
            }
        }
        else {
            scnView.gesturesEnabled = true
            cameraController?.resetFromVoiceOver()
            
            for actor in scene.actors {
                actor.removeComponent(ofType: AccessibilityComponent<Actor>.self)
            }

            scene.gridWorld.removeComponent(ofType: AccessibilityComponent<GridWorld>.self)
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
        var description = String(format: NSLocalizedString("The world is %d columns by %d rows. ", comment: "AX world description"), columnCount, rowCount)
        description += speakableActorLocations() + "."
        description += String(format: NSLocalizedString("The goals are: %@", comment: "AX world description. 'goals' will be a list of complete sentences filled in based on the objectives of the currently loaded world"), speakableGoalLocations())
        description += speakableRandomLocations()
        
        return description
    }
    
    // MARK: Specific queries
    
    func speakableActorLocations() -> String {
        let actors = grid.actors.sorted(by: columnRowSortPredicate)
        
        if actors.isEmpty {
            return NSLocalizedString("There is no character in this world. You must place your own.", comment: "AX world description")
        }
        
        return actors.reduce("") { result, actor in
            result + String(format: NSLocalizedString("%@ on %@", comment: "AX world description. This is describing the location of a thing. {foo} on {coordinate}"), actor.speakableDescription, actor.locationDescription)
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
            return NSLocalizedString("No switches or gems found.", comment: "AX world description")
        }
        
        var goalDescription = ""
        for (index, item) in goals.enumerated() {
            goalDescription += String(format: NSLocalizedString("%@ on %@", comment: "AX world description. This is describing the location of a thing. {foo} on {coordinate}"), item.speakableDescription, item.locationDescription)
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
            description += String(format: NSLocalizedString("%@ on %@", comment: "AX world description. This is describing the location of a thing. {foo} on {coordinate}"), item.speakableDescription, item.locationDescription)
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
                suffix = ". " + NSLocalizedString("Double-tap to switch characters.", comment: "AX world description")
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
            return NSLocalizedString("is unreachable.", comment: "AX world description. The subject that 'is unreachable' is defined dynamically. e.g., {thing},{row x col y}, is unreachable.")
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

