//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Create:** Turn Blu’s universe into a musical instrument.
 
 First run the code, then slide your finger around the scene like a DJ would. Can you guess how the code works?
 
 `playInstrument(touch:)` is the “finger moved” event handler for the **Play** tool. Each time your finger moves by more than `minimumDistance`, a note is played.
 
 In the x direction, the location you touch determines which note is played, similar to a virtual keyboard. In the y direction, the higher your finger moves, the louder the notes are played.
 
 For visual effect, each time a note is played, a graphic is placed on the scene at the touch position. The `scale` value of the graphic is set based on the volume, and the graphic is coded to fade away after a few seconds.
 
 Have fun playing with and customizing the instrument! Here are some ideas:
 
 * Instead of the snowflake ❄️, try a different emoji. Or pick an emoji from an array of emoji characters, depending on which note is being played.
 
 * Experiment with the graphic’s `scale` value, and `fadeOut(after:)` time.
 
 * Use a different instrument for each quadrant of the scene.
 
 When you’re finished making music, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, numberOfCharacters, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
let theOrigin = Point(x: 0, y: 0)

// Position of the last placed note.
var lastNotePosition = theOrigin
// Number of available notes.
let numberOfNotes = 16
// Maximum volume.
let maxVolume = 100
// Minimum distance between notes.
let minimumDistance = 100

// Event handler for the Piano tool.
func playInstrument(touch: Touch) {
    
    // Space out the graphics.
    if touch.numberOfObjectsPlaced > 0 {
        let distanceFromLastNote = touch.position.distance(from: lastNotePosition)
        if distanceFromLastNote < minimumDistance { return }
    }
    // Save the last position.
    lastNotePosition = touch.position
    
    // Converts the x and y touch positions to be from 0 to 1.
    let normalizedXPosition = (touch.position.x + 500) / 1000
    let normalizedYPosition = (touch.position.y + 500) / 1000
    
    // The note depends on the x position.
    let note = normalizedXPosition * (numberOfNotes - 1)
    // The volume depends on the y position.
    let volume = normalizedYPosition * maxVolume
    
    // Play the note.
    playInstrument(.piano, note: note, volume: volume)
    
    // Place a graphic for the note.
    let graphic = Graphic(text: "❄️")
    scene.place(graphic, at: touch.position)
    // The scale depends on the volume.
    graphic.scale = volume / 10
    // Fade the graphic away after a short time.
    graphic.fadeOut(after: 1.5)
}

// Create and add the Play tool.
let playTool = Tool(name: "Play", emojiIcon: "🎹")
playTool.onFingerMoved = playInstrument(touch:)
scene.tools.append(playTool)

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
