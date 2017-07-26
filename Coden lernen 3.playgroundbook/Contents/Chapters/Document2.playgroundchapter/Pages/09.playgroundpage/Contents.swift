//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Create:** Arrange images in symmetrical patterns.
 
 You can place several images on the scene each time you move your finger and `addImage()` is called. If you place them in mirror-image positions around the scene, you can trace cool, kaleidoscope-like patterns.
 
 Each time you place an image at your finger position in one quadrant of the scene, place three more in mirror-image positions in the other three quadrants.
 
 To work out the positions of the images, start with the [absolute](glossary://absolute%20value) value of the x and y touch coordinates. The symmetrical positions in the four quadrants are then top right: **(x, y)**; bottom right: **(x, -y)**; bottom left: **(-x, -y)**; top left: **(-x, y)**.
 
 The code below creates four `Graphic` instances, each with the same random animal image, and puts them into the `graphics` array.
 
 Place one graphic from the `graphics` array in each quadrant of the scene. The `abs()` function gets the absolute x and y values; use them to get the x and y coordinates for each quadrant.
 
 **Ideas:**
 
 * Set `scale` and `rotation` for each graphic to a random `Double` value.
 
 * Have each graphic gradually disappear after it’s been placed, by calling one of these graphic methods: `fadeOut()`, `spinAndPop()`, `swirlAway()`.
 
 * Instead of just placing each graphic at its final position, first place it at `touch.position` and then use `move(to:duration:)` to animate it into place.
 
 When you’re finished, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, %, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), rotation, move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
let animals = [#imageLiteral(resourceName: "horse@2x.png"), #imageLiteral(resourceName: "elephant@2x.png"), #imageLiteral(resourceName: "panda@2x.png"), #imageLiteral(resourceName: "pig@2x.png"), #imageLiteral(resourceName: "frog@2x.png"), #imageLiteral(resourceName: "snail@2x.png")]
//#-end-editable-code

var lastPlacePosition = Point(x: 0, y: 0)

func addImage(touch: Touch) {
    
    // Space out the graphics.
    let placeDistance = touch.position.distance(from: lastPlacePosition)
    if placeDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
    lastPlacePosition = touch.position
    
    //#-editable-code(id2)
    // Graphics for each quadrant.
    var graphics: [Graphic] = []
    // Pick a random image.
    let chosenImage = animals.randomItem
    // Create graphics and add to array.
    for i in 0 ..< 4 {
        let graphic = Graphic(image: chosenImage)
        graphics.append(graphic)
    }
    // Get absolute x, y values.
    let x = abs(touch.position.x)
    let y = abs(touch.position.y)
    // Position a graphic in each quadrant.
    
    //#-end-editable-code
}
//#-hidden-code

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage
scene.tools.append(createImageTool)

playgroundEpilogue()

//#-end-hidden-code
