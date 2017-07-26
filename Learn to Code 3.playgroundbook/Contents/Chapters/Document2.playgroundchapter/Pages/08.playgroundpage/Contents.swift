//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Move images into patterns.
 
 When you place an image using the **Image** tool, it doesn’t have to stay where it is! You can use code to move it anywhere on the scene, and even animate it by telling it how long to take to get there.
 
 * callout(Animating a graphic to a position):
    `let position = Point(x: 100, y: 100)`\
    `graphic.move(to: position, duration: 1.0)`
 
 The scene has functions that return an array of points in different patterns.
 
 * callout(Get an array of points in a circle or spiral):
    `let points = scene.circlePoints(radius: 200, count: 200)`\
    `let points = scene.spiralPoints(spacing: 50, count: 200)`
 
 You can move the images to these points as you place them on the scene.
 
 1. In `addImage()`, after you place the graphic, add code to get the position at `points[pointIndex]`.
 
 2. Increment `pointIndex` so that it’s ready to get the next position. Add some code to set `pointIndex` back to zero if it goes out of [bounds](glossary://bounds).
 
 3. Move the graphic to the position using `graphic.move(to:duration:)`.
 
 4. Select the **Image** tool and drag your finger around the scene. Watch the images magically arrange themselves.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, %, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit
import PlaygroundSupport

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
let animals = [#imageLiteral(resourceName: "horse@2x.png"), #imageLiteral(resourceName: "elephant@2x.png"), #imageLiteral(resourceName: "panda@2x.png"), #imageLiteral(resourceName: "pig@2x.png"), #imageLiteral(resourceName: "frog@2x.png"), #imageLiteral(resourceName: "snail@2x.png")]
//#-end-editable-code

//#-editable-code
// Get array of points in a pattern.
let points = scene.circlePoints(radius: 200, count: 100)
// Index to points.
var pointIndex = 0
//#-end-editable-code

func addImage(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
        
    //#-editable-code(id2)
    // Get a random image and place it.
    let index = randomInt(from: 0, to: animals.count - 1)
    var graphic = Graphic(image: animals[index])
    graphic.scale = 0.5
    scene.place(graphic, at: touch.position)
    //➤ Get position from points at pointIndex.

    //➤ Increment pointIndex.

    //➤ Move graphic to position.

    //#-end-editable-code
    //#-hidden-code
    assessmentController?.customInfo["points"] = points
    //#-end-hidden-code
}
//#-hidden-code

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage
scene.tools.append(createImageTool)

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id2)
//    // Get a random image and place it.
//    let index = randomInt(from: 0, to: animals.count - 1)
//    let graphic = Graphic(image: animals[index])
//    graphic.scale = 0.5
//    scene.place(graphic, at: touch.position)
//    //➤ Get position from points at pointIndex.
//    let position = points[pointIndex]
//    //➤ Increment pointIndex.
//    pointIndex += 1
//    if pointIndex == points.count {
//       pointIndex = 0
//    }
//    //➤ Move graphic to position.
//    graphic.move(to: position, duration: 1.0)
//    //#-end-editable-code

//#-end-hidden-code
