//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import UIKit
import PlaygroundSupport

private let hypotrochoidHint = NSLocalizedString("To create a hypotrochoid whose wheel moves around the *inside* of its track, set the `wheelRadius` to a positive value.", comment: "First hint for ellipse solution.")
private let radiiHint = NSLocalizedString("To create an ellipse, `trackRadius` has to be twice as long as `wheelRadius`. If `wheelRadius` is 3, what does `trackRadius` have to be?", comment: "Second hint for ellipse solution.")
private let spokeHint = NSLocalizedString("Is `spokeLength` longer or shorter than `wheelRadius`? If it's the same length, you'll end up with a straight line.", comment: "Third hint for ellipse solution.")
private let solutionString = NSLocalizedString("The values in this solution are just examples. As long as you follow the mathematical steps in the recipe, it doesn't matter what you pick for the numbers.\n\n `trackRadius = 6`\n\n `wheelRadius = 3`\n\n `spokeLength = 4`", comment: "Solution for ellipse page.")
private let successMessage = NSLocalizedString("Congratulations! You've created an ellipse, and you're well on your way to mastering all kinds of spirals! Use the [next page](@next) to create, experiment, and have fun making beautiful designs 😁.", comment: "Success message for ellipse page.")

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

private var trackRadius = 6.0
private var wheelRadius = 3.0
private var spokeLength = 2.0
private var pathColor = UIColor.appleLogoBlue()
private var trackColor = UIColor.appleLogoRed()
private var spokeColor = UIColor.appleLogoGreen()
private var wheelColor = UIColor.appleLogoYellow()

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
 **Goal:** Create an ellipse.
 
 You now have all the ingredients you need to create trochoids and cycloids, of both the *hypo-* and *epi-* varieties. Your final challenge is to figure out how to draw a very special shape-an [ellipse](https://en.wikipedia.org/wiki/Ellipse).
 
 Although they don't look as exciting as the spirals from the previous pages, ellipses are pretty amazing. All the planets in our solar system move around the sun in elliptical orbits! In fact, the moon, the sun itself, and all the stars you can see in the sky move along their own elliptical paths through the universe.
 
 Are you ready to try making an ellipse of your own? Here's the recipe:
 
 1) The track radius is *exactly twice as long* as the wheel radius.
 2) An ellipse is a special type of *hypotrochoid*.
 3) The spoke length is either greater than or less than the wheel radius.
 
 **Tip:** The ellipse you're seeing in the live view is just one possibility. Yours might be long and thin, or short and fat, or even vertical! Good luck!
 */
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color)
// This needs to be *twice as long* as the wheelRadius
trackRadius = /*#-editable-code*/<#T##radius##Double#>/*#-end-editable-code*/

// Is the wheelRadius for a hypotrochoid positive or negative?
wheelRadius = /*#-editable-code*/<#T##radius##Double#>/*#-end-editable-code*/

// Make sure this isn't equal to the wheelRadius!
spokeLength = /*#-editable-code*/<#T##length##Int#>/*#-end-editable-code*/

// And customize!
pathColor = /*#-editable-code*/#colorLiteral(red: 0.002151125809, green: 0.617736578, blue: 0.8608769774, alpha: 1)/*#-end-editable-code*/
trackColor = /*#-editable-code*/#colorLiteral(red: 0.8941176471, green: 0.2117647059, blue: 0.2431372549, alpha: 1)/*#-end-editable-code*/
spokeColor = /*#-editable-code*/#colorLiteral(red: 0.3823705912, green: 0.7347578406, blue: 0.2736029625, alpha: 1)/*#-end-editable-code*/
wheelColor = /*#-editable-code*/#colorLiteral(red: 0.9921568627, green: 0.7215686275, blue: 0.1529411765, alpha: 1)/*#-end-editable-code*/

drawSpiral()

//#-hidden-code
//This will check their values and provide basic assessment

var hints = [String]()

if trackRadius / wheelRadius != 2 {
    hints.append(radiiHint)
}

if spokeLength == wheelRadius {
    hints.append(spokeHint)
}

// If the wheel radius is less than or equal to 1% smaller or larger than the track radius
if (abs(wheelRadius) < abs(trackRadius) && wheelRadius / trackRadius >= 0.99) ||
    (abs(trackRadius) < abs(wheelRadius) && trackRadius / wheelRadius >= 0.99) ||
    trackRadius == wheelRadius {
    hints.append(Hints.similarRadiiHint)
}

if trackRadius == 0 || wheelRadius == 0 || spokeLength == 0 {
    hints.append(Hints.zeroHint)
}
if trackRadius < 0 && wheelRadius < 0 {
    // They will successfully create a vertical ellipse
} else {
    if trackRadius < 0 {
        hints.append(Hints.negativeValueHint)
    }
    
    if wheelRadius < 0 {
        hints.append(hypotrochoidHint)
    }
}

if abs(trackRadius / wheelRadius) < 0.01 {
    hints.append(Hints.disparateValuesHint)
}

if hints.isEmpty {
    if let currentStatus = PlaygroundPage.current.assessmentStatus, case .pass = currentStatus {
        //Avoid setting assessment status if it's already marked as pass.
    } else {
        //They've succeeded! Display congrats message
        page.assessmentStatus = .pass(message: successMessage)
    }
} else {
    // Show hints
    page.assessmentStatus = .fail(hints: hints, solution: solutionString)
}

//#-end-hidden-code
