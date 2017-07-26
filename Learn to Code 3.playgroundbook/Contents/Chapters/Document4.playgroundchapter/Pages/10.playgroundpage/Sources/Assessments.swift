// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport
import CoreGraphics

/**
 A custom implementation of an Evaluator to determine the per-page messages,
 and the conditions which evaluate to a successful run.
 */
class PageAssessment: Evaluator {

    var instrumentsPlayed = Set<Instrument.Kind>()

    /// Custom per-page evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool? {
        if assessmentInfo.context != .tool { return nil }

        for event in assessmentInfo.events {
            if case .playInstrument(let instrument, _, _) = event {
                instrumentsPlayed.insert(instrument)
            }
        }
        
        if instrumentsPlayed.count > 2 {
            return true
        }
        return nil
    }
}
