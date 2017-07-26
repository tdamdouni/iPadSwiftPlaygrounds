//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Chop up a string into words.
 
 Now that you’ve learned to put strings together, you get to tear them apart!
 
 Parts of a string, such as words or characters, are called [components](glossary://string%20component). When you chop up a string, you end up with a collection of components in an array.
 
 You can split a string into its word components using a separator string such as a space, or `" "`.
 
 * callout(Splitting a string into words):
    `let caption = "six slippery snails"`\
    `let words = caption.components(separatedBy: " ")`
 
 Because `words` is now an array of strings—one for each word—you can write them to the scene.
 
 * callout(Writing out the words in a string):
    `for word in words {`\
    `   scene.write(word)`\
    `}`
 
 In the code, `secret` is a string with a lot of words. See if you can write code to:
 
 1. Split `secret` into an array of words.
 2. Loop through the array of words and write each word to the scene.
 3. **Challenge**: Try writing `word.reversed()` or `word.shuffled()` to the scene.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomInt(from:to:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), count, numberOfObjectsPlaced, previousPlaceDistance, position, speed, fadeOut(after:), spinAndPop(after:), swirlAway(after:), move(to:duration:), circlePoints(radius:count:), spiralPoints(spacing:count:), abs(_:), write(_:), speak, components(separatedBy:), orbit(x:y:period:), reversed(), shuffled(), rotation)
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let secret = "find me in the restaurant at the end of the universe"
//#-editable-code Tap to add code
//#-end-editable-code
//#-hidden-code

assessmentController?.customInfo["correctWords"] = secret.components(separatedBy: " ")

var tools: [Tool] = []
scene.tools = tools

playgroundEpilogue()

//** Completed Code **

//    //#-editable-code Tap to add code
//    let words = secret.components(separatedBy: " ")
//    for word in words {
//        scene.write(word.reversed())
//    }
//    //#-end-editable-code

//#-end-hidden-code
