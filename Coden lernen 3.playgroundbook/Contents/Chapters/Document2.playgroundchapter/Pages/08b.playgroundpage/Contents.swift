//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Use the **Text** tool to scatter emoji.
 
 Put together the Japanese words for picture (絵) and character (文字), and you get emoji (絵文字). And that’s exactly what an emoji is: a picture character 🌠.
 
 Like with all characters, you can include emoji in text strings and mix them with other characters.
 
 * callout(Including emoji in a string):
    `let cheer = "What a goal!! ⚽️ 🙌"`
 
 You can also split any string into an array of single-character strings:
 
 * callout(Splitting a string into its characters):
    `let flora = "🌺🌻🌹🌷"`\
    `let flowers = flora.componentsByCharacter()`
 
 This is useful to know if you want to place each character on the scene individually.
 
 1. Split `emoji` into an array of single-character strings, and call the array `characters`.
 
 2. In the `addText()` function add code to set `chosenEmoji` equal to item `index` of the `characters` array (`characters[index]`).
 
 3. Add code to [increment](glossary://increment) `index` so that it points to the next item.
 
 4. Add code to set `index` back to zero if it reaches the end of the array (`characters.count`).
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")
//#-end-hidden-code
//#-editable-code(id1)
let emoji = "✨🌝🔦💫👀☄️🌎"
// Split emoji into an array of single-character strings.

//#-end-editable-code

// Index to next item in characters array.
var index = 0

func addText(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
    //#-editable-code(id2)
    var chosenEmoji = "🐠"
    // Set chosenEmoji to item index of characters array.
    
    // Create graphic from the chosen emoji.
    let graphic = Graphic(text: chosenEmoji)
    // Increment index to point to next item.
    
    // Reset index if it’s reached the end of the array.
    
    // Set `scale` and `rotation`.
    graphic.scale = 1.5
    graphic.rotation = randomDouble(from: 0.0, to: 180)
    //#-end-editable-code
    scene.place(graphic, at: touch.position)
}
//#-hidden-code
let textTool = Tool(name: "Text", emojiIcon: "👀")
textTool.onFingerMoved = addText
scene.tools.append(textTool)

playgroundEpilogue()

//#-end-hidden-code




