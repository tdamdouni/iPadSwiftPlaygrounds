//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 Now that you've practiced shifting a word at a time, it's time to figure out what this message says!
 
 One of the pages you skimmed earlier in the cryptography book talked about [brute force](glossary://brute%20force)—a type of [attack](glossary://attack) on a [cipher](glossary://cipher) where you try every possible combination or option. (Sort of like the time the school principal was locked out of her office. The janitor had to come with a key ring and try every key to figure out which one opened the door!)
 
 A similar strategy might work for this message—if you try *every possible shift*, one of them has to be right! You have the shifting function from before, and all the Swift operators at your disposal. Remember, you're *decrypting* now, so instead of the letters shifting forward, like when you’re encrypting, they’ll shift backward. Good luck!
 
 **Try this:**
 
 1. Figure out how many times you need to [call](glossary://call) the shift function to check every possibility. How many letters are in the alphabet? Do you need to shift by 0? Or 26?
 2. Write the code to call the shift function as many times as you need to. What kind of code structure helps you do something repetitively?
 3. When you call the shift function, be sure to use `ciphertext` and your shift as its [arguments](glossary://argument).
 4. Run your code, and swipe to look through all the decryptions until you find the correct one!
 */
//#-hidden-code
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
page.needsIndefiniteExecution = true
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
var scrolledToSuccessfulDecryption = false

class DecryptionListener: PlaygroundRemoteLiveViewProxyDelegate {
    func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy,
                             received message: PlaygroundValue) {
        if case let .string(text) = message {
            if text == Constants.playgroundMessageKeySuccess {
                scrolledToSuccessfulDecryption = true
                page.assessmentStatus = assessmentPoint(success: scrolledToSuccessfulDecryption)
            }
        }
    }
    
    func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) { }
}

let listener = DecryptionListener()
proxy?.delegate = listener

func shift(_ word: String, by shift: Int) {
    proxy?.send(.dictionary([Constants.playgroundMessageKeyWord:PlaygroundValue.string(word),
                             Constants.playgroundMessageKeyShift:.integer(shift)]))
}
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, hide, page, proxy, DecryptionListener, scrolledToSuccessfulDecryption, listener)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, +=, -=, %, "", &&, ||, !, *, /, .)
//#-end-hidden-code
let ciphertext = "HTSLWFYZQFYNTSX, XJJPJW! DTZ MFAJ UFXXJI YMJ KNWXY YJXY. KJB JAJW KNSI YMJ UFYM, FSI KJBJW XYNQQ BFQP ZUTS NY. QTTP YT 'S' YT HTSYNSZJ DTZW OTZWSJD. TUJS XJXFRJ."
//#-editable-code

//#-end-editable-code
//#-hidden-code
page.assessmentStatus = assessmentPoint(success: scrolledToSuccessfulDecryption)
//#-end-hidden-code
