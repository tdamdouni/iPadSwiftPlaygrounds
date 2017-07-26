//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Set a background image for the scene.
 
 Think of the scene as a bit like a scene in a movie, with graphics as actors. And just like in a movie, a scene can have a background. You can set a background image for the scene.

 * callout(Setting the background image):
    `scene.backgroundImage = 🌃`
 
 1. steps: Write `scene.backgroundImage =`  in the code, and then choose ![Image Symbol](ImageSymbol@2x.png) from the shortcut bar.
 2. Choose an image for your background.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, image)
//#-code-completion(identifier, show, scene, ., backgroundColor, backgroundImage, =)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType, starryNight)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")
//#-end-hidden-code
// Set the background image.
//#-editable-code
//#-end-editable-code

let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))
let star = Graphic(image: #imageLiteral(resourceName: "Star@2x.png"))

scene.place(blu, at: Point(x: -250, y: 250))

let position = Point(x: /*#-editable-code*/250/*#-end-editable-code*/, y: /*#-editable-code*/250/*#-end-editable-code*/)
scene.place(star, at: position)

//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
