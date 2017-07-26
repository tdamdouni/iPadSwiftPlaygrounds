//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Space out the stars on the scene.
 
 Choose the **Image** tool and move your finger very slowly across the scene. You might notice a bit of a problem: instead of individual stars, you get a jagged yellow line.
 
 Code sometimes has side effects that you don’t expect. In this case, when you move your finger very slowly, each touch event is very close to the previous one, and you end up with loads of stars packed together.
 
To add space between your stars, you can use conditional code with the `previousPlaceDistance` property of `touch`. Its value is the distance your finger has moved since the last graphic was placed on the scene.
 
 * callout(Return if touch hasn’t moved far enough):
    `if touch.previousPlaceDistance < 80 {`\
    `   return`\
    `}`
 
When `return` is called, the function ends immediately and *returns* to the code that called it.
 
Try changing the distance being compared to `touch.previousPlaceDistance`, and see what effect it has on how the stars are placed.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType)

import UIKit

public typealias _ImageLiteralType = Image

playgroundPrologue()

scene.clear()
scene.backgroundImage = #imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")
//#-end-hidden-code
func addImage(touch: Touch) {
    if touch.previousPlaceDistance < /*#-editable-code*/10/*#-end-editable-code*/ {
        return
    }
    
    let graphic = Graphic(image: /*#-editable-code*/#imageLiteral(resourceName: "Star@2x.png")/*#-end-editable-code*/)
    scene.place(graphic, at: touch.position)
}
//#-hidden-code
let addImageTool = Tool(name: "Image", emojiIcon: "🖼")
addImageTool.onFingerMoved = addImage
scene.tools = [addImageTool] // Just the image tool

playgroundEpilogue()

//#-end-hidden-code
