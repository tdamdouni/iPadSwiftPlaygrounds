//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Create a tool to speak when you touch a graphic.
 
 Did you know your iPad can talk to you?!
 
 Whenever you call `speak()`, the [speech synthesizer](glossary://speech%20synthesis) speaks the string you pass as a parameter.
 
 * callout(Speaking a string):
    `speak("Hello!")`
 
 In the code the `speakText(graphic:)` function speaks the text of a graphic created with a string. You can set a tool’s `onGraphicTouched` property to this function using its [full function name](glossary://full%20function%20name).
 
 * callout(Example):
    `speakTool.onGraphicTouched = speakText(graphic:)`
 
 `speakText(graphic:)` is now called each time you touch a graphic.
 
 1. Add a **Speak** tool and set `speakText(graphic:)` as its “graphic touched” event handler.
 2. Run the code and use the **Fruit** and **Greeting** tools to place some graphics on the scene.
 3. Select your new **Speak** tool and tap any graphic.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

/// Speaks the provided text.
func speak(_ text: String) {
    
    var voice = SpeechVoice(accent: .american)
    voice.pitch = 40
    voice.speed = 20
    
    speak(text, voice: voice)
}

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
// Speak the text of graphic.
func speakText(graphic: Graphic) {
    speak(graphic.text)
}

// With the Fruit tool selected, this function is called each time your finger moves.
func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 1.5
}

// With the Greeting tool selected, this function is called each time your finger moves.
func addGreeting(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let greetings = ["howdy!", "hello", "hi", "ciao", "yo!", "hey!", "what’s up?"]
    let greeting = greetings.randomItem
    let graphic = Graphic(text: greeting)
    graphic.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
    graphic.fontName = .chalkduster
    scene.place(graphic, at: touch.position)
    graphic.rotation = randomDouble(from: -30, to: 30)
}

// Create and add Fruit tool.
let fruitTool = Tool(name: "Fruit", emojiIcon: "🍒")
fruitTool.onFingerMoved = addFruit(touch:)
scene.tools.append(fruitTool)

// Create and add Greeting tool.
let greetingTool = Tool(name: "Greeting", emojiIcon: "🙏")
greetingTool.onFingerMoved = addGreeting(touch:)
scene.tools.append(greetingTool)

// Create and add Speak tool.


//#-end-editable-code
//#-hidden-code
assessmentController?.customInfo["tools"] = scene.tools

playgroundEpilogue()

//#-end-hidden-code
