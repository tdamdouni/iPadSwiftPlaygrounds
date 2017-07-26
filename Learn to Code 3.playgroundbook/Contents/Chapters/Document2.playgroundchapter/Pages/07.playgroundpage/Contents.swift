//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Experiment:** Play with fading images.
 
  When you use the **Image** tool for a while, the scene quickly gets a bit cluttered! You can avoid this—and create some cool effects—by coding the graphics to disappear after a while in a variety of ways.
 
 * callout(Fade out after a random number of seconds):
    `let seconds = randomDouble(from: 1.0, to: 5.0)`\
    `graphic.fadeOut(after: seconds)`
 
 
 * callout(Spin and pop after a number of seconds):
    `graphic.spinAndPop(after: seconds)`
 
 
 * callout(Swirl away after a number of seconds):
    `graphic.swirlAway(after: seconds)`
 
 To make things more interesting, you can code specific behavior for certain images.
 
 * callout(Pop the pandas):
    `if index == 2 {`\
    `   graphic.spinAndPop(after: seconds)`\
    `}`
 
 1. Use these functions to create interesting patterns and effects as you drag your finger around the screen.
 
 2. Experiment with different effects for specific images.
 
 When you’re finished, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, %, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
let animals = [#imageLiteral(resourceName: "horse@2x.png"), #imageLiteral(resourceName: "elephant@2x.png"), #imageLiteral(resourceName: "panda@2x.png"), #imageLiteral(resourceName: "pig@2x.png"), #imageLiteral(resourceName: "frog@2x.png"), #imageLiteral(resourceName: "snail@2x.png")]
//#-end-editable-code

func addImage(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
        
    //#-editable-code(id1)
    // Get a random image and place it.
    let index = randomInt(from: 0, to: animals.count - 1)
    var graphic = Graphic(image: animals[index])
    scene.place(graphic, at: touch.position)
    
    let seconds = randomDouble(from: 1.0, to: 5.0)
    //➤ Experiment with different functions.
    graphic.fadeOut(after: seconds)
    //#-end-editable-code
}
//#-hidden-code

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage
scene.tools.append(createImageTool)

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    // Get a random image and place it.
//    let index = randomInt(from: 0, to: animals.count - 1)
//    let graphic = Graphic(image: animals[index])
//    scene.place(graphic, at: touch.position)
//
//    let seconds = randomDouble(from: 1.0, to: 5.0)
//    //➤ Experiment with different functions.
//    graphic.swirlAway(after: 5.0)
//    //#-end-editable-code


//#-end-hidden-code
