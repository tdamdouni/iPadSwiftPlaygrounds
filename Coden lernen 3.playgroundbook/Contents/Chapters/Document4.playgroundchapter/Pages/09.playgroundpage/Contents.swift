//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Create a tool to play a specific sound when you touch a particular graphic.
 
 You can make Blu’s universe rock with fabulous sound effects and other-worldly music!
 
 In the `soundGraphic()` function below, you play a sound effect by calling `playSound()`, passing in an option from the `Sounds` enumeration. If the sound is too loud, set the optional `volume` parameter to an `Int` from 0 (silent) to 100 (🙉).
 
  If you select the **Sound** tool, `soundGraphic()` is called each time you touch a graphic. If you touch Blu, the code plays Blu’s dance routine. If you touch any other graphic—such as a fruit—it should play a different sound.
 
 The **Fruit** tool scatters pears, oranges, and lemons. Write code to play a different sound depending on the type of fruit you touch. But how will you know which type of fruit a graphic is? Well, each graphic is created from an emoji using `Graphic(text:)`, so just check if its `text` property matches the emoji.
 
 * callout(Example):
    `if graphic.text == "🍐"`

 1. In `soundGraphic()`, add an `if` statement for 🍐, 🍊, and 🍋, checking to see if the touched graphic is that fruit.
 2. Inside each `if` statement, play a different sound.
 3. Run the code, then use the **Fruit** tool to add more fruit. Choose the **Sound** tool, then touch the fruit to make sure you hear a different sound for each type.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, %, "", &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), text, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))
let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

// Event handler for Sound tool.
func soundGraphic(graphic: Graphic) {
    
    // Play a sound for Blu.
    if graphic == blu {
        playSound(.bluDance, volume: 75)
    }
    
    // Play a different sound for each type of fruit.
    
}

// Event handler for Fruit tool.
func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍐🍊🍋".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 2.0
}

// Create and add Fruit tool.
let fruitTool = Tool(name: "Fruit", emojiIcon: "🍊")
fruitTool.onFingerMoved = addFruit(touch:)
scene.tools.append(fruitTool)

// Create and add Sound tool.
let soundTool = Tool(name: "Sound", emojiIcon: "📣")
soundTool.onGraphicTouched = soundGraphic(graphic:)
scene.tools.append(soundTool)
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()
    
//#-end-hidden-code
