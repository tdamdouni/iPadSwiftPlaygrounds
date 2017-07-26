//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Remove a graphic by touching it.
 
 Blu’s universe has a problem with UFFs—Unidentified Flying Fructoids. They buzz around in weird orbits and get in the way of everything. 
 
 Your task is to create a **Squish** tool to destroy the UFFs by touching them. But they’re tough-skinned, and you have to hit them several times before they get pulled into the black hole.
 
 1. Add code to `squishGraphic()` to reduce the `scale` value of the touched graphic by 0.5.
 
 2. Add code to reduce the `alpha` value by 0.25. Now run the code, add some UFFs, and try tapping them. They should get smaller and fade away.
 
 3. Now add code to check if the `scale` of the touched graphic is less than 0.6. If it is, call the `moveAndZap(to:)` method of the graphic to move it to a new position (the black hole), and then remove it from the scene.
 
    `graphic.moveAndZap(to: blackHole.position)`
 
 4. Run the code, add a bunch of UFFs, and start squishing them!
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
let blackHole = Graphic(image: #imageLiteral(resourceName: "BlackHole@2x.png"))
let x = randomDouble(from: -400, to: 400)
let y = randomDouble(from: -400, to: 400)
let blackHolePosition = Point(x: x, y: y)
scene.place(blackHole, at: blackHolePosition)

// Squish tool event handler.
func squishGraphic(graphic: Graphic) {
    // Add code here.
    
}

// UFF tool event handler.
func addFructoid(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 2.0
    
    let x = randomDouble(from: 50, to: 400)
    let y = randomDouble(from: 50, to: 400)
    let period = randomDouble(from: 8.0, to: 15.0)
    graphic.orbit(x: x, y: y, period: period)
}

// Create and add UFF tool.
let fructoidTool = Tool(name: "UFF", emojiIcon: "🍋")
fructoidTool.onFingerMoved = addFructoid(touch:)
scene.tools.append(fructoidTool)

// Create and add Squish tool.
let squishTool = Tool(name: "Squish", emojiIcon: "💥")
squishTool.onGraphicTouched = squishGraphic(graphic:)
scene.tools.append(squishTool)
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
