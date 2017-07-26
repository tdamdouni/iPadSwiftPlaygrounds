// 
//  SCNNode+Naming.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

extension SCNNode {
    
    static var separator: String {
        return "-"
    }
    
    /*
     A game node is identified with the following naming scheme:
     "<WorldNodeIdentifier>-<column>-<row>"
     
     e.g. "Item-8-7"
     */
    var identifierComponents: [String] {
        return name?.components(separatedBy: SCNNode.separator) ?? []
    }
    
    var identifier: WorldNodeIdentifier? {
        let prefix = identifierComponents.first ?? ""
        return WorldNodeIdentifier(rawValue: prefix)
    }
    
    var coordinateFromName: Coordinate? {
        let components = identifierComponents
        guard components.count >= 3,
         let row = Int(components[2]),
         let col = Int(components[1]) else { return nil }

        return Coordinate(column: col, row: row)
    }
    
    func setName(forCoordinate coordinate: Coordinate) {
        let identifier = identifierComponents.first ?? ""
        self.name = identifier + coordinate.namingSuffix
    }
    
    // MARK:
    
    /// Non-recursive search for childNodes with the `WorldNodeIdentifier` prefix.
    func childNodesWithIdentifier(_ identifier: WorldNodeIdentifier) -> [SCNNode] {
        return childNodes.filter {
            $0.identifier == identifier
        }
    }
    
    public func anscestorNode(named nodeName:String) ->SCNNode? {
        var node: SCNNode? = self
        while node != nil {
            if node!.name == nodeName {
                return node
            }
            node = node?.parent
        }
        
        return nil
    }
    
}

extension Coordinate {
    /// Used to uniquely identify every node type at each coordinate.
    var namingSuffix: String {
        return SCNNode.separator + "\(column)" + SCNNode.separator + "\(row)"
    }
}
