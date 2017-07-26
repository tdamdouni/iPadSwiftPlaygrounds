//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport

private let changeSpokeHint = NSLocalizedString("To create a hypotrochoid, make `spokeLength` longer or shorter than `wheelRadius`.", comment: "Spoke length hint for hypotrochoid solution.")
private let shorterSpokeSuccessMessage = NSLocalizedString("Great job! Now try experimenting—what happens when you make `spokeLength` longer than `wheelRadius`? Longer than `trackRadius`? When you’re ready, head to the [next page](@next)!", comment: "Success message for hypotrochoid with shorter spoke.")
private let longerSpokeSuccessMessage = NSLocalizedString("Great job! Now try experimenting—what happens when you make the `spokeLength` shorter than `trackRadius`? Shorter than `wheelRadius`? When you’re ready, head to the [next page](@next)!", comment: "Success message for hypotrochoid with longer spoke.")

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

private var trackRadius = 5.0
private var wheelRadius = 3.0
private var spokeLength = 3.0
private var pathColor = UIColor.appleLogoGreen()
private var trackColor = UIColor.appleLogoBlue()
private var spokeColor = UIColor.appleLogoPurple()
private var wheelColor = UIColor.appleLogoOrange()

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
/*:#localized(key: "FirstProseBlock")
 **Goal:** Create a hypotrochoid.
 
 Notice that the cycloid lines you've been drawing so far follow the path traced by a point *exactly* on the edge of the moving wheel. In other words, the spoke length is equal to the wheel radius.
 
 **Think:** What would happen if the spoke length were longer or shorter than the wheel radius?
 */
//#-code-completion(everything, hide)
// Change the value of spokeLength
spokeLength = /*#-editable-code*/3.0/*#-end-editable-code*/
/*:#localized(key: "SecondProseBlock")
 The shape you're creating is called a hypotrochoid. Although it's similar to the cycloids you've already drawn, because of the spoke flexibility, the shapes you can create are very different.
 
 - note:
 Because [trochoids](glossary://trochoid) are *more flexible* than cycloids, you can think of cycloids as a [subset](glossary://subset) of trochoids. Think of how a square is a specific kind of rectangle, and a rectangle is a specific kind of quadrilateral. In the same way, a cycloid is a specific kind of trochoid, and a trochoid is a specific kind of roulette!
 */
//#-code-completion(literal, show, color)
// Try using a value like 6.2 or 2.4 - you get different shapes with fractional numbers.
trackRadius = /*#-editable-code*/5.0/*#-end-editable-code*/
wheelRadius = /*#-editable-code*/3.0/*#-end-editable-code*/

// Customize all your colors!
pathColor = /*#-editable-code*/#colorLiteral(red: 0.3823705912, green: 0.7347578406, blue: 0.2736029625, alpha: 1)/*#-end-editable-code*/
trackColor = /*#-editable-code*/#colorLiteral(red: 0.002151125809, green: 0.617736578, blue: 0.8608769774, alpha: 1)/*#-end-editable-code*/
spokeColor = /*#-editable-code*/#colorLiteral(red: 0.5882352941, green: 0.2392156863, blue: 0.5921568627, alpha: 1)/*#-end-editable-code*/
wheelColor = /*#-editable-code*/#colorLiteral(red: 0.9607843137, green: 0.5098039216, blue: 0.1215686275, alpha: 1)/*#-end-editable-code*/

// And remember you can keep changing the spokeLength above to experiment.

drawSpiral()

//#-hidden-code
// Hint checking
var hints = [String]()

if spokeLength == wheelRadius {
    hints.append(changeSpokeHint)
}

// If the wheel radius is less than or equal to 1% smaller or larger than the track radius
if (abs(wheelRadius) < abs(trackRadius) && wheelRadius / trackRadius >= 0.99) ||
    (abs(trackRadius) < abs(wheelRadius) && trackRadius / wheelRadius >= 0.99) ||
    trackRadius == wheelRadius {
    hints.append(Hints.similarRadiiHint)
}

if (abs(trackRadius / wheelRadius) == 2) && (abs(spokeLength) == abs(wheelRadius)) {
    hints.append(Hints.straightLineHint)
}

if trackRadius == 0 || wheelRadius == 0 || spokeLength == 0 {
    hints.append(Hints.zeroHint)
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
        } else if spokeLength > wheelRadius {
            page.assessmentStatus = .pass(message: longerSpokeSuccessMessage)
        } else {
            page.assessmentStatus = .pass(message: shorterSpokeSuccessMessage)
        }
    }
} else {
    // Show hints
    page.assessmentStatus = .fail(hints: hints, solution: nil)
}





//#-end-hidden-code
