//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Remove all graphics at the same time.
 
 What if you had a single button that squished all the UFFs at the same time? Remember the **Next** button from **Tell a Story**? You can change its name to **Squish ’Em!** and write code to do exactly that.
 
 Just like you do for a tool, you create a button and give it a name. `Button` has an `onTap` property that you can set to a function to handle “button tap” events. In the code below, `squishEm()` is called any time `squishButton` is tapped.

 Each time you place a graphic on the scene in `addFructoid()`, the graphic is added to the `graphics` array. You can loop through this array and do something with each graphic.
 
 * callout(Iterate through graphics on the scene):
    `for graphic in graphics {`\
    `   // Do something with the graphic`\
    `}`

 1. Add code to the `squishEm()` function below, to iterate through the graphics on the scene and call `squishGraphic()` for each.
 2. Run the code, then add some UFFs and try tapping **Squish ’Em!**.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")

let blackHole = Graphic(image: #imageLiteral(resourceName: "BlackHole@2x.png"))
let x = randomDouble(from: -400, to: 400)
let y = randomDouble(from: -400, to: 400)
let blackHolePosition = Point(x: x, y: y)
scene.place(blackHole, at: blackHolePosition)

// Array of graphics on the scene.
var graphics: [Graphic] = [Graphic]()
//#-end-editable-code

// Fade out graphic, then remove it.
func squishGraphic(graphic: Graphic) {
    //#-editable-code
    graphic.scale -= 0.5
    graphic.alpha -= 0.25
    
    // Remove graphic when scale gets small.
    if graphic.scale < 0.6 {
        graphic.moveAndZap(to: blackHole.position, duration: 0.25)
    }
    //#-end-editable-code
}

// Squish all graphics.
func squishEm() {
    //#-editable-code(id1)
    //➤ Iterate over graphics and squish each one.
    
    //#-end-editable-code
}
//#-editable-code
// UFF tool event handler.
func addFructoid(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphics.append(graphic)
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

// Create and add Squish ’Em! button.
let squishButton = Button(name: "Squish ’Em!")
squishButton.onTap = squishEm
scene.button = squishButton
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()



//** Completed Code **
    
//    //#-editable-code(id1)
//    //➤ Iterate over graphics and squish them
//    for graphic in graphics {
//        squishGraphic(graphic: graphic)
//    }
//    //#-end-editable-code

//#-end-hidden-code
