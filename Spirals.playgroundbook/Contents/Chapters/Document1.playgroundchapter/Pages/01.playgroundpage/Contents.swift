//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
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
/*:
 In this playground, you’ll learn how to draw mathematical shapes called [roulettes](https://en.wikipedia.org/wiki/Roulette_(curve)).
 
 A **roulette** is the path drawn by a point on a curve as it moves along another *fixed* curve. To see what this means, take a look at one of the simplest kinds of roulettes—the [cycloid](glossary://cycloid).
 
 ![Cycloid](Cycloid_2x.png)
 
 In the cycloid above, the thick, curved line, or **path**, is the actual roulette. The light-blue circle is the moving curve, or **wheel**, that draws the roulette shape. The thin, flat line near the bottom is the fixed curve (in this case, a straight line), or **track**, that the wheel moves on.
 
 **Tip:** You can pinch to zoom, tap to hide everything but the wheel, and drag with your finger to move your spiral around the screen.
 
 You’ll explore more complex roulettes in this playground, all built on the basic cycloid. Experiment below to visualize some completed roulettes before you move on to learning how to draw them on the [next page](@next). 
 */
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, hypocycloid, epicycloid, hypotrochoid, epitrochoid)
drawSpiral(/*#-editable-code*/.hypocycloid/*#-end-editable-code*/)
