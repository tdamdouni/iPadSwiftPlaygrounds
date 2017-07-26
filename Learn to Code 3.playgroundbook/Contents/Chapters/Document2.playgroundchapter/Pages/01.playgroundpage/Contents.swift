//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Use the Image tool to place images on the scene.
 
 Run the code, and you’ll notice an **Image** button in the top-left corner. This is your first tool, and it’s already selected. Drag your finger around the scene and paint the universe with stars. ⭐️⭐️⭐️
 
 As you slide your finger around the scene, a message is sent with your new finger position every time your finger moves—even the tiniest amount. These messages are touch [events](glossary://event), and there’s quite a stream of them, especially if you’re swiping fast!
 
 Whenever the **Image** tool is selected, `addImage()` is called for each touch event. Any code you put in `addImage()` is called every time your finger moves. The `touch` parameter contains your finger position; if you create a new star graphic and place it on the scene at `touch.position`, new stars will appear under your finger as it moves around the scene.
 
 1. Drag your finger around the scene and create some interesting patterns. Use the **Clear** button to clear the scene and start over.
 2. Edit the code to create the graphic from a different image, such as a frog 🐸 or a purple monster 👾.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, color, array, image)
//#-code-completion(module, show, Swift)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, true, false, &&, ||, !, *, /, scene, ., backgroundColor, backgroundImage, Graphic, image:), image:, (image:), image:, (, ), Point, x:y:), (x:y:), x:y:, place(_:at:), randomDouble(from:to:), x, y, scale, insert(_:at:), remove(at:), append(_:), removeAll(), removeFirst(), removeLast(), orbit(x:y:period:))
//#-code-completion(identifier, hide, Touch, Color, Scene, _ImageLiteralType, isDifferentImage, starHash, starImage)


import UIKit

public typealias _ImageLiteralType = Image

let starImage = #imageLiteral(resourceName: "Star@2x.png")
let starHash = starImage.hashValue
playgroundPrologue()

//#-end-hidden-code
scene.clear()
scene.backgroundImage = /*#-editable-code*/#imageLiteral(resourceName: "SpaceTheGreenFrontier@2x.png")/*#-end-editable-code*/

func addImage(touch: Touch) {
    let graphic = Graphic(image: /*#-editable-code*/#imageLiteral(resourceName: "Star@2x.png")/*#-end-editable-code*/)
    //#-hidden-code
    var isDifferentImage = false
    if let userImage = graphic.image {
        if starHash != userImage.hashValue {
            isDifferentImage = true
        }
    }
    assessmentController?.customInfo["isDifferentImage"] = isDifferentImage
    //#-end-hidden-code
    scene.place(graphic, at: touch.position)
}
//#-hidden-code
let addImageTool = Tool(name: "Image", emojiIcon: "🖼")
addImageTool.onFingerMoved = addImage
scene.tools = [addImageTool]  // Just the image tool

playgroundEpilogue()


//#-end-hidden-code
