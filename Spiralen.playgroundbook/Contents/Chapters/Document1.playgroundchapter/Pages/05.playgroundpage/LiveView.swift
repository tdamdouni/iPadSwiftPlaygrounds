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
                                                               spokeLength: 5.0,
                                                               pathColor: UIColor.appleLogoOrange(),
                                                               trackColor: UIColor.appleLogoPurple(),
                                                               spokeColor: UIColor.appleLogoRed(),
                                                               wheelColor: UIColor.appleLogoBlue()))

