//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Write code to tell a story.
 
 In this challenge, you’ll write code to tell a story that’s illustrated by emoji. And what better way to try it out than by using a verse from one of Blu’s favorite nonsense poems, “Jabberwocky,” by Lewis Carroll. See how the [speech synthesizer](glossary://speech%20synthesis) handles phrases like “the Jubjub bird”!
 
 The story is in a `lines` array. For each story line, there’s an emoji string in the `illustrations` array to illustrate that line.
 
 There’s also a **Next ▶︎** button that, when tapped, calls the `nextLine()` function. This function writes the next line to the scene with its emoji, and speaks the line. The `index` variable keeps track of which line is being displayed. 
 
 See if you can complete the code in the `nextLine()` function.
 
 1. Set `line` to the item at `index` in the `lines` array.
 
 2. Set `emoji` to the item at `index` in the `illustrations` array.
 
 3. After `line` is written to the scene, add code to write `emoji`.
 
 4. Add code to speak `line`.
*/
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, %, "", +, -, +=, -=, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), rotation)
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

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

var lines: [String] = []
var illustrations: [String] = []

//#-editable-code
// Story lines.
lines = [
    "Beware the Jabberwock, my son!",
    "The jaws that bite, the claws that catch!",
    "Beware the Jubjub bird, and shun",
    "The frumious Bandersnatch!"
]
// Story illustrations.
illustrations = [
    "👹",
    "👹😬",
    "🕊",
    "🐉"
]
//#-end-editable-code

var index: Int = 0

func nextLine() {
    //#-hidden-code
    assessmentController?.customInfo["lines"] = lines
    assessmentController?.customInfo["emojis"] = illustrations
    //#-end-hidden-code
    //#-editable-code(id1)
    // Lines and illustrations must match.
    if lines.count != illustrations.count {
        speak("check your code!")
        scene.write("🚫 lines has \(lines.count) items!")
        scene.write("🚫 illustrations has \(illustrations.count) items!")
        return
    }
    
    //➤ Get line and emoji.
    let line = "line \(index)"
    let emoji = "🗻"
    
    // Write line.
    scene.write(line)
    
    //➤ Write emoji.
    
    //➤ Speak line.
    
    // Next line.
    index += 1
    
    // If finished, start again.
    index = index % lines.count
    //#-end-editable-code
}
//#-hidden-code
let nextButton = Button(name: "Next ▶︎")
nextButton.onTap = nextLine
scene.button = nextButton

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    // Lines and illustrations must match.
//    if lines.count != illustrations.count {
//        speak("check your code!")
//        scene.write("🚫 lines has \(lines.count) items!")
//        scene.write("🚫 illustrations has \(illustrations.count) items!")
//        return
//    }
//
//    //➤ Get line and emoji.
//    let line = lines[index]
//    let emoji = illustrations[index]
//
//    // Write line.
//    scene.write(line)
//
//    //➤ Write emoji.
//    scene.write(emoji)
//
//    //➤ Speak line.
//    speak(line)
//
//    // Next line.
//    index += 1
//
//    // If finished, start again.
//    index = index % lines.count
//    //#-end-editable-code

//#-end-hidden-code

