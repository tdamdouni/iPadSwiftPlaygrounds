// 
//  RandomizedQueueObserver.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

public class RandomizedQueueObserver: CommandQueuePerformingDelegate {
    
    /// The counter which grabs a random Int from the provided range to determine when the handler should be called.
    var counter: Int
    
    let desiredRange: ClosedRange<Int>
    
    unowned var gridWorld: GridWorld
    
    let handler: (GridWorld) -> Void
    
    /// The range within which the action should be invoked. Since the range refers to the world's action queue, only positive (unsigned) ranges are supported.
    public init(randomRange: ClosedRange<Int> = 1...6, world: GridWorld, commandHandler: @escaping (GridWorld) -> Void) {
        gridWorld = world
        desiredRange = randomRange
        handler = commandHandler

        // Set an initial value for the counter.
        counter = randomNumber(fromRange: desiredRange)
        
        gridWorld.commandQueue.performingDelegate = self
    }
    
    // MARK: CommandQueueDelegate
    
    func commandQueue(_ queue: CommandQueue, added _: Command) {
        let queueCount = queue.count
        if queueCount > counter {
            counter = queueCount + randomNumber(fromRange: desiredRange)
            
            sender?.shouldWaitForResponse = false
            
            // Ignore queue callbacks for any commands that are produced
            // as part of the handler.
            queue.performingDelegate = nil
            handler(gridWorld)
            queue.performingDelegate = self
            
            sender?.shouldWaitForResponse = true
        }
    }
    
    func commandQueue(_ queue: CommandQueue, willPerform _: Command) {}
    func commandQueue(_ queue: CommandQueue, didPerform _: Command) {}
}

private func randomNumber(fromRange range: ClosedRange<Int>) -> Int {
    let min = range.lowerBound > 0 ? range.lowerBound : 1
    let max = range.upperBound
    return Int(arc4random_uniform(UInt32(max - min))) + min
}
