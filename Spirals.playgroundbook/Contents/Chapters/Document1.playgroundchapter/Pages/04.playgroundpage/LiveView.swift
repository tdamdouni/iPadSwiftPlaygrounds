//
//  LiveView.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current

page.liveView = SpiralViewController(initialRoulette: Roulette(trackRadius: 5.0,
                                                               wheelRadius: 3.0,
                                                               spokeLength: 3.0,
                                                               pathColor: UIColor.appleLogoGreen(),
                                                               trackColor: UIColor.appleLogoBlue(),
                                                               spokeColor: UIColor.appleLogoPurple(),
                                                               wheelColor: UIColor.appleLogoOrange()))
