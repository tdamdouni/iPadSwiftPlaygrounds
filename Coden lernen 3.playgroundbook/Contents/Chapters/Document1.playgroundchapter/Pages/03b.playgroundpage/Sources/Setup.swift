// 
//  Setup.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import UIKit

public let scene = Scene()

public func playgroundPrologue() {
    registerEvaluator(PageAssessment(), style: .discrete)
    scene.useOverlay(overlay: .cosmicBus)
}


public func playgroundEpilogue() {
    performAssessment()
    scene.includeSystemTools = false
    scene.shouldHideTools = true
}
