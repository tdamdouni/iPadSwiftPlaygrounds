//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Loop repeatedly through images from an array.
 
 Instead of just a ⭐️ image, the tool can use an array of images, such as `animals`. Notice the code in `addImage()` that gets an image from `animals` at `index`, and then [increments](glossary://increment) `index` to point to the next image.
 
 * callout(Using an index to get an image from an array):
    `let chosenImage = animals[index]`\
    `index += 1`
 
 1. Run the code, select the **Image** tool, and drag your finger across the scene. As you move your finger, `addImage()` is called repeatedly, and the images in the array are placed one after another.
 
    Imagine what the problem is with this—you might already have come across it! Yes, you’ll soon run out of images in the array, triggering an [out of bounds error](glossary://out%20of%20bounds%20error) when `index` goes past the end of the array.
 
 2. Solve the problem by adding code to set `index` back to zero if it reaches the end of the array.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")/*#-end-editable-code*/
let animals = [#imageLiteral(resourceName: "horse@2x.png"), #imageLiteral(resourceName: "elephant@2x.png"), #imageLiteral(resourceName: "panda@2x.png"), #imageLiteral(resourceName: "pig@2x.png"), #imageLiteral(resourceName: "frog@2x.png"), #imageLiteral(resourceName: "snail@2x.png")]
var index = 0

func addImage(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
    
    //#-editable-code
    let chosenImage = animals[index]
    index += 1
    //➤ Reset index if it’s reached the end of the array.
    
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
//    let chosenImage = animals[index]
//    index += 1
//    //➤ Reset index if it’s reached the end of the array.
//    if index == animals.count {
//        index = 0
//    }
//    //#-end-editable-code

//#-end-hidden-code
