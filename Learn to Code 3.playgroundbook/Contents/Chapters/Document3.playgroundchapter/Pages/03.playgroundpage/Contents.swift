//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Make a string from other strings.
 
 You can make strings from other strings. One way to do this is to add one string to another.
 
 * callout(Adding strings together using +):
    `let place = "planet " + "Soccerball"`
 
 Another way is to declare a [variable](glossary://variable) (which can be changed) and [append](glossary://append) to it.
 
 * callout(Appending to a String variable using +=):
    `var place = "planet "`\
    `place += "Tennisball"`

 Adding strings this way is called [string concatenation](glossary://string%20concatenation).
 
 The cosmic bus will whisk you around Blu’s universe at hyperspeed. By adding strings to the `greeting` variable, you can put together a welcome greeting for the bus: “**Welcome aboard! We’re off to <destination>.**”.
 
 1. `sentence1` is already appended to `greeting`, so append an exclamation mark (`"!"`) after it.
 2. Append a space, like this: `greeting += " "`. Remember to separate words by appending a space.
 3. Append `sentence2`, followed by `destination` and then a period (full stop).
 4. Add code to speak the greeting.
  */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType, isCorrect, correctGreeting)



import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

/// Speaks the provided text.
func speak(_ text: String) {
    
    var voice = SpeechVoice(accent: .american)
    voice.pitch = 50
    voice.speed = 15
    
    speak(text, voice: voice)
}

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let sentence1 = "Welcome aboard"
let sentence2 = "We’re off to"
let destination = /*#-editable-code*/"the end of the universe."/*#-end-editable-code*/
var greeting = ""
//#-hidden-code
let correctGreeting = "\(sentence1)! \(sentence2) \(destination)."
//#-end-hidden-code
//#-editable-code
greeting += sentence1
//➤ Put together the rest of the greeting.

// Print the greeting.
scene.write(greeting)
//➤ Speak the greeting.

//#-end-editable-code
//#-hidden-code
var isCorrect = false
if greeting.withoutWhitespace == correctGreeting.withoutWhitespace && greeting.hasPrefix("\(sentence1)!") {
    isCorrect = true
}
assessmentController?.customInfo["passed"] = isCorrect
assessmentController?.customInfo["greeting"] = greeting

var tools: [Tool] = []
scene.tools = tools

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code
//    greeting += sentence1
//    //➤ Put together the rest of the greeting.
//    greeting += "! "
//    greeting += sentence2
//    greeting += " "
//    greeting += destination
//    greeting += "."
//    // Print the greeting.
//    scene.write(greeting)
//    //➤ Speak the greeting.
//    speak(greeting)
//    //#-end-editable-code

//#-end-hidden-code
