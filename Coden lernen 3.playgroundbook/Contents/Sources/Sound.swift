// 
//  Sound.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

/// An enum of all the different sounds that can be played. These include: bark, bluDance, bluLookAround, bluHeadScratch, bluOops, boing, data, electricity, hat, horse, knock, owl, phone, pop, snare, tennis, tick, tumble, walrus, wap and warp.
public enum Sound {
    
    case bark, bluDance, bluLookAround, bluHeadScratch, bluOops, boing, data, electricity, hat, horse, knock, owl, phone, pop, snare, tennis, tick, tumble, walrus, wap, warp
    
    var url : URL? {
        
        var fileName: String?
        
        switch self {
        case .bark:
            fileName = "Bark"
        case .bluDance:
            fileName = "Blu_CelebrationDance"
        case .bluLookAround:
            fileName = "Blu_BreatheLookAround"
        case .bluHeadScratch:
            fileName = "Blu_HeadScratch"
        case .bluOops:
            fileName = "Blu_AlmostFallOffEdge"
        case .boing:
            fileName = "Cartoon Space Boing"
        case .data:
            fileName = "Computer Data 02"
        case .electricity:
            fileName = "Electricity Surge"
        case .hat:
            fileName = "Vox Kit 1 Hat 069"
        case .horse:
            fileName = "Horse Whinny"
        case .knock:
            fileName = "Door Knock"
        case .owl:
            fileName = "Owl"
        case .phone:
            fileName = "Cell Phone Ringing"
        case .pop:
            fileName = "Bottle Cork"
        case .snare:
            fileName = "Vox Kit 1 Snare 068"
        case .tennis:
            fileName = "Tennis Serve"
        case .tick:
            fileName = "Clock Tick"
        case .tumble:
            fileName = "Cartoon Tumble Down"
        case .walrus:
            fileName = "Walrus Roar"
        case .wap:
            fileName = "Comedy Wap"
        case .warp:
            fileName = "Warp Engineering 01"
        }
        guard let resourceName = fileName else { return nil }
        
        return Bundle.main.url(forResource: resourceName, withExtension: "wav")
    }
}

