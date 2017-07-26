//
//  LiveView.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let shiftingPracticeViewController : ShiftingPracticeViewController = ShiftingPracticeViewController.instantiateFromMainStoryboard()
page.liveView = shiftingPracticeViewController
