//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import PlaygroundSupport

private let changeWheelRadiusToNegativeHint = NSLocalizedString("To create an epitrochoid, you need to change the `wheelRadius` value to a *negative* number. An epitrochoid's wheel rolls around the *exterior* of the track.", comment: "Change wheelRadius to negative hint.")
private let successMessage = NSLocalizedString("Awesome! You've mastered the—*ahem*—**ins** and **outs** of roulettes! Ready for the [next page](@next)?", comment: "Success message for epitrochoid solution.")

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

private var trackRadius = 5.0
private var wheelRadius = 3.0
private var spokeLength = 5.0
private var pathColor = UIColor.appleLogoOrange()
private var trackColor = UIColor.appleLogoPurple()
private var spokeColor = UIColor.appleLogoRed()
private var wheelColor = UIColor.appleLogoBlue()

func drawSpiral() {
    let cycloid = Roulette(trackRadius: trackRadius,
                           wheelRadius: wheelRadius,
                           spokeLength: spokeLength,
                             pathColor: pathColor,
                             trackColor: trackColor,
                             spokeColor: spokeColor,
                             wheelColor: wheelColor)
    proxy?.send(cycloid.playgroundValue)
}
//#-end-hidden-code
/*:
 **Goal:** Create an epitrochoid.
 
 If both **hypo**cycloids and **epi**cycloids exist, shouldn't there be an **epi**trochoid to go with the **hypo**trochoid from the previous page?
 
 Yes! An [epitrochoid](https://en.wikipedia.org/wiki/Epitrochoid) is similar to a hypotrochoid, except the wheel rolls around the *outside* of the track (remember what the *epi-* prefix means). And, as with the hypotrochoid, its spoke length is flexible.
 
 **Tip:** Right now, `wheelRadius` is set to a *positive* value, and you're seeing a hypotrochoid. How do you need to edit the code to create an epitrochoid?
 */
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color)
// To create an epitrochoid, you need to change this value:
wheelRadius = /*#-editable-code*/3/*#-end-editable-code*/

// Remember, now that you're working with trochoids, the spokeLength is flexible. Change it up!
spokeLength = /*#-editable-code*/5/*#-end-editable-code*/

// Have fun customizing!
trackRadius = /*#-editable-code*/5/*#-end-editable-code*/
pathColor = /*#-editable-code*/#colorLiteral(red: 0.9607843137, green: 0.5098039216, blue: 0.1215686275, alpha: 1)/*#-end-editable-code*/
trackColor = /*#-editable-code*/#colorLiteral(red: 0.5882352941, green: 0.2392156863, blue: 0.5921568627, alpha: 1)/*#-end-editable-code*/
spokeColor = /*#-editable-code*/#colorLiteral(red: 0.8941176471, green: 0.2117647059, blue: 0.2431372549, alpha: 1)/*#-end-editable-code*/
wheelColor = /*#-editable-code*/#colorLiteral(red: 0.002151125809, green: 0.617736578, blue: 0.8608769774, alpha: 1)/*#-end-editable-code*/

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

if wheelRadius > 0 {
    hints.append(changeWheelRadiusToNegativeHint)
}

if trackRadius == 0 || wheelRadius == 0 || spokeLength == 0 {
    hints.append(Hints.zeroHint)
}

if trackRadius / wheelRadius == 2 {
    hints.append(Hints.straightLineHint)
}

if trackRadius < 0 {
    hints.append(Hints.negativeValueHint)
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
            page.assessmentStatus = .pass(message: successMessage)
        }
    }
} else {
    // Show hints
    page.assessmentStatus = .fail(hints: hints, solution: nil)
}

//#-end-hidden-code
