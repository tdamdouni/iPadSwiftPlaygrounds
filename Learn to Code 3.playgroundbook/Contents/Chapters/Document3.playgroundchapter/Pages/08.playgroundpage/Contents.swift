//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Use the **Text** tool to place text on the scene.
 
 Run the code, and you’ll notice a new **Text** tool. You can use this tool to place text on the scene.
 
 With the **Text** tool selected, `addText()` is called every time your finger moves. If your finger has moved far enough, a new `Graphic` instance is created with the text and placed on the scene.
 
 1. In the `addText()` function, change `name`, and perhaps the [font](glossary://font). Now run the code, choose the **Text** tool, and move your finger around the scene.
 
 2. Instead of `name`, use the item at `index` in the `things` array—`things[index]`.
 
 3. Set `graphic.textColor` to the item at `index` in the `colors` array.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")

let name = "blue moon"
let things = ["green star", "black hole", "red giant", "white dwarf"]
let colors = [#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]
//#-end-editable-code
func addText(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/80/*#-end-editable-code*/ { return }
    //#-editable-code(id1)
    // Get index to a random item in things.
    let index = randomInt(from: 0, to: things.count - 1)
    //➤ Create graphic with a string from the things array at index.
    let graphic = Graphic(text: name)
    //➤ Change the font name and size.
    graphic.fontName = .avenirNext
    graphic.fontSize = 25
    //➤ Set to color from the colors array at index.
    graphic.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    //#-end-editable-code
    scene.place(graphic, at: touch.position)
}
//#-hidden-code
let textTool = Tool(name: "Text", emojiIcon: "✍🏽")
textTool.onFingerMoved = addText
scene.tools.append(textTool)

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    // Get index to a random item in things.
//    let index = randomInt(from: 0, to: things.count - 1)
//    //➤ Create graphic with a string from the things array at index.
//    let graphic = Graphic(text: things[index])
//    //➤ Change the font name and size.
//    graphic.fontName = .markerfelt
//    graphic.fontSize = 25
//    //➤ Set to color from the colors array at index.
//    graphic.textColor = colors[index]
//    //#-end-editable-code

//#-end-hidden-code
