//
//  Tile.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit
import SpriteKit


/**
 This class represents one tile on the grid. As well as handling all the visual
 aspects of a tile, the class handle touch events so the game can be played
 through touch.
 */
public class Tile: SKSpriteNode {
    // MARK: Properties
    
    static private let borderWidth = CGFloat(0.5)
    
    private let border = SKShapeNode(path: CGPath(rect: .zero, transform: nil))
    
    var ship: Ship?
    
    weak var stateNode: SKSpriteNode?
    
    /// The tile's coordinate on the game grid.
    public let coordinate: Coordinate
    
    /// The current state of the tile. You can use this to see if the tile is unexplored, hit, missed, suggested, or invalid.
    public var state: TileState {
        didSet {
            // Remove any existsing state node.
            stateNode?.removeFromParent()
            
            // Determine the new node to show.
            var newNode: SKSpriteNode?
            
            switch state {
            case .hit:
                newNode = SKSpriteNode(imageNamed: "Hit")
                
            case .miss:
                newNode = SKSpriteNode(imageNamed: "Miss")
                
            case .unexplored:
                break
                
            case .suggested:
                newNode = SKSpriteNode(imageNamed: "Target")
                
            case .invalid:
                break
            }
            
            if let newNode = newNode {
                // Add the new node and size it as necessary.
                newNode.anchorPoint = .zero
                newNode.position.x = Tile.borderWidth
                newNode.position.y = Tile.borderWidth
                newNode.zPosition = CGFloat(100 - coordinate.row)
                
                addChild(newNode)
                stateNode = newNode
                updateStateNode()
            }
        }
    }
    
    /// The dimensions of the tile in points.
    public override var size: CGSize {
        didSet {
            border.path = CGPath(rect: CGRect(origin: .zero, size: size), transform: nil)
            updateStateNode()
        }
    }

    weak var interactionDelegate: TileInteractionDelegate?
    
    // MARK: Initialization
    
    convenience public init() {
        self.init(coordinate: .invalid, state: .invalid)
    }
    
    init(coordinate: Coordinate, state: TileState) {
        self.coordinate = coordinate
        self.state = state
        
        super.init(texture: nil, color: .clear, size: .zero)
        
        border.strokeColor = UIColor(white: 1.0, alpha: 0.5)
        border.lineWidth = Tile.borderWidth
        addChild(border)
        
        isUserInteractionEnabled = true
    }

    override public init(texture: SKTexture?, color: UIColor, size: CGSize) {
        fatalError("init(texture: color: size:) has not been implemented")
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override var description: String {
        return "\(super.description) - \(state)"
    }

    // MARK: Touch handlers
    
    /// Allows the user to play the game by touching the grid.
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        interactionDelegate?.didTapTile(self)
    }
    
    // MARK: Convenience
    
    private func updateStateNode() {
        guard let stateNode = stateNode else { return }
        
        // Inset the available size to allow for the tile's border.
        let tileSize = size.width - Tile.borderWidth * 2
        
        // Fit the state node's width to fit use its aspect ration to determine its height.
        let ratio = stateNode.size.height / stateNode.size.width
        stateNode.size.width = tileSize
        stateNode.size.height = tileSize * ratio
    }
}

protocol TileInteractionDelegate: class {
    func didTapTile(_ tile: Tile)
}
