//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Move the star closer to the galaxy.
 
 Blu’s universe has one very simple rule: the only things allowed in it are [instances](glossary://instance) of [type](glossary://type) `Graphic`. In fact, even Blu is really just an instance of `Graphic`.
 
 * callout(Blu is born):
    `let blu = Graphic(image: 💧)`
 
 In code, the universe is an instance of `Scene` called `scene`. The scene has a [coordinate](glossary://coordinates) system, and any position on it can be specified by an instance of `Point` with `x` and `y` values. You can use the `place()` method to place a graphic at a point on the scene.
 
 * callout(Placing Blu at home):
    `let theOrigin = Point(x: 0, y: 0)`\
    `scene.place(blu, at: theOrigin)`
 
 If you ever get tired of the universe, you can just wipe it clean and start over!
 
 * callout(Clearing the scene):
    `scene.clear()`
 
 The code below creates a single star graphic and places it on the scene to light up Blu’s universe. 
 
 1. See if you can work out the x and y coordinates of a point close to the galaxy.
 
 2. Place the star at that point by changing the `x` and `y` values of `position` to those coordinates.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, scene, ., backgroundColor, backgroundImage)
//#-code-completion(module, show, Swift)
//#-code-completion(identifier, hide, Touch, Color, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")
//#-end-hidden-code
scene.clear()
//#-hidden-code
var galaxy = Graphic(image: #imageLiteral(resourceName: "MilkyWay@2x.png") )
scene.place(galaxy, at: Point(x: 250, y: 350))
//#-end-hidden-code

let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))
let star = Graphic(image: #imageLiteral(resourceName: "Star@2x.png"))

let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

//➤ Set the position of the star
let position = Point(x: /*#-editable-code*/-250/*#-end-editable-code*/, y: /*#-editable-code*/350/*#-end-editable-code*/)
scene.place(star, at: position)

//#-hidden-code


playgroundEpilogue()

//#-end-hidden-code
