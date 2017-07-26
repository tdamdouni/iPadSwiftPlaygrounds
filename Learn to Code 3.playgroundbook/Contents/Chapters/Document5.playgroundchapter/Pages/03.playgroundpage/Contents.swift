//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Build something amazing—you decide!
 
 Bring your creative and coding skills together to come up with a cool new idea. Code it right here, and surprise yourself and your friends.
 
 When you’re finished with your creation, [continue your coding journey](playgrounds://featured).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, numberOfCharacters, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()
//#-end-hidden-code
//#-editable-code
//➤ Use your own background image.
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
//➤ Add your own code to set up the scene.

// With Tool A selected, this function is called each time your finger moves.
func addEmoji(touch: Touch) {
    if touch.previousPlaceDistance < 80 { return }
    
    //➤ Replace with your own code.
    var graphic = Graphic(text: "🔵")
    scene.place(graphic, at: touch.position)
    graphic.scale = 1.5
}

// With Tool B selected, this function is called when you touch a graphic.
func speakText(graphic: Graphic) {
    //➤ Replace with your own code.
    speak(graphic.text)
}

// This function is called when the Red button is tapped.
func redButtonTapped() {
    //➤ Replace with your own code.
    scene.write("🔴")
}

//➤ Change the tools or add new tools.
let toolA = Tool(name: "Tool A", emojiIcon: "🅰️")
toolA.onFingerMoved = addEmoji(touch:)
scene.tools.append(toolA)

let toolB = Tool(name: "Tool B", emojiIcon: "🅱️")
toolB.onGraphicTouched = speakText(graphic:)
scene.tools.append(toolB)

//➤ Change the button.
let redButton = Button(name: "Red")
redButton.onTap = redButtonTapped
scene.button = redButton
//#-end-editable-code

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code
