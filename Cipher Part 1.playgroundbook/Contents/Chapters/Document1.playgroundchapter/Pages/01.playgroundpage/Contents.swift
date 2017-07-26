//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 The library is warm and quiet, a welcome relief from the howling snowstorm outside. You take off your mittens, head over to one of the reference computers, and search for [cryptography](glossary://cryptography). Your teacher mentioned it in class this morning, and you want to know more.
 
 You write down a few book reference numbers and wind your way through the book stacks. You find the first book on your list—an old, heavy-looking volume. In large, gold letters on the cover is the title: *The History of Cryptography*.
 
 You take a peek inside . . .
*/
//#-hidden-code
import PlaygroundSupport

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func openBook() {
    proxy?.send(.string(Constants.playgroundMessageKeyOpenBook))
}
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, openBook())
// Open the book
//#-editable-code

//#-end-editable-code
//#-hidden-code
page.assessmentStatus = assessmentPoint()
//#-end-hidden-code
