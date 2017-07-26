//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 The message says to look to “N.” Who or what is "N"?!
 
 You glance around the library and see all sorts of things that might be “N”: novels; notebooks; newspapers; Mr. Nefarian, the librarian; new releases; Nibbler, Ms. Chin's seeing eye dog . . .
 
 One of these things must hold the next piece of the puzzle! Try investigating a few different areas in the library and see what you can turn up. Good luck!
 */
//#-hidden-code
import PlaygroundSupport
let page = PlaygroundPage.current
let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
var investigationType = InvestigationType.novels

func investigate(_ type: InvestigationType) {
    switch type {
    case .librarian:
        investigationType = .librarian
        proxy?.send(.string(Constants.playgroundMessageKeyLibrarian))
    case .newspapers:
        investigationType = .newspapers
        proxy?.send(.string(Constants.playgroundMessageKeyNewspapers))
    case .novels:
        investigationType = .novels
        proxy?.send(.string(Constants.playgroundMessageKeyNovels))
    }
}
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, novels, newspapers, librarian)
//#-end-hidden-code
investigate(/*#-editable-code*/.<#T##Investigate##InvestigationType#>/*#-end-editable-code*/)
//#-hidden-code
page.assessmentStatus = assessmentPoint(investigationType: investigationType)
//#-end-hidden-code
