//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Place random images from an array onto the scene.
 
 Instead of looping through an array, you can place random images from it onto the scene. Use the `randomInt()` function, which returns a random integer between two numbers. If those numbers are 0 and the array count minus 1, `randomInt()` returns a random index to an item in the array.
 
 * callout(Get a random animal image):
    `let index = randomInt(from: 0, to: animals.count - 1)`\
    `let graphic = Graphic(image: animals[index])`
 
 For variety, you can scale or rotate a graphic to a random value.
 
  * callout(Apply a random scale or rotation):
    `graphic.scale = randomDouble(from: 0.5, to: 2.0)`\
    `graphic.rotation = randomDouble(from: 0.0, to: 360.0)`
 
 1. In `addImage()`, set `index` so that a random image is placed each time the function is called.
 2. After placing the graphic, set its `scale` and `rotation` to random values.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, %, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, rotation, orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
let animals = [#imageLiteral(resourceName: "horse@2x.png"), #imageLiteral(resourceName: "elephant@2x.png"), #imageLiteral(resourceName: "panda@2x.png"), #imageLiteral(resourceName: "pig@2x.png"), #imageLiteral(resourceName: "frog@2x.png"), #imageLiteral(resourceName: "snail@2x.png")]
//#-end-editable-code

func addImage(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
        
    //#-editable-code(id1)
    // Set index to a random value.
    let index = 0
    var graphic = Graphic(image: animals[index])
    scene.place(graphic, at: touch.position)
    // Scale or rotate graphic (or do both).
    
    //#-end-editable-code
}
//#-hidden-code

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage
scene.tools.append(createImageTool)

playgroundEpilogue()

//#-end-hidden-code
