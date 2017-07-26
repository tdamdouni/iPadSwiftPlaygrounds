//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

private let negativeWheelHint = NSLocalizedString("To create an epicycloid, give `wheelRadius` a negative value.", comment: "Wheel radius hint for epicycloid solution.")

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

private var trackRadius = 5.0
private var wheelRadius = -1.0
private var pathColor = UIColor.appleLogoYellow()
private var trackColor = UIColor.appleLogoRed()

func drawSpiral() {
    let cycloid = Roulette(trackRadius: trackRadius,
                           wheelRadius: wheelRadius,
                           spokeLength: abs(wheelRadius),
                             pathColor: pathColor,
                            trackColor: trackColor,
                            spokeColor: UIColor.appleLogoBlue())
    proxy?.send(cycloid.playgroundValue)
}

//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Create an epicycloid.
 
 On the previous page, you learned how to draw a hypocycloid. You also learned how it's different from a cycloid—the track is a curved circle instead of a flat line.
 
 Here, you can play with a new kind of spiral—an epicycloid. Can you tell how this shape and the hypocycloid are similar? How they're different?
 
 Time for a bit more [etymology](glossary://etymology)! Recall that the prefix *hypo-* means *under* or *beneath*. Well, the prefix *epi-* means *on* or *above*. So the only difference between the hypocycloid from the previous page and this new epicycloid is that here, the wheel rolls along the *outside* of the circle (above the track!).
 
 All you need to do to turn a hypo- shape into an epi- shape is use a negative value for the `wheelRadius`!
 
 * experiment: 
 Edit the values here like you did before.
 
 When you're ready, head to the [next page](@next) for a new kind of spiral!
 */
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color)
// Change up some of the colors!
pathColor = /*#-editable-code*/#colorLiteral(red: 0.9921568627, green: 0.7215686275, blue: 0.1529411765, alpha: 1)/*#-end-editable-code*/
trackColor = /*#-editable-code*/#colorLiteral(red: 0.8941176471, green: 0.2117647059, blue: 0.2431372549, alpha: 1)/*#-end-editable-code*/

// Try using a decimal number, or "Double", like 4.3 or 10.2
trackRadius = /*#-editable-code*/5.0/*#-end-editable-code*/

// Use a negative value here to draw the wheel on the outside of the track instead of the inside
wheelRadius = /*#-editable-code*/-1.0/*#-end-editable-code*/

drawSpiral()

//#-hidden-code
// Hint checking
var hints = [String]()

if wheelRadius > 0 {
    hints.append(negativeWheelHint)
}

// If the wheel radius is less than or equal to 1% smaller or larger than the track radius
if (abs(wheelRadius) < abs(trackRadius) && wheelRadius / trackRadius >= 0.99) ||
    (abs(trackRadius) < abs(wheelRadius) && trackRadius / wheelRadius >= 0.99) ||
    trackRadius == wheelRadius {
    hints.append(Hints.similarRadiiHint)
}

if trackRadius < 0 {
    hints.append(Hints.negativeValueHint)
}

if trackRadius / wheelRadius == 2 {
    hints.append(Hints.straightLineHint)
}

if trackRadius == 0 || wheelRadius == 0 {
    hints.append(Hints.zeroHint)
}

if abs(trackRadius / wheelRadius) < 0.01 {
    hints.append(Hints.disparateValuesHint)
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
