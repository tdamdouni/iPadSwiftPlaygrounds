//
//  Assessments.swift
//
//  Copyright (c) 2017 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport
import UIKit

private let successString = NSLocalizedString("Once you feel like you've done enough shifting and are ready to try decrypting the message, head to the [next page](@next).", comment:"Success string for Practicing Shifting")
private let zeroShiftHint = NSLocalizedString("Is this thing working right? Why isn't anything happening with the shift you used? Well, when you use a shift of 26, or 52, or any other multiple of the number of letters in the English alphabet, the whole thing wraps around and goes back to the beginning. When that happens, it's like you haven’t shifted at all.", comment:"Zero shift hint")

public func assessmentPoint(word: String, shift: Int) -> PlaygroundPage.AssessmentStatus {
    
    var hints = [String]()
    
    if shift % 26 == 0 {
        hints.insert(zeroShiftHint, at: 0)
    }
    
    if !hints.isEmpty {
        // Show hints
        return .fail(hints: hints, solution: nil)
    } else {
        hints = []
        return .pass(message: successString)
    }
}
