// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import PlaygroundSupport

// MARK: Top level

var loader: AssessmentLoader? = nil
public var assessmentController: AssessmentController? = nil


public enum EvaluationStyle {
    case discrete
    case continuous
}


public class AssessmentController {
    
    let evaluator: Evaluator
    
    let style: EvaluationStyle
    
    public var enabled: Bool = true
    
    public var context : AssessmentInfo.Context = .discrete
    
    private var events = [AssessmentEvent]()
    
    public var customInfo = [AnyHashable : Any]()
    
    public var allowAssessmentUpdates: Bool
    
    public var shouldStopPageAfterDiscreteAssessment: Bool = true

    public init(evaluator: Evaluator, style: EvaluationStyle) {
        
        self.evaluator = evaluator
        self.style = style
        
        switch style {
        case .continuous:
            allowAssessmentUpdates = false
            
        case .discrete:
            allowAssessmentUpdates = true
        }
        
    }
    
    public func append(_ event: AssessmentEvent) {
        if allowAssessmentUpdates {
            events.append(event)
        }
    }
    
    public func removeAllAssessmentEvents() {
        events.removeAll()
    }
    
    public func setAssessmentStatus() {
        guard enabled else { return }
        
        let info = AssessmentInfo(events: events, context: context, customInfo: customInfo)
        if let status = evaluator.performAssessment(assessmentInfo: info) {
            switch status {
            case .pass(_):
                enabled = false
                if let currentStatus = PlaygroundPage.current.assessmentStatus, case .pass = currentStatus {
                    return //Avoid setting assessment status if it's already marked as pass.
                }
                PlaygroundPage.current.assessmentStatus = status
            case .fail(_, _):
                if style == .discrete {
                    PlaygroundPage.current.assessmentStatus = status
                }
            }
        }
    }
}

// MARK: Evaluator

public typealias FailureMessage = (hints: [String], solution: String?)

public protocol Evaluator {
    /// The message to be displayed when `evaluate(info:)` returns true. 
    /// By default this message is loaded from Assessment.plist.
    func successMessage() -> String?
    
    /// By default this message is loaded from Assessment.plist.
    func failureMessage() -> FailureMessage?
    
    /// Custom evaluation to determine pass/fail assessment.
    /// Return `true` to mark the page as successful.
    /// Return `false` to trigger the hints UI.
    /// Return `nil` to avoid triggering any assessment feedback.
    func evaluate(assessmentInfo: AssessmentInfo) -> Bool?
}

public extension Evaluator {
    /// Defers execution of all methods until `assessmentStatus()` is called.
    func performAssessment(assessmentInfo: AssessmentInfo) -> PlaygroundPage.AssessmentStatus? {
        if let result = evaluate(assessmentInfo: assessmentInfo) {
            if result {
                return .pass(message: successMessage())
            }
            else {
                guard let (hints, solution) = failureMessage() else { return nil }
                return .fail(hints: hints, solution: solution)
            }
        }
        return nil
    }
}

public extension Evaluator {
    // MARK: Load Messages
    
    /// Loads the "solution" and "hints" from Assessment.plist.
    func loadFailureMessage() -> FailureMessage? {
        let solution = AssessmentLoader.message(for: .solution)
        
        if let hints = AssessmentLoader.hints(), !hints.isEmpty {
            // Hints with optional solution.
            return (hints, solution)
        }
        else if let solution = solution {
            // Support no hints with a solution.
            return ([], solution)
        }
        else {
            // No failure message.
            return nil
        }
    }
    
    // MARK: Default Implementations 
    
    /// Loads the "success" message from Assessment.plist.
    func successMessage() -> String? {
        return AssessmentLoader.message(for: .success)
    }
    
    /// Loads the "solution" and "hints" from Assessment.plist.
    func failureMessage() -> FailureMessage? {
        return loadFailureMessage()
    }
}

// MARK: Assessment Registration

public func registerEvaluator(_ assessment: Evaluator, style: EvaluationStyle) {
    assessmentController = AssessmentController(evaluator: assessment, style: style)
}

/// Displays assessment information. 
public func performAssessment() {
    guard let controller = assessmentController, controller.style == .discrete else { return }
    controller.setAssessmentStatus()    
    if controller.shouldStopPageAfterDiscreteAssessment {
        PlaygroundPage.current.finishExecution()
    }
}



