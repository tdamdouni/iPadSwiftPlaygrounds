// 
//  AssessmentLoader.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

/**
 A convenience class capable of reading entries from Assessment.plist for
 the given page.
 */
struct AssessmentLoader {
    // MARK: Types
    
    enum MessageKey: String {
        case success = "success"
        case solution = "solution"
        case hints = "hints"
        case dynamicHints = "dynamicHints"
    }
    
    // MARK: Properties
    
    static var messages: [String: Any] = {
        guard let assessmentURL = Bundle.main.url(forResource: "Assessment", withExtension: "plist"),
              let plist = NSDictionary(contentsOf: assessmentURL) as? [String: Any] else {
            NSLog("Failed to find Assessment.plist")
            return [:]
        }
        
        return plist
    }()
    
    // MARK: Methods
    
    static func message(for key: String) -> String? {
        guard let message = messages[key] as? String,
            !message.isEmpty else { return nil }
        
        return message
    }
    
    static func message(for key: MessageKey) -> String? {
        return message(for: key.rawValue)
    }
    
    static func hints(for key: MessageKey = .hints) -> [String]? {
        guard let hints = messages[key.rawValue] as? [String] else { return nil }
        let validHints = hints.filter { !$0.isEmpty }
        
        return validHints.isEmpty ? nil : validHints
    }
}
