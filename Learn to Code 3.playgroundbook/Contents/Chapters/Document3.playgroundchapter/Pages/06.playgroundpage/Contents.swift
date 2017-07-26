//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Place strings on the scene.
 
 The `scene.write()` function only puts lines of plain text on the scene. Not much fun if you want to do something more adventurous, like putting text in a particular place, or making it look stylish.
 
 Fortunately, you can create a graphic with text and place it on the scene yourself, just as you would an image graphic.
 
 * callout(Creating a text graphic):
    `let graphic = Graphic(text: "Place me!")`
 
 * callout(Placing a text graphic):
    `scene.place(graphic, at: Point(x: 100, y: 300))`
 
 Run the code. You’ll see the residents of Blu’s universe lurking—one in each quadrant—and your job is to place a caption near each of them. Have fun making up your own captions!
 
 1. For each caption, create a `Graphic` instance with the caption.
 2. Place each graphic on the scene using a `Point` instance for the x, y coordinates.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

//#-editable-code
//➤ Use your own captions.
let caption1 = "Ooowheeeee"
let caption2 = "Blurp! Gloink splok."
let caption3 = "Hairy Ogre"
let caption4 = "I’m friendly!"

//➤ Add captions to scene.

//#-end-editable-code
//#-hidden-code

let ghost = Graphic(image: #imageLiteral(resourceName: "ghost@2x.png"))
let alien = Graphic(image: #imageLiteral(resourceName: "alien@2x.png"))
let ogre = Graphic(image: #imageLiteral(resourceName: "ogre@2x.png"))
let monster = Graphic(image: #imageLiteral(resourceName: "monster@2x.png"))

scene.place(ghost, at: Point(x: -250, y: 400))
scene.place(alien, at: Point(x: 200, y: 250))
scene.place(ogre, at: Point(x: 250, y: -200))
scene.place(monster, at: Point(x: -350, y: -250))

ghost.scale = 2.5
alien.scale = 2.5
ogre.scale = 2.5
monster.scale = 2.5

var tools: [Tool] = []
scene.tools = tools

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code
//    //➤ Use your own captions.
//    let caption1 = "Ooowheeeee"
//    let caption2 = "Blurp! Gloink splok."
//    let caption3 = "Hairy Ogre"
//    let caption4 = "I’m friendly!"
//
//    //➤ Add captions to scene.
//    let graphic1 = Graphic(text: caption1)
//    scene.place(graphic1, at: Point(x: -250, y: 250))
//
//    let graphic2 = Graphic(text: caption2)
//    scene.place(graphic2, at: Point(x: 200, y: 180))
//
//    let graphic3 = Graphic(text: caption3)
//    scene.place(graphic3, at: Point(x: 250, y: -280))
//
//    let graphic4 = Graphic(text: caption4)
//    scene.place(graphic4, at: Point(x: -350, y: -320))
//    //#-end-editable-code


//#-end-hidden-code

