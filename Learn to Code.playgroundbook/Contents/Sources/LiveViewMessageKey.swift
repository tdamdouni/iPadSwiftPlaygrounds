// 
//  LiveViewMessageKey.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport

struct LiveViewMessageKey {
    
    static let finishedSendingCommands = "FinishedSendingCommands"
    
    // The message key sent from the
    // LiveView process indicating that the world is complete.
    // Form: [String - finishedEvaluating: Bool - success]
    static let finishedEvaluating = "FinishedEvaluating"
}
