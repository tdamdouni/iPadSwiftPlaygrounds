//
//  LiveView.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current

page.liveView = SpiralViewController(initialRoulette: Roulette(trackRadius: 5.0,
                                                               wheelRadius: 1.0,
                                                               spokeLength: 1.0,
                                                               pathColor: UIColor.appleLogoGreen(),
                                                               trackColor: UIColor.appleLogoRed(),
                                                               spokeColor: UIColor.appleLogoOrange(),
                                                               wheelColor: UIColor.appleLogoYellow()))
