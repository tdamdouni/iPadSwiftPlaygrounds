//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Create:** Use your new skills with graphics and touch events to code your own cool project!
 
 See if you can write your own code for the `addImage()` and `addText()` functions.
 
 Remember: if you need to wipe the scene and start over again just press the **Clear** button. You can even do this in code:
 
 * callout(Clearing the scene):
 `scene.clear()`
 
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
// Clear the scene.
scene.clear()
// Use your own background image.
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
// Add your own code to set up the scene.

// With the Image tool selected, this function is called each time your finger moves.
func addImage(touch: Touch) {
    if touch.previousPlaceDistance < 80 { return }
    
    // Replace with your own code.
    let graphic = Graphic(image: #imageLiteral(resourceName: "ogre@2x.png"))
    graphic.scale = randomDouble(from: 2, to: 4)
    graphic.rotation = randomDouble(from: 0, to: 180)
    scene.place(graphic, at: touch.position)
    graphic.swirlAway(after: randomDouble(from: 1, to: 4))
}

let emoji = "😺🚗🎃🚕🤢🚙"
// Split emoji into an array of single-character strings.
let characters = emoji.componentsByCharacter()
// Index to next character.
var index = 0

// With the Text tool selected, this function is called each time your finger moves.
func addText(touch: Touch) {
    if touch.previousPlaceDistance < 80 { return }
    
    // Replace with your own code.
    let graphic = Graphic(text: characters[index])
    graphic.scale = 2.5
    scene.place(graphic, at: touch.position)
    graphic.fadeOut(after: randomDouble(from: 1, to: 4))
    
    index += 1
    if index == characters.count {
        index = 0
    }
}

//#-end-editable-code
//#-hidden-code

let createImageTool = Tool(name: "Image", emojiIcon: "🖼")
createImageTool.onFingerMoved = addImage(touch:)
scene.tools.append(createImageTool)

let textTool = Tool(name: "Text", emojiIcon: "😺")
textTool.onFingerMoved = addText(touch:)
scene.tools.append(textTool)

playgroundEpilogue()

//#-end-hidden-code
