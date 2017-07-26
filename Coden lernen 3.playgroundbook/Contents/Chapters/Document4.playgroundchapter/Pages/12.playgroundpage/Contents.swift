//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Create:** Use your new skills with event handlers to code your own cool project!
 
 When you’re finished with your project, move on to the [**next chapter**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, %, "", !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.clear()
// Use your own background image.
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
// Add your own code to set up the scene.

// With the Balloon tool selected, this function is called each time your finger moves.
func addBalloon(touch: Touch) {
    if touch.previousPlaceDistance < 100 { return }
    
    // Replace with your own code.
    let graphic = Graphic(text: "🎈")
    graphic.scale = randomDouble(from: 4, to: 8)
    scene.place(graphic, at: touch.position)
}

// With the Pop tool selected, this function is called when you touch a graphic.
func popBalloon(graphic: Graphic) {
    // Replace with your own code.
    graphic.fadeOut(after: 1)
    playSound(.pop)
}

// This function is called when the Go button is tapped.
func go() {
    // Replace with your own code.
    for graphic in scene.graphics {
        graphic.rotation = randomDouble(from: -45, to: 45)
        graphic.scale = randomDouble(from: 4, to: 8)
    }
}

// Change the tools or add new tools.
let balloonTool = Tool(name: "Balloon", emojiIcon: "🎈")
balloonTool.onFingerMoved = addBalloon
scene.tools.append(balloonTool)

let popTool = Tool(name: "Pop", emojiIcon: "📌")
popTool.onGraphicTouched = popBalloon(graphic:)
scene.tools.append(popTool)

// Change the button.
let button = Button(name: "Go")
button.onTap = go
scene.button = button
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
