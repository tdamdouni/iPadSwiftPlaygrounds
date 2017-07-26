//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Create:** Build beautiful dance sequences.
 
 Use the **Dance** button to choreograph a swarm of emoji. Code them to move around in intricate patterns.
 
 When you run the code, 100 emoji graphics are placed at the center of the scene. Each time you tap **Dance**, its event handler `dance()` calls `rearrange()` with a randomly chosen `Int` pattern from 0 to 4. Depending on the pattern, a new set of positions is generated for the graphics. All the graphics are then animated to their new positions.
 
 For variety, the graphics’ `scale` and `rotation` properties are set to random values, and the move happens over a random length of time (`duration`).
 
 Each rearrangement is accompanied by a note on an instrument.
 
 * Experiment with the different sets of emoji.
 
 * Experiment with different ranges for the randomly computed values.
 
 * Change the instrument and notes.
 
 * **Challenge:** Introduce a second set of dancers, using different emoji, and have them dance independently.
 
 When you’re done with dancing emoji, move on to the [**next page**](@next).
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
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
// Emoji dancers.
let emoji = "❤️💛💚💙💜".componentsByCharacter()

let center = Point(x: 0, y: 0)

// Place the dancers on the scene.
for i in 0..<100 {
    let dancer = Graphic(text: emoji[i % emoji.count])
    scene.place(dancer, at: center)
}

// Dance button event handler.
func dance() {
    // Get a new pattern.
    let pattern = randomInt(from: 0, to: 4)
    // Rearrange the dancers.
    rearrange(dancers: scene.graphics, pattern: pattern, instrument: .cosmicDrums)
}

// Rearrange dancers to a pattern accompanied by instrument.
func rearrange(dancers: [Graphic], pattern: Int, instrument: Instrument.Kind) {
    
    var points = [Point]()
    var note = 5
    
    // Start with all points in the center.
    for i in 0..<dancers.count {
        points.append(center)
    }

    // Get a new set of points depending on the pattern:
    // Pattern 0: Points in the center.
    // Pattern 1: Points in a circle.
    if pattern == 1 {
        let radius = randomDouble(from: 100, to: 450)
        points = scene.circlePoints(radius: radius, count: dancers.count)
        note = 14
    }
    // Pattern 2: Points in a square.
    if pattern == 2 {
        let width = randomDouble(from: 100, to: 450)
        points = scene.squarePoints(width: width, count: dancers.count)
        note = 4
    }
    // Pattern 3: Points in a spiral.
    if pattern == 3 {
        let spacing = randomDouble(from: 50, to: 200)
        points = scene.spiralPoints(spacing: spacing, count: dancers.count)
        note = 10
    }
    // Pattern 4: Points in random positions.
    if pattern == 4 {
        for i in 0..<dancers.count {
            points[i].x = randomDouble(from: -500, to: 500)
            points[i].y = randomDouble(from: -500, to: 500)
        }
        
        note = 8
    }
    
    // For any pattern except random (4), shift all points by a random x, y distance.
    if pattern < 4 {
        let dx = randomDouble(from: -400, to: 400)
        let dy = randomDouble(from: -400, to: 400)
        
        for i in 0..<dancers.count {
            points[i].x += dx
            points[i].y += dy
        }
    }

    // Get random values.
    let duration = randomDouble(from: 0.25, to: 2.0)
    let scale = randomDouble(from: 1.0, to: 3.0)
    let rotation = randomDouble(from: -360, to: 360)
    
    // Animate dancers to their new positions.
    for i in 0..<dancers.count {
        dancers[i].move(to: points[i], duration: duration)
        dancers[i].scale = scale
        dancers[i].rotation = rotation
    }
    
    // Play note on instrument.
    playInstrument(instrument, note: note, volume: 50)
}

// Create and connect the Dance button.
let danceButton = Button(name: "Dance")
danceButton.onTap = dance
scene.button = danceButton
//#-end-editable-code

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

