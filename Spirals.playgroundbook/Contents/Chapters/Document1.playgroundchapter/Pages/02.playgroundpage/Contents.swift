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

private var trackRadius = 5.0
private var wheelRadius = 1.0

func drawSpiral() {
    // Intentionally setting the wheelRadius as the "spokeLength" here,
    // since cycloids always have spokeLength = wheelRadius
    let cycloid = Roulette(trackRadius: trackRadius,
                           wheelRadius: wheelRadius,
                           spokeLength: abs(wheelRadius))
    proxy?.send(cycloid.playgroundValue)
}

//#-end-hidden-code
/*:
 **Goal:** Create a hypocycloid.
 
 In the image on the previous page, the cycloid was drawn by a wheel moving along a flat track, like a bicycle tire rolling along the ground. Now, imagine that instead of rolling along a flat track, the wheel rolls along a curved one—maybe the inside of another circle?
 
 You've just imagined a [hypocycloid](https://en.wikipedia.org/wiki/Hypocycloid). Look at the live view. Can you see how the flat track from the previous page has been rolled up into a circle so the wheel rolls *inside* it? In fact, the prefix *hypo-* means: *under* or *beneath*, and you can think of the wheel as rolling *beneath* the track!
 
 **Experiment:** Edit the values below to see how the hypocycloid changes as the size of the circles change. 
 
 When you're ready, go on to the [next page](@next).
 */
//#-code-completion(everything, hide)
// This is the radius of the fixed circle.
trackRadius = /*#-editable-code*/5.0/*#-end-editable-code*/

// This is the radius of the moving circle.
wheelRadius = /*#-editable-code*/1.0/*#-end-editable-code*/

drawSpiral()

//#-hidden-code
// Hint checking
var hints = [String]()

// If the wheel radius is less than or equal to 1% smaller or larger than the track radius
if (abs(wheelRadius) < abs(trackRadius) && wheelRadius / trackRadius >= 0.99) ||
    (abs(trackRadius) < abs(wheelRadius) && trackRadius / wheelRadius >= 0.99) ||
    trackRadius == wheelRadius {
    hints.append(Hints.similarRadiiHint)
}

if trackRadius == 0 || wheelRadius == 0 {
    hints.append(Hints.zeroHint)
}

if abs(trackRadius / wheelRadius) == 2 {
    hints.append(Hints.straightLineHint)
}

if abs(trackRadius / wheelRadius) < 0.01 {
    hints.append(Hints.disparateValuesHint)
}

if trackRadius < 0 || wheelRadius < 0 {
    hints.append(Hints.negativeValueHint)
}

if hints.isEmpty {
    if let currentStatus = PlaygroundPage.current.assessmentStatus, case .pass = currentStatus {
        //Avoid setting assessment status if it's already marked as pass.
    } else {
        if (-0.1 < wheelRadius && wheelRadius < 0.1 && wheelRadius != 0)
            || (-0.1 < trackRadius && trackRadius < 0.1 && trackRadius != 0) {
            page.assessmentStatus = .pass(message: Hints.edgeCaseSuccess)
        } else {
            page.assessmentStatus = .pass(message: nil)
        }
    }
} else {
    // Show hints
    page.assessmentStatus = .fail(hints: hints, solution: nil)
}

//#-end-hidden-code
