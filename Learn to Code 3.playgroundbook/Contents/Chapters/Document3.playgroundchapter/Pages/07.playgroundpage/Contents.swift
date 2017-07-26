//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Experiment:** Decorate the cosmic bus.
 
 To help make your text more legible and appealing, you can pick a suitable text style (or [font](glossary://font)) and color. This is the wonderful art known as [typography](glossary://typography).
 
 Several properties are available to set the text style of a graphic:
 
 - **fontName:** A font from the `FontName` [enumeration](glossary://enumeration); for example, `georgia`.
 - **fontSize:** The size of the text as an integer; for example, 18.
 - **textColor:** The color of the text.
 
 Try decorating the cosmic bus with text in as many different styles as you like. The `quotes` array will help you get started, but you can create your own, too!
 
 1. Read the code below. What do you think it does? Run it and see if you’re right.
 2. Experiment with different fonts, sizes, and text colors.
 3. Add other quotes from `quotes`, or make up your own.
 4. Try using the `rotation` property of `Graphic`.
 
 When you’re finished decorating the bus, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), fontName, fontSize, rotation, textColor, avenirNext, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image


playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")/*#-end-editable-code*/

let quotes = [
//#-editable-code
"if coder { code() }",
"Relativity Rules",
"Me? Sarcastic? Never.",
"/* No Comment */",
"✸ Quasars Quake ✸",
"Bits unite. Bytes rule!",
"Cosmic Bus: Light years ahead!",
"• Code = Poetry •"
//#-end-editable-code
]
//#-editable-code(id1)
let quote1 = Graphic(text: quotes[1])
quote1.fontName = .chalkduster
quote1.fontSize = 60
quote1.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
quote1.rotation = 10
scene.place(quote1, at: Point(x: -150, y: 50))

//➤ Put more quotes on the bus.

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    let quote1 = Graphic(text: quotes[1])
//    quote1.fontName = .chalkduster
//    quote1.fontSize = 60
//    quote1.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//    quote1.rotation = 10
//    scene.place(quote1, at: Point(x: -200, y: 150))
//
//    //➤ Add some more quotes
//    let quote2 = Graphic(text: quotes[2])
//    quote2.fontName = .menlo
//    quote2.fontSize = 30
//    quote2.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
//    scene.place(quote2, at: Point(x: 0, y: -100))
//
//    let quote3 = Graphic(text: quotes[3])
//    quote3.fontName = .bradleyHand
//    quote3.fontSize = 30
//    quote3.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//    scene.place(quote3, at: Point(x: 250, y: 250))
//    //#-end-editable-code

//#-end-hidden-code
