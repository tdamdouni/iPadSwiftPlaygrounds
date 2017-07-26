//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Create:** Build your own digital lock!
 
 
 The only way your friends can get to your top-secret photo is by tapping the emoji keys *in the right order*. If they get it wrong, everything is destroyed! 💥
 
 When you tap **Lock**, the `lock()` function is called. This function scatters the emoji keys around the scene and sets `matchIndex` to `0`.
 
 When you tap a key, the `touchedKey(graphic:)` event handler is called. If `graphic` matches the key at `matchIndex`, `matchIndex` is [incremented](glossary://increment). When the last required key is tapped, the event handler calls `unlockSecret()`.
 
 * callout(Check if unlocked):
 `if keys[matchIndex] == keys.last {`\
 `   unlockSecret()`\
 `}`
 
 **Experiment:**
 
 * Change `hiddenImage` to a photo of your own.
 * Try different sets of emoji for the keys.
 * Use your own background image.
 * Make the sequence more difficult; for example, you have to tap the first key once, the second twice, and so on.
 * Clutter the scene with other emoji that do nothing when you tap them.
 * Instead of displaying an image in `unlockSecret()`, reveal or speak a secret message.
 
 When you’re done, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeIn(after:), fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, numberOfCharacters, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()
//#-end-hidden-code
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
// Emoji to be tapped in the correct order.
let emoji = "🥝🍭🍋🍔🍿"
// Image to be unlocked: Choose your own.
let hiddenImage = #imageLiteral(resourceName: "CosmicBus.png")

// Array of characters in emoji.
let keys = emoji.componentsByCharacter()
// Index to next key to match.
var matchIndex = 0

// Set up final positions for the keys.
var finalPositions: [Point] = []
var finalPosition = Point(x: -400, y: 400)
for key in keys {
    finalPosition.x += 125
    finalPositions.append(finalPosition)
}

// Prompt to begin.
let prompt = Graphic(text: "Tap '🔒 Lock' to begin.")
prompt.fontName = .avenirNext
prompt.fontSize = 50
prompt.textColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
scene.place(prompt, at: Point(x: 0, y: 0))

// This function is called when you tap the Lock button.
func lock() {
    scene.clear()
    // Reset to point to the first key.
    matchIndex = 0
    // Add keys in random positions.
    var position = Point(x: 999, y: 999)
    for key in keys {
        let graphic = Graphic(text: key)
        graphic.scale = 2.0
        graphic.rotation = randomDouble(from: -360, to: 360)
        // Get a new random position distant from the other keys.
        var distanceFromNearest = 0.0
        let minimumDistance = 150
        // Keep getting a new position until it’s at least minimumDistance from any other graphic.
        while distanceFromNearest < minimumDistance {
            position.x = randomDouble(from: -450, to: 450)
            position.y = randomDouble(from: -450, to: 350)
            distanceFromNearest = 999
            // Get the distance from the nearest graphic.
            for graphic in scene.graphics {
                let distance = position.distance(from: graphic.position)
                if distance < distanceFromNearest {
                    distanceFromNearest = distance
                }
            }
        }
        // Place the key at the new random position.
        scene.place(graphic, at: position)
    }
}

// This function is called each time you touch a key (graphic).
func touchedKey(graphic: Graphic) {
    if graphic.text == keys[matchIndex] {
        // Match: Move the key to its final position.
        graphic.scale = 2.5
        graphic.rotation = 0
        graphic.move(to: finalPositions[matchIndex], duration: 0.25)
        playSound(.pop)
        // Is this the last match?
        if keys[matchIndex] == keys.last {
            // The last key matched so unlock the secret.
            unlockSecret()
        } else {
            // Point to the next key.
            matchIndex += 1
        }
    } else {
        // No match: Fade all the keys.
        playSound(.wap)
        for graphic in scene.graphics {
            graphic.fadeOut(after: 0.25)
        }
    }
}

// This function is called when all the keys are touched in the right order.
func unlockSecret() {
    // Fade out the keys.
    for graphic in scene.graphics {
        graphic.fadeOut(after: 0.25)
    }
    
    // Play a sound effect.
    playSound(.electricity)
    
    // Show the hidden image.
    let graphic = Graphic(image: hiddenImage)
    scene.place(graphic, at: Point(x: 0, y: 0))
    graphic.alpha = 0.0
    graphic.scale = 2.0
    graphic.fadeIn(after: 1.0)
}

// Create and add the Unlock tool.
let unlockTool = Tool(name: "Unlock", emojiIcon: "🔑")
unlockTool.onGraphicTouched = touchedKey(graphic:)
scene.tools.append(unlockTool)

// Create and add the Lock button.
let shuffleButton = Button(name: "🔒 Lock")
shuffleButton.onTap = lock
scene.button = shuffleButton
//#-end-editable-code

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code
