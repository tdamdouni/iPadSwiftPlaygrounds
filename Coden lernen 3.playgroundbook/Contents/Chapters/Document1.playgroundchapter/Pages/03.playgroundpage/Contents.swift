//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Place a graphic in each quadrant of the universe.
 
 The coordinate system is divided by the x and y axes into four quarters, or *quadrants*, with the *origin* at the center. The coordinates in each quadrant have a different combination of positive and negative x, y values:
 
 ![Quadrants](quadrants@2x.png)
 
 Liven up Blu’s universe with a few alien creatures, like the ones defined as graphics in the code.
 
 1. Place one graphic in each quadrant of the universe.
 2. Run your code and make sure the graphics end up where you expect.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, scene, ., let, var, backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, x, y, place(_:at:), =, ==, +=, -=, +, -, *, /)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")
//#-end-hidden-code
let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))

// Alien creatures.
let ghost = Graphic(image: #imageLiteral(resourceName: "ghost@2x.png"))
let alien = Graphic(image: #imageLiteral(resourceName: "alien@2x.png"))
let ogre = Graphic(image: #imageLiteral(resourceName: "ogre@2x.png"))
let monster = Graphic(image: #imageLiteral(resourceName: "monster@2x.png"))

let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

//#-editable-code
// Place a graphic in each quadrant.
scene.place(ghost, at: Point(x: 250, y: 250))

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
