// 
//  AccessibilityExtensions.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import SceneKit

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
    
    init(coordinate: Coordinate, inWorld world: GridWorld, view: UIView) {
        self.coordinate = coordinate
        self.world = world
        super.init(accessibilityContainer: view)
    }
    
}

// MARK: WorldViewController Accessibility

extension WorldViewController {
    
    func registerForAccessibilityNotifications() {
        NotificationCenter.default().addObserver(self, selector: #selector(voiceOverStatusChanged), name: Notification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
    }
    
    func unregisterForAccessibilityNotifications() {
        NotificationCenter.default().removeObserver(self, name: Notification.Name(rawValue: UIAccessibilityVoiceOverStatusChanged), object: nil)
    }
    
    func voiceOverStatusChanged() {
        DispatchQueue.main.async { [unowned self] in
            self.setVoiceOverForCurrentStatus()
        }
    }
    
    func setVoiceOverForCurrentStatus() {
        if UIAccessibilityIsVoiceOverRunning() {
            scnView.gesturesEnabled = false

            cameraController?.switchToOverheadView()
            configureAccessibilityElementsForGrid()
            
            // Add speedAdjust button manually because grid takes over view's `accessibilityElements`.
            speedAdjustButton.accessibilityLabel = "Speed adjustment"
            view.accessibilityElements?.append(speedAdjustButton)
            
            // Add an AccessibilityComponent to each actor.
            for actor in scene.actors {
                actor.addComponent(AccessibilityComponent.self)
            }
        }
        else {
            // Set for UITesting. 
            view.isAccessibilityElement = true
            view.accessibilityLabel = "The world is running."
            
            scnView.gesturesEnabled = true
            cameraController?.resetFromVoiceOver()
            
            for actor in scene.actors {
                actor.removeComponent(AccessibilityComponent.self)
            }
        }
    }
    
    func configureAccessibilityElementsForGrid() {
        view.isAccessibilityElement = false
        view.accessibilityElements = []
        
        for coordinate in scene.gridWorld.columnRowSortedCoordinates {
            let gridPosition = coordinate.position
            let rootPosition = scene.gridWorld.grid.scnNode.convertPosition(gridPosition, to: nil)
            
            let offset = WorldConfiguration.coordinateLength / 2
            let upperLeft = scnView.projectPoint(SCNVector3Make(rootPosition.x - offset, rootPosition.y, rootPosition.z - offset))
            let lowerRight = scnView.projectPoint(SCNVector3Make(rootPosition.x + offset, rootPosition.y, rootPosition.z + offset))
            
            let point = CGPoint(x: CGFloat(upperLeft.x), y: CGFloat(upperLeft.y))
            let size = CGSize (width: CGFloat(lowerRight.x - upperLeft.x), height: CGFloat(lowerRight.y - upperLeft.y))
            
            let element = CoordinateAccessibilityElement(coordinate: coordinate, inWorld: scene.gridWorld, view: view)
            element.accessibilityFrame = CGRect(origin: point, size: size)
            view.accessibilityElements?.append(element)
        }
    }
}

extension GridWorld {

    func speakableContents(of coordinate: Coordinate) -> String {
        // FIXME: Needs to use `height(:)`
        // Checks level of top block, otherwise equates to 0
        let prefix = "\(coordinate.description), "
        
        let contents = excludingNodes(ofType: Block.self, at: coordinate).reduce("") { str, node in
            var tileDescription = str
            
            switch node.identifier {
            case .actor:
                let actor = node as? Actor
                let name = actor?.type.rawValue ?? "Actor"
                tileDescription.append("\(name) at height \(node.level), ")
                
            case .stair:
                tileDescription.append("stair, facing \(node.heading), from level \(node.level - 1) to \(node.level), ")
                
            default:
                tileDescription.append("\(node.identifier.rawValue) at height \(node.level), ")
            }
            
            return tileDescription
        }
        
        let suffix = contents.isEmpty ? "is empty." : contents
        return prefix + suffix
    }
    
    func columnRowSortPredicate(_ coor1: Coordinate, _ coor2: Coordinate) -> Bool {
        if coor1.column == coor2.column {
            return coor1.row < coor2.row
        }
        return coor1.column < coor2.column
    }
    
    var columnRowSortedCoordinates: [Coordinate] {
        return allPossibleCoordinates.sorted(isOrderedBefore: columnRowSortPredicate)
    }
    
    var speakableDescription: String {
        let sortedItems = grid.allItemsInGrid.sorted { item1, item2 in
            return columnRowSortPredicate(item1.coordinate, item2.coordinate)
        }
        
        let actors = sortedItems.flatMap { $0 as? Actor }
        let randomIdentifiers = sortedItems.filter { $0.identifier == .randomNode }
        let goals = sortedItems.filter {
            switch $0.identifier {
            case .switch, .portal, .item, .platformLock: return true
            default: return false
            }
        }
        
        var description = "The world is \(columnCount) columns by \(rowCount) rows. "
        if actors.isEmpty {
            description += "There is no character placed in this world. You must place your own."
        }
        else {
            for node in actors {
                let name = node.type.rawValue
                description += "\(name) starts at \(node.locationDescription)."
            }
        }
        
        if !goals.isEmpty {
            description += " The important locations are: "
            for (index, goalNode) in goals.enumerated() {
                description += "\(goalNode.identifier.rawValue) at \(goalNode.locationDescription)"
                description += index == goals.endIndex ? "." : "; "
            }
        }
        
        if !randomIdentifiers.isEmpty {
            description += " Random items at: "
            for (index, objectNode) in randomIdentifiers.enumerated() {
                description += "\(objectNode.identifier.rawValue) at \(objectNode.locationDescription)"
                description += index == randomIdentifiers.endIndex ? "." : "; "
            }
        }
        
        return description
    }
}

extension Actor {
    
    var speakableName: String {
        return type.rawValue
    }
}

extension Item {
    
    var locationDescription: String{
        return "\(coordinate.description), height \(level)"
    }
}

