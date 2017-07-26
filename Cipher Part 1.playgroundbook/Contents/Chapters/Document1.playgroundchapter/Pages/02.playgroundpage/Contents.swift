//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

class NotePageListener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                             received message: PlaygroundValue) {
        if case let .string(text) = message {
            if text == Constants.playgroundMessageKeyOpenNote {
                page.assessmentStatus = assessmentPoint()
            }
        }
    }
    
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }
}

let listener = NotePageListener()
proxy?.delegate = listener
//#-code-completion(everything, hide)
//#-end-hidden-code
/*:
 You sit on the floor of the library, immersed in your reading. Other people walk past you, but no one disturbs you. You get through the [Transposition Ciphers](glossary://transposition%20cipher) and [Steganography](glossary://steganography) chapters and think about putting the book back and trying the next one on your list. But something catches your eye.
 
 Turning to the [Substitution Ciphers](glossary://substitution%20cipher) chapter, you find a small, folded-up piece of notepaper between the pages. Someone must have used it as a bookmark and forgotten to take it out.
 
 After reading about substitution ciphers, your curiosity gets the better of you, and you pick up the piece of notepaper to have a look . . .
*/
// Hit "Run My Code"
// Then tap the note to open it
