//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Get your iPad to speak.
 
 Did you know your iPad can speak? Wouldn’t it be cool to see if it can say a tongue twister better than you can?
 
 Naming a string by defining it as a [constant](glossary://constant) makes it handier to use—or even reuse—in your code.
 
 * callout(Creating a string constant):
    `let twister = "Twelve twins twirled twelve twigs."`\
    `scene.write(twister)`
 
 Here, `twister` is a constant of type `String`, usually just called a string.
 
 Whenever you call `speak()`, the [speech synthesizer](glossary://speech%20synthesis) speaks the string you pass as a parameter.
 
 * callout(Speaking a string):
    `speak(twister)`
 
 In the code, you’ll see several of Blu’s terribly tortuous tongue twisters (try saying that fast 😳) as string constants:
 
 1. Add code to speak `twister1` after it’s written to the scene.
 2. Make sure the volume is turned up on your iPad—you wouldn’t want to miss anything!
 2. Run the code and see if your iPad can do better than you can!
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, %, "", ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, bonusTwister1, bonusTwister2, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

/// Speaks the provided text.
func speak(_ text: String) {
    
    var voice = SpeechVoice(accent: .british)
    voice.pitch = 40
    voice.speed = 20
    
    speak(text, voice: voice)
}

let bonusTwister1 = "Sally sells sea shells by the sea shore. But if Sally sells sea shells by the sea shore then where are the sea shells Sally sells?"
let bonusTwister2 = "I thought a thought. But the thought I thought wasn’t the thought I thought I thought."

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let twister1 = "Eleven benevolent elephants."
let twister2 = "Twelve twins twirled twelve twigs."
let twister3 = "The sixth sick sheik’s sixth sheep is sick."
let twister4 = "Annie ate eight Arctic apples."
//#-editable-code
scene.write(twister1)
//➤ Speak the tongue twister.

//#-end-editable-code
//#-hidden-code

var tools: [Tool] = []
scene.tools = tools

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code
//    scene.write(twister1)
//    //➤ Speak the tongue twister.
//    speak(twister1)
//    //#-end-editable-code

//#-end-hidden-code
