//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 The code below is an example of an A* search that will solve the maze.
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
        // Remove the cheapest coordinate from the queue.
        let coord = bestCoordinate(in: queue.allCoordinates, for: maze)
        queue.remove(coord)
        
        // If the coordinate is the goal tile, the path is complete.
        if coord == maze.goal {
            return
        }
        
        // Loop through the neighbors of the current coordinate.
        let neighbors = maze.searchNeighbors(of: coord)
        for neighbor in neighbors {
            // Add the neighbor to the queue to search.
            queue.add(neighbor)
        }
    }
}

func bestCoordinate(in coordinates: [Coordinate], for maze: Maze) -> Coordinate {
    // Loop through the coordinates to determine which is the best to search.
    var closest = coordinates[0]
    for coord in coordinates {
        // Calculate a cost for each coordinate using the `manhattanDistance(to:)` method and the coordinate's distance from the start.
        let costA = closest.manhattanDistance(to: maze.goal) + maze.pathDistance(to: closest)
        let costB = coord.manhattanDistance(to: maze.goal) + maze.pathDistance(to: coord)
        
        if costB < costA {
            closest = coord
        }
    }
    
    return closest
}

start(mazeType: .medium)
//#-end-editable-code
//#-hidden-code

//#-end-hidden-code
