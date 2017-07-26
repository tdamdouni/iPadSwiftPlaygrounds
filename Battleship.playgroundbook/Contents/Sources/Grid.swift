//
//  Grid.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import SpriteKit

public class Grid: SKScene {
    // MARK: Private properties
    
    public let columnCount: Int

    public let rowCount: Int
    
    private let grid = SKNode()
    
    private let border = SKShapeNode(path: CGPath(rect: .zero, transform: nil))
    
    private let tiles: [[Tile]]
    
    // MARK: Public properties
    
    weak var gridDelegate: GridDelegate?
    
    public override var size: CGSize {
        didSet {
            arrangeTiles()
        }
    }
    
    public let allTiles: [Tile]
    
    // MARK: Initialization
    
    override init(size: CGSize) {
        fatalError("Use init(pointSize: CGSize, coordinateSize: Int)")
    }
    
    required public init(coordinateSize: Int) {
        self.columnCount = coordinateSize
        self.rowCount = coordinateSize
        
        var tiles = [[Tile]]()
        for row in 0..<coordinateSize {
            var rowTiles = [Tile]()
            for column in 0..<coordinateSize {
                let coordinate = Coordinate(column: column, row: row)
                let tile = Tile(coordinate: coordinate, state: .unexplored)
                tile.anchorPoint = .zero
                
                rowTiles.append(tile)
            }
            
            tiles.append(rowTiles)
        }
        self.tiles = tiles
        self.allTiles = tiles.flatMap { $0 }
        
        super.init(size: .zero)
        
        backgroundColor = .clear
        addChild(grid)

        border.strokeColor = .white
        border.lineWidth = 1
        grid.addChild(border)
        
        tiles.joined().forEach { tile in
            tile.interactionDelegate = self
            tile.anchorPoint = .zero
            grid.addChild(tile)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: SKScene overrides
    
    public override func update(_ delta: TimeInterval) {
        super.update(delta)

        // TODO: Doing this because the didChageSize is never called with the final size
        arrangeTiles()
    }
    
    // MARK: Tile querying methods

    /// Ensures a coordinate is within the grid's tiles.
    public func coordinateIsValid(_ coordinate: Coordinate) -> Bool {
        return coordinate.row >= 0 && coordinate.row < rowCount && coordinate.column >= 0 && coordinate.column < columnCount
    }
    
    /// Returns the tile at the given row and column
    public func tileAt(row: Int, column: Int) -> Tile {
        let coordinate = Coordinate(column: column, row: row)
        return tileAt(coordinate)
    }
    
    /// Returns the tile at the given coordinate
    public func tileAt(_ coordinate: Coordinate) -> Tile {
        if !coordinateIsValid(coordinate) {
            return Tile(coordinate: coordinate, state: .invalid)
        }
        
        return tiles[coordinate.row][coordinate.column]
    }
    
    /// Returns a random coordinate within the grid with the specified state
    public func randomCoordinate(withState state: TileState = .unexplored) -> Coordinate {
        let possibleCoordinates = coordinates(withState: state)
        let length = possibleCoordinates.count
        
        return possibleCoordinates[Int(arc4random()) % length]
    }
    
    /// Returns the neighboring tiles for a given coordinate.
    public func neighbors(of coordinate: Coordinate) -> [Coordinate] {
        let possibleOptions = [
            Coordinate(column: coordinate.column, row: coordinate.row + 1),
            Coordinate(column: coordinate.column + 1, row: coordinate.row),
            Coordinate(column: coordinate.column, row: coordinate.row - 1),
            Coordinate(column: coordinate.column - 1, row: coordinate.row)
        ]
        
        return possibleOptions.filter { coordinateIsValid($0) }
    }

    /// Returns all the tiles with the given state in order from bottom left to top right.
    public func coordinates(withState state: TileState) -> [Coordinate] {
        return tiles.flatMap { tile in
            tile
        }.filter { tile in
            tile.state == state
        }.map { tile in
            tile.coordinate
        }
    }
    
    // MARK: Private convenience methods
    
    private func arrangeTiles() {
        // Calculate the size of the tiles so they're square and file in the space available.
        var totalGridDimension = min(size.height, size.width)
        let tileDimension = floor(totalGridDimension / CGFloat(rowCount))
        totalGridDimension = tileDimension * CGFloat(rowCount)

        // Position the grid anchor node at the bottom left of where the tiles should be placed.
        grid.position.x = (size.width / 2.0) - (totalGridDimension / 2.0)
        grid.position.y = size.height - totalGridDimension - border.lineWidth
        
        // Update the size and positions of the tiles.
        for column in 0 ..< columnCount {
            for row in 0 ..< rowCount {
                let tile = tileAt(row: row, column: column)

                tile.position = CGPoint(x: CGFloat(column) * tileDimension, y: CGFloat(row) * tileDimension)
                tile.size = CGSize(width: tileDimension, height: tileDimension)
            }
        }
        
        // Update the path used to draw a border around the grid.
        var borderRect: CGRect = .zero
        borderRect.size = CGSize(width: totalGridDimension, height: totalGridDimension)
        border.path = CGPath(rect: borderRect, transform: nil)
    }
}

extension Grid: TileInteractionDelegate {
    func didTapTile(_ tile: Tile) {
        gridDelegate?.baord(self, didTap: tile.coordinate)
    }
}

protocol GridDelegate: class {
    func baord(_ grid: Grid, didTap coordinate: Coordinate)
}
