//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func drawSpiral(_ type: RouletteType) {
    switch type {
    case .hypocycloid:
        proxy?.send(Roulette.hypocycloid().playgroundValue)
    case .epicycloid:
        proxy?.send(Roulette.epicycloid().playgroundValue)
    case .hypotrochoid:
        proxy?.send(Roulette.hypotrochoid().playgroundValue)
    case .epitrochoid:
        proxy?.send(Roulette.epitrochoid().playgroundValue)
    default:
        return
    }
}
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 In this playground, you’ll learn how to draw mathematical shapes called roulettes.
 
 A **roulette** is the path drawn by a point on a curve as it moves along another *fixed* curve. To see what this means, take a look at one of the simplest kinds of roulettes—the [cycloid](glossary://cycloid).
 
 ![Cycloid](Cycloid_2x.png)
 
 In the cycloid above, the thick, curved line, or **path**, is the actual roulette. The light-blue circle is the moving curve, or **wheel**, that draws the roulette shape. The thin, flat line near the bottom is the fixed curve (in this case, a straight line), or **track**, that the wheel moves on.
 
 * callout(Tip):
 You can pinch to zoom, tap to hide everything but the spiral itself, and drag with your finger to move your spiral around the screen.
 
 You’ll explore more complex roulettes in this playground, all built on the basic cycloid. Experiment below to visualize some completed roulettes before you move on to learning how to draw them on the [next page](@next). 
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, hypocycloid, epicycloid, hypotrochoid, epitrochoid)
drawSpiral(/*#-editable-code*/.hypocycloid/*#-end-editable-code*/)
