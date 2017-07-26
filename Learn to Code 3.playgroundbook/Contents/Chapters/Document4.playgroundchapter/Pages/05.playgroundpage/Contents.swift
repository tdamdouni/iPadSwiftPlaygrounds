//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Create a tool to speak when you touch a graphic.
 
 As you might guess, the `speakText(graphic:)` function speaks the text of a graphic created with a string:
 
 * callout(Function to speak a graphic’s text):
    `func speakText(graphic: Graphic) {`\
    `   speak(graphic.text)`\
    `}`
 
 `speakText(graphic:)` takes a single `Graphic` parameter, so you can use it as an event handler for “graphic touched” events. You can set a tool’s `onGraphicTouched` property to this function using its [full function name](glossary://full%20function%20name).
 
 * callout(Example):
    `speakTool.onGraphicTouched = speakText(graphic:)`
 
 `speakText(graphic:)` is now called each time you touch a graphic.
 
 1. Add a **Speak** tool and set `speakText(graphic:)` as its “graphic touched” event handler.
 2. Run the code and use the **Fruit** and **Greeting** tools to place some graphics on the scene.
 3. Select the **Speak** tool and tap any graphic.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, rotation)
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

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")

func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 1.5
}

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

func speakText(graphic: Graphic) {
    speak(graphic.text)
}

let fruitTool = Tool(name: "Fruit", emojiIcon: "🍒")
fruitTool.onFingerMoved = addFruit(touch:)
scene.tools.append(fruitTool)

let greetingTool = Tool(name: "Greeting", emojiIcon: "🙏")
greetingTool.onFingerMoved = addGreeting(touch:)
scene.tools.append(greetingTool)

//➤ Create and add speak tool

//#-end-editable-code
//#-hidden-code
assessmentController?.customInfo["tools"] = scene.tools

playgroundEpilogue()

//** Completed Code **

//    //➤ Create and add speak tool
//    let speakTool = Tool(name: "Speak", emojiIcon: "🗣")
//    speakTool.onGraphicTouched = speakText(graphic:)
//    scene.tools.append(speakTool)
//    //#-end-editable-code

//#-end-hidden-code
