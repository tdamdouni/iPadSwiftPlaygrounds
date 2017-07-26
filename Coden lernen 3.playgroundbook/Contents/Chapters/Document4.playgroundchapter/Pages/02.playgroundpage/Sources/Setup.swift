// 
//  Setup.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import UIKit

public let scene = Scene()

public func playgroundPrologue() {
    registerEvaluator(PageAssessment(), style: .continuous)
}


public func playgroundEpilogue() {
    performAssessment()
    scene.shouldHideTools = false
}
