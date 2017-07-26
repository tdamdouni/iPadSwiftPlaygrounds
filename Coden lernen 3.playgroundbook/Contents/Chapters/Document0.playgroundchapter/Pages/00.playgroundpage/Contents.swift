//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Have fun:** Discover some of the exciting things you’ll do with code in **Learn to Code 3**!
 
 To get started, tap **Run My Code**. Drag your finger around the universe—the box inside the dotted lines, and watch how emoji appear. Tap **Clear** to start again.
 
 Now tap **Draw** to get a list of buttons. You’ll soon be writing code to make these buttons do fun things, but for now, just try them out. Choose a button by tapping it:
 
 * 🖌 **Draw**: Place emoji on the universe wherever you drag your finger or tap.
 
 * ❄️ **Kaleido**: Create patterns as you drag your finger.

 * 🎶 **Play**: Touch emoji to turn the universe into a musical instrument.
 
 * 🗣 **Hello**: Get emoji to make noises—or even talk back—when you touch them!
 
 * ⚡️ **Goodbye**: Tumble emoji out of the universe by touching them.
 
 Or reach over and tap the **Astrodance** button to get those emoji moving! 💃🏻🕺🏻
 
 Before you [move on](@next), try a tiny bit of coding. Choose different emoji, or a different number of dancers, by editing the code. After you make your changes, tap **Run My Code**. Then tap **Astrodance** to make them dance again.
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

/// Speaks the provided text.
func speak(_ text: String) {
    
    stopSpeaking()
    
    var voice = SpeechVoice(accent: .british)
    voice.pitch = 40
    voice.speed = 20
    
    speak(text, voice: voice)
}

var dancers: [Graphic] = []

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")

var lastPlacePosition = Point(x: 0, y: 0)
let center = Point(x: 0, y: 0)
//#-end-hidden-code
// Try using different emoji—for example, colorful flags.
let emoji = /*#-editable-code*/"🌕🎾⚾️🌍⚽️"/*#-end-editable-code*/
// Try changing the number of dancers.
let numberOfDancers = /*#-editable-code*/200/*#-end-editable-code*/
/*:#localized(key: "SecondProseBlock")
 Wondering what the code for this page is like? Go ahead and browse the code in the functions below, but *don’t worry if it looks a bit scary.* You’ll get familiar with code just like this, and before you know it, you’ll be writing your own!

 When you’re ready to get started, move on to the [**next page**](@next).
 */
//#-editable-code
// Draw: As you drag your finger around, this function is called each time your finger moves, adding emoji to the scene.
func addEmoji(touch: Touch) {
    if touch.previousPlaceDistance < 100 { return }
    let characters = emoji.componentsByCharacter()
    let graphic = Graphic(text: characters.randomItem)
    scene.place(graphic, at: touch.position)
}

// Kaleido: As you drag your finger around, this function is called each time your finger moves, adding emoji to the scene in symmetrical patterns.
func addKaleidoImage(touch: Touch) {
    let characters = emoji.componentsByCharacter()
    // Space out graphics.
    let placeDistance = touch.position.distance(from: lastPlacePosition)
    if placeDistance < 80 { return }
    lastPlacePosition = touch.position
    // Create graphics for each quadrant and add to an array.
    var graphics: [Graphic] = []
    for i in 0 ..< 4 {
        let graphic = Graphic(text: characters.randomItem)
        graphics.append(graphic)
    }
    // Get absolute x, y values.
    let x = abs(touch.position.x)
    let y = abs(touch.position.y)
    // Position a graphic in each quadrant.
    let position1 = Point(x: x, y: y)
    scene.place(graphics[0], at: position1)
    let position2 = Point(x: x, y: -y)
    scene.place(graphics[1], at: position2)
    let position3 = Point(x: -x, y: -y)
    scene.place(graphics[2], at: position3)
    let position4 = Point(x: -x, y: y)
    scene.place(graphics[3], at: position4)
}

// Play: When you tap an emoji, this function is called to play a note on the cosmic drums.
func playNote(graphic: Graphic) {
    // Number of notes.
    let noteSteps = 16
    // Distance from the center 0.0 - 1.0.
    let center = Point(x: 0, y: 0)
    let distance = graphic.distance(from: center) / 707.0
    // Translate distance into closest note Int value.
    let note = (1.0 - distance) * noteSteps
    // Translate alpha into volume value.
    let volume = graphic.alpha * 100.0
    // Play the note.
    playInstrument(.cosmicDrums, note: note, volume: volume)
}

