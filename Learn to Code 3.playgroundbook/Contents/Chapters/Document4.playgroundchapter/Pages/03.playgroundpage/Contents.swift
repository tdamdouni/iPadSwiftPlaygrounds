//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Add different tools to the toolbox.
 
 The code below has three “finger moved” event handler functions that do very different things. Notice that they all have the same `Touch` parameter. Each time a “finger moved” event occurs, the event handler is called with a `Touch` instance containing information about that particular touch movement, such as:
 
 * `position`: Current finger position
 * `previousPlaceDistance`: Distance from the last placed graphic
 * `numberOfObjectsPlaced`: Number of graphics placed so far
 
 You can use these `Touch` properties in the event handler function. For example, `previousPlaceDistance` can be used to space out placed graphics.
 
 Add a tool for each of the event handler functions, `addFruit()`, `addSwirlingAlien()`, and `addGreeting()`.
 
 1. Create a tool, giving it a name and emoji icon.
 2. Set the tool’s “finger moved” event handler to the related function.
 3. Add the new tool to the scene’s tools.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")

func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍏🍐🍊🍋🍉🍒🍓🍌".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = randomDouble(from: 0.5, to: 2.0)
}

func addSwirlingAlien(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let graphic = Graphic(image: #imageLiteral(resourceName: "alien@2x.png"))
    scene.place(graphic, at: touch.position)
    graphic.swirlAway(after: 2.5)
}

func addGreeting(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let greetings = ["howdy", "hello", "hi", "g’day"]
    let greeting = greetings.randomItem
    let graphic = Graphic(text: greeting)
    graphic.textColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    graphic.fontName = .chalkduster
    scene.place(graphic, at: touch.position)
    graphic.rotation = randomDouble(from: -30.0, to: 30.0)
}

//➤ Create and add Fruit tool.

//➤ Create and add Alien tool.

//➤ Create and add Greeting tool.

//#-end-editable-code
//#-hidden-code
assessmentController?.customInfo["tools"] = scene.tools
playgroundEpilogue()

//** Completed Code **

//    //➤ Create and add Fruit tool.
//    let fruitTool = Tool(name: "Fruit", emojiIcon: "🍒")
//    fruitTool.onFingerMoved = addFruit(touch:)
//    scene.tools.append(fruitTool)
//    //➤ Create and add Alien tool.
//    let alienTool = Tool(name: "Alien", emojiIcon: "👽")
//    alienTool.onFingerMoved = addSwirlingAlien(touch:)
//    scene.tools.append(alienTool)
//    //➤ Create and add Greeting tool.
//    let greetingTool = Tool(name: "Greeting", emojiIcon: "🙏")
//    greetingTool.onFingerMoved = addGreeting(touch:)
//    scene.tools.append(greetingTool)
    
//#-end-hidden-code
