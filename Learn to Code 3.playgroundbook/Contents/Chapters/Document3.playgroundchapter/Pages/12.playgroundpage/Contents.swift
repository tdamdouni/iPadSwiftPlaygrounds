//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Write a scary story for your iPad to read.
 
 It’s time to put your imagination to work by writing a scary micro-story set in the vastness of Blu’s universe. Your *very* short story is presented one line at a time, with each line illustrated by emoji.
 
 You write the story by adding each line to a `lines` array, and by putting emoji in an `illustrations` array to illustrate each line.
 
 For variety, you can use string interpolation in the story to insert a random choice of character from a `people` array, and something random to wear from `thingsToWear`.
 
 1. Read through the code and see if you can figure out what it does.
 2. Run the code, using **Next ▶︎** to step through the story one line at a time. 
 3. Use your imagination and think of a couple of lines to replace the lines beginning with "...". Remember to illustrate the lines by replacing the corresponding emoji in the `illustrations` array.
 
 When you’re done, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, !, *, /, %, "", scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), rotation)
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
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")

var lines: [String] = []
var illustrations: [String] = []

//#-end-editable-code
func makeStory() {
    //#-editable-code
    //➤ Replace with your own characters.
    let maria = "Maria 👧🏽"
    let jay = "Jay 👦🏾"
    let kumar = "Kumar 👦🏼"
    let lisa = "Lisa 👶🏻"
    let people = [maria, jay, kumar, lisa]
    
    //➤ Replace with your things to wear.
    let shoes = "shoes 👠"
    let jeans = "jeans 👖"
    let glasses = "sunglasses 🕶"
    let lipstick = "lipstick 💄"
    let thingsToWear = [shoes, jeans, glasses, lipstick]
    
    //➤ Add more descriptive words.
    let typesOf = ["pink", "spotted", "ripped", "baggy", "glittery", "cool", "smelly"]
    
    // Choose the words to use.
    let person = people.randomItem
    let words = person.components(separatedBy: " ")
    let name = words[0]
    let face = words[1]
    let wearWords = thingsToWear.randomItem.components(separatedBy: " ")
    let wear = wearWords[0]
    let wearPicture = wearWords[1]
    let typeOf = typesOf.randomItem
    
    // Story lines.
    lines = [String]()
    lines.append("Alone in the depths of space,")
    lines.append("and wearing only \(typeOf) \(wear),")
    lines.append("\(name) got off the cosmic bus.")
    lines.append("That was the last anyone saw of \(name).")
    //➤ Replace with your own lines.
    lines.append("...what happened to \(name)?...")
    lines.append("...use your imagination!...")
    lines.append("The End.")

    // Story illustrations.
    illustrations = [String]()
    illustrations.append("🌌🌙🌌 \(face) 🌌💫🌌")
    illustrations.append(wearPicture)
    illustrations.append("🌠 🚐 🌠🌠 🚶🏽 🌠")
    illustrations.append("😱")
    //➤ Replace with your own emoji.
    illustrations.append("⚡️⁉️⚡️")
    illustrations.append("⚡️👹👽👾👻⚡️")
    illustrations.append("〰️")
    //#-end-editable-code
}

var index: Int = 0

func nextLine() {
    //#-editable-code
    if index == 0 {
        makeStory()
    }
    
    // Lines and illustrations must match.
    if lines.count != illustrations.count {
        speak("check your code")
        scene.write("🚫 lines has \(lines.count) items!")
        scene.write("🚫 illustrations has \(illustrations.count) items!")
        return
    }
    
    // Get line and emoji.
    let line = lines[index]
    let emoji = illustrations[index]
    
    // Write line.
    scene.write(line)
    
    // Write emoji.
    scene.write(emoji)
    
    // Speak line.
    speak(line)
    
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

//#-end-hidden-code

