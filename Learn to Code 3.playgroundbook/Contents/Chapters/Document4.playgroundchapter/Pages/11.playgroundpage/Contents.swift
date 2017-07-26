//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Customize your own soundboard.
 
 Musicians often use an iPad as if it’s another instrument. The soundboard here lets you do just that—you can play it and write your own code to customize it.
 
 You use the instrument tools to add instrument graphics to the scene. When you select the **Play** tool and touch an instrument graphic, a note plays. Its pitch (high or low) depends on how far it is from the center of the scene. Using the **Move** tool, you can move graphics around until they play exactly the note you want.
 
 The **➕** and **➖** tools allow you to set the volume of an instrument graphic. Select either of these tools, and when you touch a graphic, its `alpha` and `scale` values change. Big and bright is loud; small and faded is quiet.
 
 Play with the soundboard and read the code carefully until you understand how it all works. Then try changing the tools or adding your own tools. (For ideas, tap **Hint**.)
 
 When you’re finished making music, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, %, "", !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
//#-editable-code
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
let theOrigin = Point(x: 0, y: 0)

// Set volume of a graphic from 0.0 (silent) to 1.0 (full).
func setVolume(graphic: Graphic, volume: Number) {
    graphic.alpha = volume
    graphic.scale = volume * 3.0
}

// Add instrument graphic to the scene.
func addInstrument(emoji: String, touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let graphic = Graphic(text: emoji)
    scene.place(graphic, at: touch.position)
    // Set volume to 80%
    setVolume(graphic: graphic, volume: 0.8)
}

// Event handler for Piano tool
func addPiano(touch: Touch) {
    addInstrument(emoji: "🎹", touch: touch)
}

// Event handler for Guitar tool
func addGuitar(touch: Touch) {
    addInstrument(emoji: "🎸", touch: touch)
}

// Event handler for Cosmic Drums tool
func addCosmicDrums(touch: Touch) {
    addInstrument(emoji: "🔮", touch: touch)
}

// Number of notes
let noteSteps = 16

// Event handler for Play tool
func playInstrument(graphic: Graphic) {
    
    // Distance from center 0.0 - 1.0
    let distance = graphic.distance(from: theOrigin) / 707.0
    
    // Translate distance into closest note Int value.
    let note = (1.0 - distance) * noteSteps
    
    // Translate alpha into volume value.
    let volume = graphic.alpha * 100.0
    
    // Play note with instrument
    if graphic.text == "🎹" {
        playInstrument(.piano, note: note, volume: volume)
    }
    
    if graphic.text == "🎸" {
        playInstrument(.electricGuitar, note: note, volume: volume)
    }
    
    if graphic.text == "🔮" {
        playInstrument(.cosmicDrums, note: note, volume: volume)
    }
}

// Event handler for volume +
func volumeUp(graphic: Graphic) {
    var volume = graphic.alpha + 0.2
    if volume > 1.0 {
        volume = 1.0
    }
    setVolume(graphic: graphic, volume: volume)
}

// Event handler for volume -
func volumeDown(graphic: Graphic) {
    var volume = graphic.alpha - 0.2
    if volume < 0.4 {
        volume = 0.4
    }
    setVolume(graphic: graphic, volume: volume)
}

// Create instrument tools.
let pianoTool = Tool(name: "Piano", emojiIcon: "🎹")
pianoTool.onFingerMoved = addPiano(touch:)
let guitarTool = Tool(name: "Guitar", emojiIcon: "🎸")
guitarTool.onFingerMoved = addGuitar(touch:)
let cosmicDrumsTool = Tool(name: "Cosmic", emojiIcon: "🔮")
cosmicDrumsTool.onFingerMoved = addCosmicDrums(touch:)

// Add instrument tools.
scene.tools.append(pianoTool)
scene.tools.append(guitarTool)
scene.tools.append(cosmicDrumsTool)

// Create and add Play tool.
let playTool = Tool(name: "Play", emojiIcon: "👇")
playTool.onGraphicTouched = playInstrument(graphic:)
scene.tools.append(playTool)

// Create and add Volume tools.
let volumeUpTool = Tool(name: "➕", emojiIcon: "")
volumeUpTool.onGraphicTouched = volumeUp(graphic:)
scene.tools.append(volumeUpTool)
let volumeDownTool = Tool(name: "➖", emojiIcon: "")
volumeDownTool.onGraphicTouched = volumeDown(graphic:)
scene.tools.append(volumeDownTool)

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
