//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Experiment:** Decorate the cosmic bus.
 
 To help make your text graphics stand out, you can give them a cool text style (or [font](glossary://font)) and color. This is the art of [typography](glossary://typography).

 Read the code below. What do you think it does? Run it and see if you’re right.
 
 A graphic has several properties that you can use to set its text style:
 
 - **fontName:** A font from the `FontName` [enumeration](glossary://enumeration); for example, `georgia` or `markerfelt`.
 - **fontSize:** The size of the text; for example, 18.
 - **textColor:** The color of the text.
 
 Try decorating the cosmic bus by placing text graphics over it in as many different styles as you like. String constants `quote1` to `quote8` will help you get started.
 
 1. Experiment with different fonts, sizes, and text colors.
 2. Edit the quotes, or make up your own.
 3. Try using the `rotation` property of `Graphic`.
 
 When you’re finished decorating the bus, move on to the [**next page**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, text:), text:, (text:), text:, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, fontName, fontSize, rotation, textColor, avenirNext, bradleyHand, chalkduster, georgia, helveticaNeue, markerfelt, menlo, zapfino, orbit(x:y:period:), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image


playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceThePurpleFrontier@2x.png")
//#-end-hidden-code
//#-editable-code
let quote1 = "if coder { code() }"
let quote2 = "Relativity Rules"
let quote3 = "Me? Sarcastic? Never."
let quote4 = "/* No Comment */"
let quote5 = "✸ Quasars Quake ✸"
let quote6 = "Bits unite. Bytes rule!"
let quote7 = "Cosmic Bus: Light years ahead!"
let quote8 = "• Code = Poetry •"
//#-end-editable-code

//#-editable-code(id1)
let graphic1 = Graphic(text: quote2)
graphic1.fontName = .chalkduster
graphic1.fontSize = 60
graphic1.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
graphic1.rotation = 10
scene.place(graphic1, at: Point(x: -150, y: 50))

// Put more quotes on the bus.
let graphic2 = Graphic(text: quote5)

//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code(id1)
//    let graphic1 = Graphic(text: quote1)
//    graphic1.fontName = .chalkduster
//    graphic1.fontSize = 60
//    graphic1.textColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//    graphic1.rotation = 10
//    scene.place(graphic1, at: Point(x: -200, y: 150))
//
//    // Add some more quotes.
//    let graphic2 = Graphic(text: quote2)
//    graphic2.fontName = .menlo
//    graphic2.fontSize = 30
//    graphic2.textColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
//    scene.place(graphic2, at: Point(x: 0, y: -100))
//
//    let graphic3 = Graphic(text: quote3)
//    graphic3.fontName = .bradleyHand
//    graphic3.fontSize = 30
//    graphic3.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
//    scene.place(graphic3, at: Point(x: 250, y: 250))
//    //#-end-editable-code

//#-end-hidden-code
