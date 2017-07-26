//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Create a tool to change a graphic when you touch it.
 
 In a “graphic touched” event handler function, you can examine the properties of a touched graphic and do something based on those properties.
 
 * callout(Acting on the position of a touched graphic):
    `if graphic.position.y < 0 {`\
    `   // Do something`\
    `}`
 
 Look at the `modifyGraphic()` function in the code below—the scale of the graphic changes based on its current scale value. Try it out by placing some fruit, then selecting the **Modify** tool and tapping the fruit.
 
 In addition to `scale` and `rotation`, a graphic also has a property called `alpha`, which you can set to make the graphic transparent (see-through). Normally, the value of `alpha` is 1.0, and the graphic is not transparent. But you can set `alpha` to any value from 0.0 (fully transparent, or hidden) to 1.0 (fully visible).
 
 1. Change `modifyGraphic()` by setting the value of `alpha` so that when you tap the graphic, it fades to almost transparent.
 2. Now add code that checks the value of `alpha` and, if it’s already faded, makes it fully visible again.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
// “Graphic touched” event handler.
func modifyGraphic(graphic: Graphic) {
    // Modify alpha.
    
    // Modify scale.
    if graphic.scale < 2.0 {
        graphic.scale = 2.5
    } else {
        graphic.scale = 1.5
    }
}
// “Finger moved” event handler.
func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 2.5
}

// Create and add Fruit tool.
let fruitTool = Tool(name: "Fruit", emojiIcon: "🍒")
fruitTool.onFingerMoved = addFruit(touch:)
scene.tools.append(fruitTool)

// Create and add Modify tool.
let modifyTool = Tool(name: "Modify", emojiIcon: "⚒")
modifyTool.onGraphicTouched = modifyGraphic(graphic:)
scene.tools.append(modifyTool)
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
