//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 Approaching the reference desk, you clear your throat, and Mr. Nefarian eyes you suspiciously.
 
 "Yes? Can I help you?"
 
 "Please, do you have the answer?" you ask.
 
 Mr. Nefarian looks at you blankly. "The answer to what?" he replies.
 
 You're not sure what to do now—he *must* be "N," but he doesn't seem to know anything!
 
 Maybe you're forgetting something from the message…
 */
//#-hidden-code
import PlaygroundSupport
import UIKit

let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy

func giveThePassword(password: String) {
    let spaces: Set<Character> = [" "]
    let normalizedString = String(password.lowercased().characters.lazy.filter {!spaces.contains($0)})
    if normalizedString == "opensesame" {
         proxy?.send(.string(Constants.playgroundMessageKeyCorrectPassword))
    }
}
//#-code-completion(everything, hide)
//#-end-hidden-code
// Give the password
let password: String = /*#-editable-code*/"<#T##Password##String#>"/*#-end-editable-code*/
giveThePassword(password: password)
//#-hidden-code
page.assessmentStatus = assessmentPoint(password: password)
//#-end-hidden-code
