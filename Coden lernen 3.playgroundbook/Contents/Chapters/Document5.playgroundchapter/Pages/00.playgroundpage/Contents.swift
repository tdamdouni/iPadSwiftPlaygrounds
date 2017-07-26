//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Create:** Show off your artistic—and coding—skills!
 
 Run the code, and then tap the **Draw** button to reveal a bunch of tools. The top four are for drawing as you tap your finger or drag it around the scene. You can use the rest to change what you’ve already drawn. Try them out!
 
 When you tap **Fill**, the entire scene is filled with emoji. Can you spot the odd one out?!
 
 Not only can you draw with these tools, but you can also change the way they work by editing the code. You’ll find a function for each tool in the code. Here are some ideas:
 
 * Experiment with different sets of emoji in the drawing and fill tools.
 
 * In `driftDraw()` try changing `maxScale`.
 
 * In `swirlDraw()` try changing `radius`.
 
 * In `fill()`, try using square emoji 🌃 and a `scale` of `2.0` so the emoji completely cover the scene. Add code before you call `fillScene()` to place a graphic in a random position. Then use the **Erase** tool to see how many taps it takes you to find it!
 
 * Invent your own tools. 🛠
 
 * Share your creation with your friends.
 
 When you’re finished, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, color, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, alpha, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, numberOfCharacters, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, componentsByCharacter(), randomItem, orbit(x:y:period:), tools, Tool, name:emojiIcon:), (name:emojiIcon:), name:emojiIcon:, onFingerMoved, onGraphicTouched, moveAndZap(to:), playSound(_:), playSound(_:volume:), playInstrument(_:note:), playInstrument(_:note:volume:), text, electricGuitar, bassGuitar, cosmicDrums, piano, bark, bluDance, bluLookAround, bluHeadScratch, bluOops, data, electricity, hat, knock, phone, pop, snare, tennis, tick, walrus, warp, rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

// Returns a value that cycles between 0.0 and 1.0 as n increases.
func cycleValue(n: Int) -> Double {
    let thetaDegrees = 5.0
    let theta = thetaDegrees * Double.pi / 180.0
    let angle = n * theta
    return sin(angle).double
}

// Returns an (x, y) offset that cycles between 0.0 and 1.0 as n increases.
func cycleOffset(n: Int) -> Point {
    let thetaDegrees = 30.0
    let theta = thetaDegrees * Double.pi / 180.0
    let angle = n * theta
    var offset = Point(x: 0, y: 0)
    offset.x = cos(angle).double
    offset.y = sin(angle).double
    return offset
}
//#-end-hidden-code
//#-editable-code
scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")
// The last position your finger touched.
var lastTouchPosition = Point(x: 0, y: 0)

// Draws emoji as you move your finger.
var drawIndex = 0
func draw(touch: Touch) {
    // Emoji to draw with.
    let emoji = "🌏🌕🎾"
    // Space out the graphics.
    let distance = touch.position.distance(from: lastTouchPosition)
    if distance < 20 { return }
    lastTouchPosition = touch.position
    // Use the next emoji to place a graphic at the touch position.
    let emojiCharacters = emoji.componentsByCharacter()
    let graphic = Graphic(text: emojiCharacters[drawIndex])
    scene.place(graphic, at: touch.position)
    // Scale the graphic.
    graphic.scale = 1.5
    // Point drawIndex to the next emoji character.
    drawIndex += 1
    // Reset drawIndex if it’s reached the end of the array.
    if drawIndex >= emojiCharacters.count {
        drawIndex = 0
    }
}

// Draws drifts of emoji as you move your finger.
var driftIndex = 0
var driftCount = 0
func driftDraw(touch: Touch) {
    // Emoji to draw with.
    let emoji = "☣️㊙️"
    // Space out the graphics.
    let distance = touch.position.distance(from: lastTouchPosition)
    if distance < 20 { return }
    lastTouchPosition = touch.position
    // Use the next emoji to place a graphic at the touch position.
    let emojiCharacters = emoji.componentsByCharacter()
    let graphic = Graphic(text: emojiCharacters[driftIndex])
    scene.place(graphic, at: touch.position)
    // Scale cycles between 0.0 and maxScale, depending on the number of graphics placed.
    let maxScale = 2.5
    graphic.scale = maxScale * cycleValue(n: driftCount)
    driftCount += 1
    // Point driftIndex to the next emoji character.
    driftIndex += 1
    // Reset driftIndex if it’s reached the end of the array.
    if driftIndex >= emojiCharacters.count {
        driftIndex = 0
    }
}

