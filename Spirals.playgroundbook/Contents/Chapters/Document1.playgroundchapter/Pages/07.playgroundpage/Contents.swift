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
private var spokeLength = 1.0
private var pathColor = UIColor.appleLogoGreen()
private var trackColor = UIColor.appleLogoRed()
private var spokeColor = UIColor.appleLogoOrange()
private var wheelColor = UIColor.appleLogoYellow()

// New vars
private var backgroundColor = UIColor.wwdcGray()
private var drawSpeed = 1.0
private var lightTheme = false

func drawSpiral() {
    let cycloid = Roulette(trackRadius: trackRadius,
                           wheelRadius: wheelRadius,
                           spokeLength: spokeLength,
                             pathColor: pathColor,
                            trackColor: trackColor,
                            spokeColor: spokeColor,
                            wheelColor: wheelColor,
                            drawSpeed: drawSpeed,
                            lightTheme: lightTheme,
                            backgroundColor: backgroundColor)
    proxy?.send(cycloid.playgroundValue)
}

//#-end-hidden-code
/*:
 **Goal:** Have fun! 😃
 
 Congratulations! You've mastered Spirals! Use this page to play and draw as much as you like. You'll even find a few new customization options towards the bottom of the page.
 
 You can use the sharing options in the Tools menu (the three small circles at the upper right of the page). Take a picture of your art, a movie of it, or even stream it live using one of your own livestreaming apps! Show your friends the cool spirals you've created!
 */
//#-code-completion(everything, hide)
//#-code-completion(literal, show, color)
// This will determine how large the track your wheel moves on is.
trackRadius = /*#-editable-code*/5/*#-end-editable-code*/

// Remember to use a negative value here to draw an epi- shape.
wheelRadius = /*#-editable-code*/1/*#-end-editable-code*/

// Make spokeLength equal to the wheelRadius for a cycloid, or not equal for a trochoid.
spokeLength = /*#-editable-code*/1/*#-end-editable-code*/

pathColor = /*#-editable-code*/#colorLiteral(red: 0.3823705912, green: 0.7347578406, blue: 0.2736029625, alpha: 1)/*#-end-editable-code*/
trackColor = /*#-editable-code*/#colorLiteral(red: 0.8941176471, green: 0.2117647059, blue: 0.2431372549, alpha: 1)/*#-end-editable-code*/
spokeColor = /*#-editable-code*/#colorLiteral(red: 0.9607843137, green: 0.5098039216, blue: 0.1215686275, alpha: 1)/*#-end-editable-code*/
wheelColor = /*#-editable-code*/#colorLiteral(red: 0.9921568627, green: 0.7215686275, blue: 0.1529411765, alpha: 1)/*#-end-editable-code*/

// Try some of the new options below!
backgroundColor = /*#-editable-code*/#colorLiteral(red: 0.09019607843, green: 0.09411764706, blue: 0.1333333333, alpha: 1)/*#-end-editable-code*/

// For best results, choose a draw speed value from 1.0 to 10.0
drawSpeed = /*#-editable-code*/1.0/*#-end-editable-code*/

// Note: Setting lightTheme to true will *override* backgroundColor.
lightTheme = /*#-editable-code*/false/*#-end-editable-code*/

drawSpiral()
