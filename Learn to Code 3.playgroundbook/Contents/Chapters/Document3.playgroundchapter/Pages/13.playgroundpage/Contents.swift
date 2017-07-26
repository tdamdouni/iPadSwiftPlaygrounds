//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Use your new skills with strings to code your own cool project!
 
 When you’re finished with your project, move on to the [**next chapter**](@next).
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
    
    var voice = SpeechVoice(accent: .irish)
    voice.pitch = 50
    voice.speed = 20
    
    speak(text, voice: voice)
}

//#-end-hidden-code
//#-editable-code
scene.clear()
//➤ Use your own background image.
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
//➤ Add your own code to set up the scene.

// With the Text tool selected, this function is called each time your finger moves.
func addText(touch: Touch) {
    if touch.previousPlaceDistance < 100 { return }
    
    //➤ Replace with your own code.
    let name = "Blu"
    let graphic = Graphic(text: "hello \(name)")
    graphic.fontName = .zapfino
    graphic.fontSize = 40
    graphic.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    scene.place(graphic, at: touch.position)
}

// This function is called when the Go button is tapped.
func go() {
    //➤ Replace with your own code.
    speak("Go!")
}
//#-end-editable-code
//#-hidden-code

let textTool = Tool(name: "Text", emojiIcon: "✍🏽")
textTool.onFingerMoved = addText
scene.tools.append(textTool)

let goButton = Button(name: "Go")
goButton.onTap = go
scene.button = goButton

playgroundEpilogue()

//#-end-hidden-code

