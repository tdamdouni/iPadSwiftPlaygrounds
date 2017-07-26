// 
//  RandomizedQueueObserver.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

public class RandomizedQueueObserver: CommandQueueDelegate {
    
    /// The counter which grabs a random Int from the provided range to determine when the handler should be called.
    var counter: Int
    
    let desiredRange: ClosedRange<Int>
    
    unowned var gridWorld: GridWorld
    
    let handler: (GridWorld) -> Void
    
    /// The range within which the action should be invoked. Since the range refers to the world's action queue, only positive (unsigned) ranges are supported.
    public init(randomRange: ClosedRange<Int> = 1...6, world: GridWorld, commandHandler: (GridWorld) -> Void) {
        gridWorld = world
        desiredRange = randomRange
        handler = commandHandler

        // Set an initial value for the counter.
        counter = randomNumber(fromRange: desiredRange)
        
        gridWorld.commandQueue.delegate = self
    }
    
    // MARK: CommandQueueDelegate
    
    func commandQueue(_ queue: CommandQueue, added _: Command) {
        let queueCount = queue.count
        if queueCount > counter {
            counter = queueCount + randomNumber(fromRange: desiredRange)
            
            // Ignore queue callbacks for any commands that are produced
            // as part of the handler.
            queue.delegate = nil
            handler(gridWorld)
            queue.delegate = self
        }
    }    
}

private func randomNumber(fromRange range: ClosedRange<Int>) -> Int {
    let min = range.lowerBound > 0 ? range.lowerBound : 1
    let max = range.upperBound
    return Int(arc4random_uniform(UInt32(max - min))) + min
}
