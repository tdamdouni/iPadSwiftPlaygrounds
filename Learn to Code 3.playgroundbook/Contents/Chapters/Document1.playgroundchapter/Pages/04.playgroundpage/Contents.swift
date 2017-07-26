//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Place an array of planets in the universe.
 
 Instead of placing images one at a time, you can put them all in an [array](glossary://array), like these sporty planets:
 
 * callout(Array of images):
    `var images = [⚽️, 🎾, ⚾️, 🎱, 🏀]`
 
 Then you can [iterate](glossary://iteration) through the `images` array using a [for loop](glossary://for%20loop), creating a graphic with each image in turn, and placing it on the scene:
 
 * callout(Placing an array of images on the scene):
    `for image in images {`\
    `   // Create a graphic with image.`\
    `   // Place the graphic on the scene.`\
    `}`
 
 Place the planets in a diagonal line, starting near the origin at `position` (x = 75, y = 75), and going up and to the right. Write code to go inside the `for` loop:
 
 1. Create a graphic with `image`.
 2. Place the graphic on the scene at `position`.
 3. Move `position` up and to the right, by adding the same amount to its x and y coordinates:
 
    `position.x += 75`\
    `position.y += 75`
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, let, var, for, while, func, if, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), =, ==, +=, -=, +, -, *, /, randomDouble(from:to:), x, y, scale)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))
let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

var images = [#imageLiteral(resourceName: "soccerball@2x.png"), #imageLiteral(resourceName: "tennisball@2x.png"), #imageLiteral(resourceName: "baseball@2x.png"), #imageLiteral(resourceName: "billiardball@2x.png"), #imageLiteral(resourceName: "basketball@2x.png")]

// Set starting position.
var position = Point(x: 75, y: 75)

for image in images {
    //#-editable-code
    //➤ Create a graphic with image.

    //➤ Place graphic on the scene.

    //➤ Set position for next graphic.

    //#-end-editable-code
}
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code
//    //➤ Create a graphic with image.
//    let graphic = Graphic(image: image)
//    //➤ Place graphic on the scene.
//    scene.place(graphic, at: position)
//    //➤ Set position for next graphic.
//    position.x += 75
//    position.y += 75
//    //#-end-editable-code

//#-end-hidden-code

