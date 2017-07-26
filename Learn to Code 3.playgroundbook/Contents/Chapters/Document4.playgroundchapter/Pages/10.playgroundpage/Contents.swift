//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Create a tool to play an instrument when you touch a graphic.
 
 Use your coding skills to compose and play intergalactic music using instruments such as the guitar (electric and bass), piano, and—Blu’s favorite—the cosmic drums.
 
 To play an instrument, you call `playInstrument()`, choosing your instrument and a note to play.
 
 * callout(Example):
    `playInstrument(.piano, note: 12, volume: 50)`
 
 Each instrument has 16 notes, so the `note` parameter is an `Int` from 0 to 15. As with `playSound()`, the `volume` parameter is optional.
 
 Write code to make each type of fruit graphic play a different note when you touch it.
 
 1. In `musicalGraphic()`, add an `if` statement for 🍐, 🍊, and 🍋, playing a different instrument and a note of your choice for each type of fruit.
 2. Run the code, then use the **Fruit** tool to add some fruit. Select the **Music** tool, then touch the fruit to make sure you hear a different note for each type.
 3. **Challenge**: Try setting the note for each to a random `Int` from 0 to 15.
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
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")

let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))
let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

// Event handler for Music tool.
func musicalGraphic(graphic: Graphic) {
    
    // Play a note for Blu.
    if graphic == blu {
        playInstrument(.cosmicDrums, note: 12, volume: 50)
    }
    
    //➤ Play a note on a different instrument for each type of fruit.
    if graphic.text == "🍐" {
        
    }
}

// Event handler for Fruit tool.
func addFruit(touch: Touch) {
    if touch.previousPlaceDistance < 60 { return }
    let fruit = "🍐🍊🍋".componentsByCharacter()
    let graphic = Graphic(text: fruit.randomItem)
    scene.place(graphic, at: touch.position)
    graphic.scale = 2.0
}

// Add Fruit tool.
let fruitTool = Tool(name: "Fruit", emojiIcon: "🍊")
fruitTool.onFingerMoved = addFruit(touch:)
scene.tools.append(fruitTool)

// Add Music tool.
let musicTool = Tool(name: "Music", emojiIcon: "🎼")
musicTool.onGraphicTouched = musicalGraphic(graphic:)
scene.tools.append(musicTool)
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    // Play a note for Blu.
//    if graphic == blu {
//        playInstrument(.cosmicDrums, note: 12, volume: 50)
//    }
//        
//    //➤ Play a note on a different instrument for each type of fruit.
//    let note = randomInt(from: 0, to: 15)
//
//    if graphic.text == "🍐" {
//        playInstrument(.piano, note: note)
//    }
//    
//    if graphic.text == "🍋" {
//        playInstrument(.electricGuitar, note: note)
//    }
//
//    if graphic.text == "🍊" {
//        playInstrument(.cosmicDrums, note: note)
//    }
//    //#-end-editable-code


//#-end-hidden-code