// Hello: When you tap an emoji, this function is called to speak or make a sound.
func sayHello(graphic: Graphic) {
    // Make the emoji grow bigger.
    graphic.scale(to: 3.0, duration: 0.0)
    // Choose what to do based on emoji.
    switch graphic.text {
    case "🌕":
        speak("Planet smelly cheese.")
    case "🎾":
        playSound(.tennis)
    case "⚾️":
        playSound(.wap)
    case "🌍":
        speak("Blue marble.")
    case "⚽️":
        speak("Planet soccer ball.")
    default:
        speak(graphic.text)
    }
    // Make the emoji shrink back down.
    graphic.scale(to: 2.0, duration: 2.0)
}

// Goodbye: When you tap an emoji, this function is called to make a graphic disappear.
func fadeAway(graphic: Graphic) {
    playSound(.tumble)
    let sinkHole = Point(x: graphic.position.x, y: -800)
    graphic.move(to: sinkHole, duration: 2.5)
    graphic.fadeOut(after: 2.0)
    graphic.remove()
}

// Astrodance: When you tap the button, this function rearranges emoji into lovely patterns.
func dance() {
    // Place the dancers on the scene, if necessary.
    if scene.graphics.count != numberOfDancers {
        scene.clear()
        dancers = []
        var index = 0
        let emojiCharacters = emoji.componentsByCharacter()
        for i in 0..<numberOfDancers {
            let dancer = Graphic(text: emojiCharacters[index])
            scene.place(dancer, at: center)
            dancers.append(dancer)
            index += 1
            if index == emojiCharacters.count {
                index = 0
            }
        }
    }
    // Get a new pattern.
    let pattern = randomInt(from: 1, to: 3)
    // Rearrange the dancers.
    rearrange(dancers: dancers, pattern: pattern, instrument: .cosmicDrums)
}

// Rearrange the dancers to a pattern accompanied by an instrument.
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
    // Pattern 3: Points in a spiral.
    if pattern == 2 {
        let spacing = randomDouble(from: 50, to: 200)
        points = scene.spiralPoints(spacing: spacing, count: dancers.count)
        note = 10
    }
    // Pattern 4: Hypotrochoid.
    if pattern == 3 {
        let r1 = randomDouble(from: 200.0, to: 400.0)
        let r2 = randomDouble(from: 50.0, to: 100.0)
        let d = randomDouble(from: 0.5, to: 2.0)
        points = scene.hypotrochoidPoints(r1: r1, r2: r2, d: d, count: dancers.count)
        note = 12
    }

    // Shift all points by a random x, y distance.
    let dx = randomDouble(from: -250, to: 250)
    let dy = randomDouble(from: -250, to: 250)
    
    for i in 0..<dancers.count {
        points[i].x += dx
        points[i].y += dy
    }

    // Get random values.
    let duration = randomDouble(from: 0.25, to: 2.0)
    let rotation = randomDouble(from: -360, to: 360)
    
    // Animate dancers to their new positions.
    for i in 0..<dancers.count {
        dancers[i].move(to: points[i], duration: duration)
        // Scale based on the distance from the center.
        let distance = points[i].distance(from: center) / 707.0
        dancers[i].scale = 0.25 + (distance * 2.0)
        dancers[i].rotation = rotation
    }
    
    // Play a note on the instrument.
    playInstrument(instrument, note: note, volume: 50)
}

// Create and add the Draw button.
let emojiTool = Tool(name: "Draw", emojiIcon: "🖌")
emojiTool.onFingerMoved = addEmoji(touch:)
scene.tools.append(emojiTool)

// Create and add the Kaleido button.
let kaleidoTool = Tool(name: "Kaleido", emojiIcon: "❄️")
kaleidoTool.onFingerMoved = addKaleidoImage(touch:)
scene.tools.append(kaleidoTool)

// Create and add the Play button.
let playTool = Tool(name: "Play", emojiIcon: "🎶")
playTool.onGraphicTouched = playNote(graphic:)
scene.tools.append(playTool)

// Create and add the Hello button.
let helloTool = Tool(name: "Hello", emojiIcon: "🗣")
helloTool.onGraphicTouched = sayHello(graphic:)
scene.tools.append(helloTool)

// Create and add the Goodbye button.
let goodbyeTool = Tool(name: "Goodbye", emojiIcon: "⚡️")
goodbyeTool.onGraphicTouched = fadeAway(graphic:)
scene.tools.append(goodbyeTool)

// Create and connect the Dance button.
let danceButton = Button(name: "Astrodance")
danceButton.onTap = dance
scene.button = danceButton
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//#-end-hidden-code
