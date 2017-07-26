// 
//  Setup.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import UIKit

public let scene = Scene()

public func playgroundPrologue() {
    registerEvaluator(PageAssessment(), style: .discrete)
    assessmentController?.shouldStopPageAfterDiscreteAssessment = false
}


public func playgroundEpilogue() {
    performAssessment()
    scene.includeSystemTools = false
    scene.shouldHideTools = true
}
