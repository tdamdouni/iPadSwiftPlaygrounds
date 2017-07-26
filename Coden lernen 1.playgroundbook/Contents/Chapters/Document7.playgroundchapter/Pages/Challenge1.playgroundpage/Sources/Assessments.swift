// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let solution: String? = nil


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    pageIdentifier = "Roll_Right,_Roll_Left"
    
    
    let success = NSLocalizedString("### Outstanding work! \nYou've just completed Learn to Code 1. Time to shout out, \"I'm a coding master!\" and do a little dance. \n\nYou've come quite a long way from writing simple commands. You are now able to write intelligent [algorithms](glossary://algorithm) using [`for`](glossary://for%20loop) and [`while` loops](glossary://while%20loop), as well as [conditional code](glossary://conditional%20code) to make your code adaptable to different situations.\n\nIt's time to start the next part of your coding journey—[**Learn to Code 2**](playgrounds://featured).", comment:"Success message")
    var hints = [
        NSLocalizedString("First, look for a pattern in the puzzle. When you find a pattern, think through which rules and instructions will solve each piece of that pattern. When you figure out an approach, write your code.", comment:"Hint"),
        NSLocalizedString("Notice that whenever gems are present, the path moves to the right. Whenever switches are present, the path moves to the left. Use this pattern to create your algorithm.", comment:"Hint"),
        NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

    ]
    
    
    switch currentPageRunCount {
    
    case 0..<2:
        break
    case 2..<5:
        hints[0] = NSLocalizedString("Whenever a gem is present, collect the gem and move to the right. Whenever a switch is present, toggle the switch and move to the left.", comment:"Hint")
    case 5..<8:
        hints[0] = NSLocalizedString("Even if it doesn't feel like it, you're always making progress. Getting stuck means you're only a few tries away from finding an answer. Keep trying!", comment:"Hint")
    default:
        break
        
    }
    
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
