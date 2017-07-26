//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 What kind of code is it? Well, you found it in the Substitution Ciphers chapter, so maybe that’s what it is. But how will you [decrypt](glossary://decryption) the message if you don't know the shift value?
 
 You open your backpack. You just remembered—your teacher gave you a list of cryptology websites. Maybe one of those will help!
 
 You head over to one of the library computers and enter the address for the first website. It takes you to a page with a few cryptographic functions for you to practice with.
 
 Before you tackle decrypting the entire [ciphertext](glossary://ciphertext), try some basic shifting to get used to how it works.
 
 **Try this:**
 
 1. Choose a word to [encrypt](glossary://encryption)—try your name!
 2. Choose a shift value.
 3. Repeat a few times with different words and shifts until you understand how it works.
 */
//#-hidden-code
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func shift(_ word: String, by shift: Int) {
    proxy?.send(.dictionary([Constants.playgroundMessageKeyWord:PlaygroundValue.string(word),
                             Constants.playgroundMessageKeyShift:.integer(shift)]))
}
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, page, proxy)
//#-end-hidden-code
let word: String = /*#-editable-code*/"<#T##Your Name##String#>"/*#-end-editable-code*/
let shiftCount: Int = /*#-editable-code*/<#T##Shift Value##Int#>/*#-end-editable-code*/

shift(word, by: shiftCount)
//#-hidden-code
page.assessmentStatus = assessmentPoint(word: word, shift: shiftCount)
//#-end-hidden-code
