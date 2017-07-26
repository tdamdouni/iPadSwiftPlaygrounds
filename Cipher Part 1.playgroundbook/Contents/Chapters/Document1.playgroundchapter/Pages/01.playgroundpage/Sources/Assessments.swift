//
//  Assessments.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport
import UIKit

private let successString = NSLocalizedString("Cryptography has a fascinating history! You start flipping ahead in the book, browsing page titles, and stopping here and there to look at something more closely. [Next Page](@next)", comment:"Success message for openBook page.")
private let solutionString = NSLocalizedString("`openBook()`", comment:"Solution for openBook page.")
private let openBookHint = NSLocalizedString("Is there a function in the shortcut bar that can help you open the book?", comment:"Hint for openBook method.")

public func assessmentPoint() -> PlaygroundPage.AssessmentStatus {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var hints = [String]()
    
    if checker.functionCallCount(forName: "openBook") == 0 {
        hints.append(openBookHint)
    }
    
    if !hints.isEmpty {
        // Show hints
        return .fail(hints: hints, solution: solutionString)
    } else {
        return .pass(message: successString)
    }
}
