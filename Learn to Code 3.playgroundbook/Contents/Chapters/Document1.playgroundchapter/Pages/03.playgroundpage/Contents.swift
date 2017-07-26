//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
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

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))

// Alien creatures
let ghost = Graphic(image: #imageLiteral(resourceName: "ghost@2x.png"))
let alien = Graphic(image: #imageLiteral(resourceName: "alien@2x.png"))
let ogre = Graphic(image: #imageLiteral(resourceName: "ogre@2x.png"))
let monster = Graphic(image: #imageLiteral(resourceName: "monster@2x.png"))

let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

//#-editable-code
//➤ Place a graphic in each quadrant
scene.place(ghost, at: Point(x: 250, y: 250))

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    position = Point(x: theOrigin.x + 150, y: theOrigin.y + 150)
//    scene.place(ghost, at: position)
//
//    position = Point(x: theOrigin.x + 150, y: theOrigin.y - 150)
//    scene.place(alien, at: position)
//
//    position = Point(x: theOrigin.x - 150, y: theOrigin.y - 150)
//    scene.place(ogre, at: position)
//
//    position = Point(x: theOrigin.x - 150, y: theOrigin.y + 150)
//    scene.place(monster, at: position)

//#-end-hidden-code
