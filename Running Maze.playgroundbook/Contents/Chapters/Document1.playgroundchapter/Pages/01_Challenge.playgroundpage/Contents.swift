//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:

 An app that moves someone from point A to point B on a map—whether to find the quickest route across town or make an enemy chase a hero in a game—uses a *pathfinding* algorithm. In this playground, you'll explore pathfinding algorithms to solve a maze made of floor tiles and wall tiles.
 
 Some pathfinding algorithms are more efficient than others because they look at less of the maze to find a path. Others are slower but find the shortest path. This playground explores two designs: breadth-first search and A* (pronounced "A star").
 
 In your code, you can check a tile to see if it's a floor tile, a wall tile, or the goal tile. You can also search for a tile’s four neighboring tiles (the tiles above, below, and to the left and right) until you find the goal tile.
 
 The code below doesn't solve every maze, but it shows you the types, methods, and properties you'll need to write your own maze-solving code on the next few pages.
 
 In the live view, tiles turn green after being searched through a call to searchNeighbors(of:). After your code runs, you'll see the number of tiles you searched and the length of the path you found.
 
 */
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /, (, ))
//#-code-completion(identifier, show, start, goal, coordinateIsValid(_:), details(for:), setDetails(_:for:), neighbors(of:), searchableNeighbors(of:))
//#-code-completion(identifier, show, Coordinate, column:row:), (column:row:), column, row)
//#-code-completion(identifier, show, type, isSearched, distanceFromStart, previousCoordinate)
//#-code-completion(identifier, show, CoordinateQueue, isEmpty, count, allCoordinates, add(_:), remove(_:), coordinate(at:), popFirstCoordinate())
//#-code-completion(identifier, show, empty, simple, medium, hard, impossible)
//#-code-completion(identifier, hide, start(mazeType:), showViewController(for:usercode:))
//#-hidden-code

public func start(mazeType: MazeType) {
    showViewController(for: mazeType, userCode: findPath)
}

//#-end-hidden-code
//#-editable-code
func findPath(in maze: Maze) {
    // Create a queue of coordinates and add the maze's start coordinate.
    var queue = CoordinateQueue()
    queue.add(maze.start)
    
    // Keep searching coordinates until the queue is empty.
    while !queue.isEmpty {
        let coord = queue.popFirstCoordinate()
        
        // Get the first neighbor.
        let neighbors = maze.searchNeighbors(of: coord)
        if neighbors.isEmpty {
            continue
        }
        let neighbor = neighbors[0]
        
        // If the neighbor coordinate is the goal tile, the path is complete.
        if neighbor == maze.goal {
            return
        }
        
        // Add the neighbor to the queue to search.
        queue.add(neighbor)
    }
}
//#-end-editable-code

/*:
 Check how the algorithm behaves in different situations by changing the maze type.
 */
//#-editable-code
start(mazeType: .empty)
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
