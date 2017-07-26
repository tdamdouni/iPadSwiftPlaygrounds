//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
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
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")

func modifyGraphic(graphic: Graphic) {
    //➤ Modify alpha.
    
    // Modify scale.
    if graphic.scale < 2.0 {
        graphic.scale = 2.5
    } else {
        graphic.scale = 1.5
    }
}

func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 2.5
}

let fruitTool = Tool(name: "Fruit", emojiIcon: "🍒")
fruitTool.onFingerMoved = addFruit
scene.tools.append(fruitTool)

let modifyTool = Tool(name: "Modify", emojiIcon: "⚒")
modifyTool.onGraphicTouched = modifyGraphic
scene.tools.append(modifyTool)
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    //➤ Modify alpha.
//    if graphic.alpha < 0.5 {
//        graphic.alpha = 0.2
//    } else {
//        graphic.alpha = 1.0
//    }
//    //#-end-editable-code

//#-end-hidden-code
