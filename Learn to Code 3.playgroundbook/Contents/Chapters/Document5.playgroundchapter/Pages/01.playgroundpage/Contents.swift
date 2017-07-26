//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Turn Blu’s universe into a musical instrument.
 
 Become an intergalactic musician as you play the universe!
 
 First run the code, then slide your finger around the scene like a DJ would. Can you guess how the code works?
 
 `playInstrument(touch:)` is the “finger moved” event handler for the **Play** tool. Each time your finger moves the minimum distance defined in `distanceFromLastNote`, a note is played.
 
 In the x direction, the location you touch determines which note is played, similar to a virtual keyboard. In the y direction, the higher your finger moves, the louder the notes are played.
 
 For visual effect, each time a note is played, a graphic is placed on the scene at the touch position. The `scale` value of the graphic is set based on the volume, and the graphic is coded to fade away after a few seconds.
 
 Have fun playing with and customizing the instrument! (For ideas, tap **Hints**.) 
 
 When you’re finished making music, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, numberOfCharacters, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")

let theOrigin = Point(x: 0, y: 0)
var lastNotePosition = theOrigin

let numberOfNotes = 16
let maxVolume = 100

// Event handler for Piano tool
func playInstrument(touch: Touch) {
    
    if touch.numberOfObjectsPlaced > 0 {
        let distanceFromLastNote = touch.position.distance(from: lastNotePosition)
        if distanceFromLastNote < 100 { return }
    }
    
    // Converts the x and y touch positions to be from 0 to 1
    let normalizedXPosition = (touch.position.x + 500) / 1000
    let normalizedYPosition = (touch.position.y + 500) / 1000
    
    let note = normalizedXPosition * (numberOfNotes - 1)
    
    lastNotePosition = touch.position

    let volume = normalizedYPosition * maxVolume
    
    playInstrument(.piano, note: note, volume: volume)
    
    let graphic = Graphic(text: "❄️")
    scene.place(graphic, at: touch.position)
    graphic.scale = volume / 10
    graphic.fadeOut(after: 1.5)
}

// Create Instrument Tools
let playTool = Tool(name: "Play", emojiIcon: "🎹")
playTool.onFingerMoved = playInstrument(touch:)
scene.tools.append(playTool)

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
