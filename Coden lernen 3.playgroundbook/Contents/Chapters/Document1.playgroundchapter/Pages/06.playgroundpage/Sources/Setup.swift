// 
//  Setup.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import UIKit

public let scene = Scene()

public func playgroundPrologue() {
    scene.shouldHideTools = true
    scene.useOverlay(overlay: .gridWithCoordinates)
    registerEvaluator(PageAssessment(), style: .discrete)
}


public func playgroundEpilogue() {
    performAssessment()
}
