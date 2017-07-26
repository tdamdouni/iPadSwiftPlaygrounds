//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 The code below is an example of a breadth-first search that will solve the maze.
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
        // Get the next coordinate.
        let coord = queue.popFirstCoordinate()
        
        // Loop through the neighbors of the current coordinate.
        let neighbors = maze.searchNeighbors(of: coord)
        for neighbor in neighbors {
            // If the neighbor coordinate is the goal tile, the path is complete.
            if coord == maze.goal {
                return
            }
            
            // Add the neighbor to the queue to search.
            queue.add(neighbor)
        }
    }
}

start(mazeType: .medium)
//#-end-editable-code
//#-hidden-code
//#-end-hidden-code
