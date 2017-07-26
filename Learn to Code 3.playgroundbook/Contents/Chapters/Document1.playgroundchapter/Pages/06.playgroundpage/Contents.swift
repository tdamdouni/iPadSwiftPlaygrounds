//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Put planets into elliptical orbits.
 
 Planets don’t just sit around in space. It’s time to get them flying in orbit!
 
 * callout(Putting a graphic into orbit around the origin):
    `graphic.orbit(x: 200, y: 400, period: 5.0)`
 
 * `x` and `y` tell how far the graphic orbits from the center of the scene. If they’re equal, the orbit is circular; if not, it’s elliptical.
 
 * `period` tells how long the orbit takes, in seconds. It’s a number of type [Double](glossary://Double), which means that unlike [Int](glossary://Int), it can have a decimal number value, like 4.123.
 
 Place each planet graphic into its own unique orbit, and see what interesting patterns you can create.
 
 1. In the `for` loop, after you place each graphic, call `graphic.orbit()` using random values for the orbit parameters `x`, `y`, and `period`.
 
 2. Experiment with different ranges for the orbit parameters by changing the parameters of `randomDouble(from:to:)`.
 
 3. Try using the `scale` property to make the graphics different sizes (or even random sizes).
 
 When you’re finished, move on to the [**next chapter**](@next).
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, +=, -=, !=, +, -, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheBlueFrontier@2x.png")/*#-end-editable-code*/

let blu = Graphic(image: #imageLiteral(resourceName: "Blu1@2x.png"))
let theOrigin = Point(x: 0, y: 0)
scene.place(blu, at: theOrigin)

var position = Point(x: 0, y: 200)
//#-editable-code
var images = [#imageLiteral(resourceName: "soccerball@2x.png"), #imageLiteral(resourceName: "rugbyball@2x.png"), #imageLiteral(resourceName: "tennisball@2x.png"), #imageLiteral(resourceName: "baseball@2x.png"), #imageLiteral(resourceName: "basketball@2x.png")]

for image in images {
    var graphic = Graphic(image: image)
    graphic.scale = randomDouble(from: 0.5, to: 1.5)
    scene.place(graphic, at: theOrigin)
    
    // Get random values for orbit parameters.
    let x = randomDouble(from: 50, to: 400)
    let y = randomDouble(from: 50, to: 400)
    let period = randomDouble(from: 1.0, to: 10.0)
    
    //➤ Put graphic into orbit.
    
}
//#-end-editable-code
//#-hidden-code

playgroundEpilogue()

scene.tools = [Tool]()  // Remove default tools

//** Completed Code **

//    //#-editable-code
//    scene.place(star, at: position)
//
//    var images = [#imageLiteral(resourceName: "soccerball@2x.png"), #imageLiteral(resourceName: "rugbyball@2x.png"), #imageLiteral(resourceName: "tennisball@2x.png"), #imageLiteral(resourceName: "baseball@2x.png"), #imageLiteral(resourceName: "basketball@2x.png")]
//
//    for image in images {
//        var graphic = Graphic(image: image)
//        graphic.scale = randomDouble(from: 0.5, to: 1.5)
//        scene.place(graphic, at: theOrigin)
//        
//        // Get random values for orbit parameters.
//        let x = randomDouble(from: 50, to: 400)
//        let y = randomDouble(from: 50, to: 400)
//        let period = randomDouble(from: 1.0, to: 10.0)
//
//        //➤ Put graphic into orbit.
//        graphic.orbit(x: x, y: y, period: period)
//    }
//    //#-end-editable-code


//#-end-hidden-code
