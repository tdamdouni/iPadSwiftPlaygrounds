// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### You found it! \n\nRemember, finding and fixing [bugs](glossary://bug) is an important part of being a coder! An [array out of bounds error](glossary://array%20out%20of%20bounds%20error) is one of the most common bugs to cause apps to crash. When planning your code, always check that you aren't trying to access parts of the array that don't exist. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
NSLocalizedString("The [array out of bounds error](glossary://array%20out%20of%20bounds%20error) happens when you try to access an item in the array that doesn’t exist.", comment:"Hint"),
NSLocalizedString("Look at the [index](glossary://index) values that you try to access in your code. If your array has `9` items, which line of code tries to access an item that isn’t in the array?", comment:"Hint"),
"Make sure you aren't removing any more code than is necessary to correct the [array out of bounds error](glossary://array%20out%20of%20bounds%20error). If you can't figure out what you already deleted, try resetting the page by tapping the three-dot icon and tapping \"Reset Page\"."
]

let solution: String? = "```swift\nvar teamBlu: [Character] = []\nfor i in 1...9 {\n   teamBlu.append(Character(name: .blu))\n}\n\nvar columnPlacement = 0\nfor blu in teamBlu {\n   world.place(blu, at: Coordinate(column: columnPlacement, row: 4))\n         columnPlacement += 1\n}\n\nteamBlu[0].jump()\nteamBlu[2].collectGem()\nteamBlu[4].jump()\nteamBlu[6].collectGem()\nteamBlu[8].jump()\n"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
