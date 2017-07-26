// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
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
