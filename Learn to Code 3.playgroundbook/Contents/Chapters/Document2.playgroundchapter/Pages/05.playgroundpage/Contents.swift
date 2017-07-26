//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Loop through images from an array by using the modulo operator.
 
 As you’ve seen, you can loop through an array by setting the index back to zero when it reaches the end of the array. Another way to do this involves using the [modulo operator](glossary://modulo%20operator) (**%**). It works just like division (/), but it always returns the remainder.
 
 * callout(Modulo division):
    `let index = 4 % 5   // = 4`\
    `let index = 5 % 5   // = 0`\
    `let index = 6 % 5   // = 1`
 
 Notice that any number modulo 5 is always less than 5, which is handy if you want an index into an array with 5 items.
 
 A `Touch` instance has the property `numberOfObjectsPlaced`, which is the number of graphics placed on the scene since the touch movement started. Modulo this with `animals.count`, and you’ll always get an index that’s within the [bounds](glossary://bounds) of the array.
 
 * callout(Index never out of bounds):
    `let index = touch.numberOfObjectsPlaced % animals.count`
 
 In the code below, `index` is set to 0. Change the code so `index` is based on `numberOfObjectsPlaced`, but always stays within the bounds of the array.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")/*#-end-editable-code*/
let animals = [#imageLiteral(resourceName: "horse@2x.png"), #imageLiteral(resourceName: "elephant@2x.png"), #imageLiteral(resourceName: "panda@2x.png"), #imageLiteral(resourceName: "pig@2x.png"), #imageLiteral(resourceName: "frog@2x.png"), #imageLiteral(resourceName: "snail@2x.png")]

func addImage(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
    
    //#-editable-code
    //➤ Compute index using %.
    let index = 0
    let chosenImage = animals[index]
    //#-end-editable-code
    let graphic = Graphic(image: chosenImage)
    scene.place(graphic, at: touch.position)
}
//#-hidden-code
assessmentController?.customInfo["images"] = animals

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage
scene.tools.append(createImageTool)

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code
//    //➤ Compute index using %.
//    let index = touch.numberOfObjectsPlaced % animals.count
//    let chosenImage = animals[index]
//    //#-end-editable-code

//#-end-hidden-code
