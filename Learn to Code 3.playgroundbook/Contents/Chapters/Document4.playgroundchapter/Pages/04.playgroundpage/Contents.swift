//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Make tools for different types of events.
 
 What if you want something to happen when you touch a graphic, like make it bigger? Touching a graphic sends a “graphic touched” event. A function that handles this event takes a `Graphic` parameter to tell the function which graphic was touched.
 
 * callout(Example of a “graphic touched” event handler):
    `func fattenAlien(graphic: Graphic) {   }`
 
 Different events carry different information, so they need different event handler functions. For example, a function to handle a “finger moved” event has a `Touch` parameter with information about the touch.
 
 * callout(Example of a “finger moved” event handler):
    `func addAlien(touch: Touch) {   }`
 
 Event handlers have to be called when an event occurs, and that’s the job of the tool. `Tool` has an `onGraphicTouched` property that you can set to any “graphic touched” event handler.
 
 * callout(Setting the “graphic touched” event handler):
    `toolA.onGraphicTouched = fattenAlien(graphic:)`
 
 `Tool` also has an `onFingerMoved` property that accepts any “finger moved” event handler.
 
 * callout(Setting the “finger moved” event handler):
    `toolB.onFingerMoved = addAlien(touch:)`
 
 In the code below, see if you can swap the event handlers so that **Tool A** responds to “graphic touched” events, and **Tool B** responds to “finger moved” events. Once you’re done, move on to the [**next page**](@next).
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")

// A “finger moved” event handler.
func addAlien(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let graphic = Graphic(image: #imageLiteral(resourceName: "alien@2x.png"))
    scene.place(graphic, at: touch.position)
}

// A “graphic touched” event handler.
func fattenAlien(graphic: Graphic) {
    graphic.scale *= 1.5
}

// Create Tool A.
let toolA = Tool(name: "Tool A", emojiIcon: "🅰️")
//➤ Swap event handler.
toolA.onFingerMoved = addAlien(touch:)
scene.tools.append(toolA)

// Create Tool B.
let toolB = Tool(name: "Tool B", emojiIcon: "🅱️")
//➤ Swap event handler.
toolB.onGraphicTouched = fattenAlien(graphic:)
scene.tools.append(toolB)
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    // Create Tool A.
//    let toolA = Tool(name: "Tool A", emojiIcon: "🅰️")
//    //➤ Swap event handler.
//    toolA.onGraphicTouched = fattenAlien(graphic:)
//    scene.tools.append(toolA)
//
//    // Create Tool B.
//    let toolB = Tool(name: "Tool B", emojiIcon: "🅱️")
//    //➤ Swap event handler.
//    toolB.onFingerMoved = addAlien(touch:)
//    scene.tools.append(toolB)

//#-end-hidden-code
