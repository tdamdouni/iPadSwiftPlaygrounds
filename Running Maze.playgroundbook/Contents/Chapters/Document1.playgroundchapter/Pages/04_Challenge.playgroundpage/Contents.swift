//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Use the A* algorithm to escape the maze.
 
 The *A** (pronounced "A star") algorithm improves further over breadth-first search and finds short paths with even less searching.
 
  Because your goal is to find the shortest path, A* uses the current distance traveled combined with the estimated distance to the goal to determine the "cost". The tile with the lowest cost is explored at each stage of the algorithm.
 
 You can use the `manhattanDistance(to:)` method to estimate cost based on the distance to the goal, which returns the sum of the horizontal and vertical distance between the two tiles.
 
 1. Check a tile’s neighboring tiles and add them to a queue.
 
 2. As you go through the queue to get the next tile to check, look for the tile with the lowest cost.
 
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
    // Use the types, methods, and properties from the introduction page to write your own maze-solving code.
}

func bestCoordinate(in coordinates: [Coordinate], for maze: Maze) -> Coordinate {
    // Write a method to determine the best coordinate to search from an array of `Coordinates` and use it in your maze-solving code.
    return coordinates[0]
}

//#-end-editable-code

/*:
 Try switching the maze type from `.simple` to `.medium`, `.hard`, or `.impossible`. How does the A* algorithm compare to greedy best-first search on the different maze types?
 */

//#-editable-code
start(mazeType: .simple)
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
