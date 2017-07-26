//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Use your new skills with graphics and touch events to code your own cool project!
 
 When you’re finished with your project, move on to the [**next chapter**](@next).
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

//#-end-hidden-code
//#-editable-code
scene.clear()
//➤ Use your own background image.
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
//➤ Add your own code to set up the scene.

// With the Image tool selected, this function is called each time your finger moves.
func addImage(touch: Touch) {
    if touch.previousPlaceDistance < 80 { return }
    
    //➤ Replace with your own code.
    let graphic = Graphic(text: "👀")
    graphic.scale = randomDouble(from: 4, to: 8)
    graphic.rotation = randomDouble(from: 0, to: 180)
    scene.place(graphic, at: touch.position)
}
//#-end-editable-code
//#-hidden-code

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage
scene.tools.append(createImageTool)

playgroundEpilogue()

//#-hidden-code
playgroundEpilogue()

//#-end-hidden-code