// Draws swirling emoji as you move your finger.
var swirlIndex = 0
var swirlCount = 0
func swirlDraw(touch: Touch) {
    // Emoji to draw with.
    let emoji = "🌼🌸🌺"
    // Space out the graphics.
    let distance = touch.position.distance(from: lastTouchPosition)
    if distance < 5 { return }
    lastTouchPosition = touch.position
    // Use the next emoji to place a graphic.
    let emojiCharacters = emoji.componentsByCharacter()
    let graphic = Graphic(text: emojiCharacters[swirlIndex])
    // Position cycles around the touch position, depending on the number of graphics placed.
    var position = touch.position
    let offset = cycleOffset(n: swirlCount)
    swirlCount += 1
    let radius = 60.0
    position.x += offset.x * radius
    position.y += offset.y * radius
    // Place a graphic at the calculated position.
    scene.place(graphic, at: position)
    // Scale the graphic.
    graphic.scale = 0.75
    // Point swirlIndex to the next emoji character.
    swirlIndex += 1
    // Reset swirlIndex if it’s reached the end of the array.
    if swirlIndex >= emojiCharacters.count {
        swirlIndex = 0
    }
}

// Draws fried eggs as you move your finger.
func friedEgg(touch: Touch) {
    // Space out the eggs.
    let distance = touch.position.distance(from: lastTouchPosition)
    if distance < 40 { return }
    lastTouchPosition = touch.position
    // Place the egg white.
    let white = Graphic(text: "⚪️")
    scene.place(white, at: touch.position)
    // Scale the egg white.
    white.scale = 2.0
    // Fade the egg white a little.
    white.alpha = 0.8
    // Place the egg yolk.
    let yolk = Graphic(text: "😶")
    scene.place(yolk, at: touch.position)
    // Rotate the egg yolk by a random angle.
    yolk.rotation = randomDouble(from: -180.0, to: 180.0)
    // Scale the egg yolk.
    yolk.scale = 1.0
}

// Fades a graphic when you touch it.
func fade(graphic: Graphic) {
    graphic.alpha -= 0.1
}

// Rotates a graphic when you touch it.
func rotate(graphic: Graphic) {
    graphic.rotation += 45.0
}

// Scales up a graphic when you touch it.
func scaleUp(graphic: Graphic) {
    graphic.scale *= 1.5
}

// Scales down a graphic when you touch it.
func scaleDown(graphic: Graphic) {
    graphic.scale *= 1.0 / 1.5
}

// Fills the entire scene with a grid of emoji.
func fillScene(emoji: String, scale: Double) {
    let emojiCharacters = emoji.componentsByCharacter()
    var index = 0
    // Get count points in a grid of size * size.
    let points = scene.gridPoints(size: 925, count: 256)
    // Create a graphic for each point and place it.
    for point in points {
        let graphic = Graphic(text: emojiCharacters[index])
        scene.place(graphic, at: point)
        // Scale the graphic.
        graphic.scale = scale
        // Point index to the next emoji character.
        index += 1
        // Reset index if it’s reached the end of the array.
        if index == emojiCharacters.count {
            index = 0
        }
    }
}

// This function is called when the Fill button is tapped.
func fill() {
    scene.clear()
    // Fill the scene with emoji.
    fillScene(emoji: "🌲🌳🌴", scale: 1.0)
    // Change one of the graphics to a different emoji.
    let n = randomInt(from: 0, to: scene.graphics.count - 1)
    scene.graphics[n].text = "🍏"
}

// Create and add the Draw tool.
let drawTool = Tool(name: "Draw", emojiIcon: "🌍")
drawTool.onFingerMoved = draw(touch:)
scene.tools.append(drawTool)

// Create and add the Drift tool.
let driftTool = Tool(name: "Drift", emojiIcon: "㊙️")
driftTool.onFingerMoved = driftDraw(touch:)
scene.tools.append(driftTool)

// Create and add the Swirl tool.
let swirlTool = Tool(name: "Swirl", emojiIcon: "🌼")
swirlTool.onFingerMoved = swirlDraw(touch:)
scene.tools.append(swirlTool)

// Create and add the Fried Egg tool.
let friedEggTool = Tool(name: "Fried Egg", emojiIcon: "🍳")
friedEggTool.onFingerMoved = friedEgg(touch:)
scene.tools.append(friedEggTool)

// Create and add the Fade tool.
let fadeDownTool = Tool(name: "Fade", emojiIcon: "")
fadeDownTool.onGraphicTouched = fade(graphic:)
scene.tools.append(fadeDownTool)

// Create and add the Bigger tool.
let scaleUpTool = Tool(name: "Bigger", emojiIcon: "➕")
scaleUpTool.onGraphicTouched = scaleUp(graphic:)
scene.tools.append(scaleUpTool)

// Create and add the Smaller tool.
let scaleDownTool = Tool(name: "Smaller", emojiIcon: "➖")
scaleDownTool.onGraphicTouched = scaleDown(graphic:)
scene.tools.append(scaleDownTool)

// Create and add the Fill button.
let fillButton = Button(name: "Fill")
fillButton.onTap = fill
scene.button = fillButton
//#-end-editable-code

//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code
