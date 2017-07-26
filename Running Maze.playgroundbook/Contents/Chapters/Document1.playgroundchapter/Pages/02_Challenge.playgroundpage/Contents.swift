//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 
 **Goal:** Use a breadth-first search algorithm to escape the maze.
 
 *Breadth-first search* is a type of pathfinding algorithm. In the name of this algorithm, *breadth* refers to the number of things it checks at each step in the search. When the algorithm looks at a tile, it also checks all four of its neighbors, searching a broad area to find a path.
 
 1. Start by adding all neighbors of the starting tile to a queue.
 
 2. Pop tiles from the queue to see what kind of tiles they are.
 
 3. Each time you pop a tile from the queue, add *all* of that tile's neighbors to the queue.

 
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
//#-end-editable-code

/*:
 After your code solves the maze, try changing the maze type from `.simple` to `.medium`, `.hard`, or `.impossible`. Does your code still solve the maze? Compare the number of searches to the size of the maze and the length of the path your code finds.
 */

//#-editable-code
start(mazeType: .simple)
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
