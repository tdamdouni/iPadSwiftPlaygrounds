//
//  LiveView.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport

let page = PlaygroundPage.current

page.liveView = SpiralViewController(initialRoulette: Roulette.ellipse())
