//
//  LiveView.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport

let page = PlaygroundPage.current

page.liveView = SpiralViewController(initialRoulette: Roulette(trackRadius: 5.0,
                                                               wheelRadius: 1.0,
                                                               spokeLength: 1.0))



