//
//  LiveView.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
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
