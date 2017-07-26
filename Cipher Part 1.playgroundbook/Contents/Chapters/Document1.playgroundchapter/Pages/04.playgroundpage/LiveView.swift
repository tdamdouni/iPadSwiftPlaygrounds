//
//  LiveView.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let substitutionCipherViewController: SubstitutionCipherViewController = SubstitutionCipherViewController.instantiateFromMainStoryboard()
page.liveView = substitutionCipherViewController
