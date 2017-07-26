//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Create a tool to connect an event with an event handler.
 
 To create a new tool, you initialize an instance of type `Tool` with a name and icon.
 
 * callout(Initializing a tool):
 `let alienTool = Tool(name: "Alien", emojiIcon: "👽")`

 Your tool responds to an event, such as a finger movement, by calling an [event handler](glossary://event%20handler) function.
 
 * callout(Function to handle a “finger moved” event):
    `func addAlien(touch: Touch) {`\
    `   // Place an alien at touch position`\
    `}`
 
To connect your event handler to “finger moved” events, set your tool’s `onFingerMoved` property to the [full function name](glossary://full%20function%20name) of the event handler. To add your tool to the scene, append it to the `scene.tools` array.
 
 * callout(Example):
    `let alienTool = Tool(name: "Alien", emojiIcon: "👽")`\
    `alienTool.onFingerMoved = addAlien(touch:)`\
    `scene.tools.append(alienTool)`
 
 1. Initialize a new tool with a name and emoji icon.
 2. Set the tool’s “finger moved” event handler to `addAlien(touch:)`.
 3. Add your new tool to the scene’s tools.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")

// Event handler for “finger moved” events.
func addAlien(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let graphic = Graphic(image: #imageLiteral(resourceName: "alien@2x.png"))
    scene.place(graphic, at: touch.position)
}

//➤ Create a tool.

//➤ Connect event handler to the tool.

//➤ Add tool to scene’s tools.

//#-end-editable-code
//#-hidden-code
assessmentController?.customInfo["tools"] = scene.tools
playgroundEpilogue()

//#-end-hidden-code
