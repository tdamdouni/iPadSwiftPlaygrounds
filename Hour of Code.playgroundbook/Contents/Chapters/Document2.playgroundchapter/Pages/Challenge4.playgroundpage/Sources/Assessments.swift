// 
//  Assessments.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

let success = NSLocalizedString("### Stellar work! \nThe way you’re solving problems here is exactly what coders do. Building an app is really just a matter of finding solutions to tons of small problems. After solving the small problems, coders combine those solutions to solve a bigger problem. \n\nCongratulations on completing Functions—now it's time to learn about [**For Loops**](@next).", comment:"Success message")
let hints = [
    NSLocalizedString("Think about the patterns in the placement of switches. How can you take advantage of the patterns to write functions to solve small problems, and combine them to solve the larger problem?", comment:"Hint"),
    NSLocalizedString("First, try defining a function that moves forward twice and toggles a switch. From there, define another function that toggles a switch, turns around, and returns to the center.", comment:"Hint"),
    NSLocalizedString("Try creating these two functions and using them to solve the puzzle:\n\n    func moveThenToggle() {\n       moveForward()\n       moveForward()\n       toggleSwitch()\n    }\n \n    func toggleSwitchTurnAround() {\n       moveThenToggle()\n       turnLeft()\n       turnLeft()\n       moveForward()\n       moveForward()\n    }", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")

]

let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
