//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Write strings to Blu’s universe.
 
 In code, a bunch of words or characters is a [string](glossary://String), and a string is wrapped in double quotes.
 
 * callout(Example of a string):
    `"Blu blew blue bubbles."`
 
 A string isn’t really much use in your code unless you do something with it, like write it to the universe or send it into orbit (that’s for later!).
 
* callout(Writing a string to the scene):
    `scene.write("Blu’s blue bubbles blew.")`

 As you can see, Blu has fun with words! You can, too—try writing a few strings to the scene.
 
 1. Run the code to write a sentence that’s already been provided for you.
 2. Now see if you can make up a few more.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, %, "", ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit


public typealias _ImageLiteralType = Image
 
playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

//#-editable-code
scene.write("Blu dribbled past planet Soccerball ⚽️.")
//➤ Write your own sentences here.

//#-end-editable-code
//#-hidden-code

var tools: [Tool] = []
scene.tools = tools

playgroundEpilogue()

//#-end-hidden-code

