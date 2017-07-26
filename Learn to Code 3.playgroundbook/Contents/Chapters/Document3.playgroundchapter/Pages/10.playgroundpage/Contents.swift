//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Experiment:** Build random sentences to a pattern.
 
 You can write code that builds sentences from random words when you move your finger across the scene.
 
 In the code below, you’ll find arrays of different kinds of words. They’re your raw [data](glossary://data) for building sentences.
 
 1. Look at the code, and then run it.
 2. Choose the **Text** tool, and swipe your finger down the scene. Notice that each time your finger moves a certain distance, a new sentence is generated using a simple sentence pattern (*The <creature> <action>.*). The sentence is built using [string interpolation](glossary://string%20interpolation) from words that are picked at random from one of the word arrays.
 3. Build a more complicated sentence matching the pattern *<name> <verb> <preposition> the <adjective> <creature>*; for example, “Ben leapt over the cantankerous cat.”
 4. Add some of your own words, use your friends’ names, and try other sentence patterns!
 
 When you’re done, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")

let names = ["Ben", "Zack", "Carla", "Simone", "June", "Ute", "Felix"]
let creatures = ["bird", "dog", "cat", "sister", "teacher", "skunk"]
let places = ["car", "mud", "bed", "swamp", "pool", "jelly", "fish tank"]
let adjectives = ["irate", "sensational", "crooked", "cantankerous", "doleful"]
let actions = ["landed", "barked", "leapt", "roared", "jumped", "kicked"]
let prepositions = ["at", "over", "under", "through", "around", "onto"]
//#-end-editable-code

func addLabel(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/60/*#-end-editable-code*/ { return }
    //#-editable-code
    // Get random words.
    let name = names.randomItem
    let adjective = adjectives.randomItem
    let creature = creatures.randomItem
    let place = places.randomItem
    let action = actions.randomItem
    let preposition = prepositions.randomItem
    //➤ Put the sentence together.
    let sentence = "The \(creature) \(action)."
    //#-end-editable-code
    let graphic = Graphic(text: sentence)
    scene.place(graphic, at: touch.position)
}

//#-hidden-code

let textTool = Tool(name: "Text", emojiIcon: "✍🏽")
textTool.onFingerMoved = addLabel
scene.tools.append(textTool)

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    //➤ Put the sentence together.
//    let sentence = "\(name) \(verb) \(preposition) the \(adjective) \(creature)."
//    //#-end-editable-code


//#-end-hidden-code
