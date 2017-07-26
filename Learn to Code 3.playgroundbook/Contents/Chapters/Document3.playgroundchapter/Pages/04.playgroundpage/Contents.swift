//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Make a string containing constants and number values.
 
 You can put a constant or variable right inside a string, like in string `t` below.
 
 * callout(Putting a constant and variable inside a string):
    `let animal = "frog"`\
    `var color = "blue"`\
    `let t = "The \(animal) turned \(color)."`
 
 String `t` now has the value `"The frog turned blue."`. The secret is to put the constant or variable in parentheses `()` with a backslash `\` before it, like this: `\(color)`. This is called [string interpolation](glossary://string%20interpolation).

 You can even include a calculated value in a string as a [code expression](glossary://code%20expression).
 
 * callout(Calculated value in a string):
    `let n = 20`\
    `let t = "\(n) frogs have \(n * 2) legs."`
 
 String `t` now has the value `"20 frogs have 40 legs."`.
 
 1. Use string interpolation to build this greeting for the cosmic bus, from the constants `sentence1`, `sentence2`, and  `destination`: “**Welcome aboard! We’re off to <destination>.**”
 
 2. The bus fare depends on how many light-years the journey takes. Define a `message` string that starts with `"That’ll cost"`, contains the code expression `lightYears * fare`, and ends with `"Jovian dollars."`.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, %, "", -=, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType, isCorrect)


import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

/// Speaks the provided text.
func speak(_ text: String) {
    
    var voice = SpeechVoice(accent: .american)
    voice.pitch = 50
    voice.speed = 20
    
    speak(text, voice: voice)
}

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let sentence1 = "Welcome aboard"
let sentence2 = "We’re off to"
let destination = /*#-editable-code*/"the center of the universe."/*#-end-editable-code*/
let lightYears = /*#-editable-code*/5/*#-end-editable-code*/
let fare = /*#-editable-code*/42/*#-end-editable-code*/
//#-hidden-code
//#-end-hidden-code
//➤ Put together the rest of the greeting using string interpolation.
let greeting = /*#-editable-code*/"\(sentence1)"/*#-end-editable-code*/
scene.write(greeting)
speak(greeting)
//➤ Put together the fare message using string interpolation.
let message = /*#-editable-code*/"That’ll cost"/*#-end-editable-code*/
scene.write(message)
speak(message)
//#-hidden-code
var isCorrect = false
if greeting.hasPrefix("\(sentence1)") && greeting.contains(sentence2) && greeting.hasSuffix(destination) && message.hasPrefix("That’ll cost") && message.contains("\(lightYears*fare)") && message.lowercased().hasSuffix("jovian dollars.") {
    isCorrect = true
}
assessmentController?.customInfo["passed"] = isCorrect

var tools: [Tool] = []
scene.tools = tools

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code
//    //➤ Put together the rest of the greeting using string interpolation.
//    let greeting = "\(sentence1)! \(sentence2) \(destination)."
//    scene.write(greeting)
//    speak(greeting)
//    //➤ Put together the fare message using string interpolation.
//    let message = "That’ll cost \(lightYears * fare) jovian dollars."
//    scene.write(message)
//    speak(message)
//    //#-end-editable-code

//#-end-hidden-code
