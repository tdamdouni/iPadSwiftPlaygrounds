// 
//  Tokens.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
/*
     <abstract>
         TokenGenerator is a basic generator used to convert text into Tokens.
     </abstract>     
*/

import Foundation

// Only looking for a very limited set of keywords.
public enum Keyword: String {
    case `if` = "if"
    case `else` = "else"
    case elseIf = "else if"
    case `for` = "for"
    case `while` = "while"
    case `func` = "func"
}

enum Delimiter: String {
    case openBrace = "{"
    case closingBrace = "}"
    case openParen = "("
    case closingParen = ")"
}

// MARK: Token

enum Token {
    // Includes identifier's, punctuation, literals, and operators.
    case identifier(String)
    case keyword(Keyword)
    
    case number(Double)
    
    case delimiter(Delimiter)
    
    var contents: String {
        switch self {
        case .keyword(let kw): return kw.rawValue
        case .identifier(let str): return str
        case .number(let num): return String(num)
        case .delimiter(let del): return del.rawValue
        }
    }
}

extension Token: Equatable {}
func ==(lhs: Token, rhs: Token) -> Bool {
    switch (lhs, rhs) {
    case (.identifier(let l), .identifier(let r)) where l == r: return true
    case (.keyword(let l), .keyword(let r)) where l == r: return true
    case (.number(let l), .number(let r)) where l == r: return true
    case (.delimiter(let l), .delimiter(let r)) where l == r: return true
    default: return false
    }
}

struct Tokenizer {
    let expression: NSRegularExpression
    let tokenTransform: (String) -> Token?
    
    init(pattern: String, transform: @escaping (String) -> Token?) throws {
        // "^" to match only the beginning of the provided content.
        expression = try NSRegularExpression(pattern: "^\(pattern)", options: [])
        self.tokenTransform = transform
    }
    
    func firstMatch(in content: String) -> (length: Int, token: Token?)? {
        let contentRange = NSMakeRange(0, content.utf16.count)
        let matchRange = expression.rangeOfFirstMatch(in: content, options: [], range: contentRange)
        guard matchRange.location != NSNotFound else { return nil }
        
        let match = (content as NSString).substring(with: matchRange)
        return (match.characters.count, tokenTransform(match))
    }
}

struct TokenIterator: IteratorProtocol {

    let tokenizers = [
        // Remove multiline Comments
        try! Tokenizer(pattern: "\\/\\*[\\s\\S]*?\\*\\/") { _ in nil },
        
        // Remove single line Comments
        try! Tokenizer(pattern: "\\/\\/[^\\n]*\\n?") { _ in nil },
        
        // Match numbers.
        try! Tokenizer(pattern: "\\d{0,}\\.?\\d{1,}") { .number(Double($0)!) },
        
        // Match all characters between delimiters.
        try! Tokenizer(pattern: "[^\\b\\s{}()]+") { word in
            if let keyword = Keyword(rawValue: word) {
                return .keyword(keyword)
            }
            return .identifier(word)
        },
        
        // Remove empty space
        try! Tokenizer(pattern: "[\\s]") { _ in nil },
    ]
    
    let content: String
    let characters: String.CharacterView
    
    var index: String.CharacterView.Index
    
    init(content: String) {
        self.content = content
        
        characters = content.characters
        index = characters.startIndex
    }
    
    // MARK: IteratorProtocol
    
    mutating func next() -> Token? {
        // Not all matches produce a valid token, some are used just to advance the content.
        var token: Token?
        
        repeat {
            let remainingCharacters = characters.suffix(from: index)
            guard !remainingCharacters.isEmpty else { return nil }
            
            let remainingContent = String(remainingCharacters)
            if let match = firstMatch(in: remainingContent) {
                // Only take the first match. Matches should be mutually exclusive.
                token = match.token
                
                // Advance content passed matched expression.
                index = characters.index(index, offsetBy: match.length)
            }
            else {
                // Advance by one character if no match was found.
                index = characters.index(after: index)
                
                let nextCharacter = String(remainingCharacters.first!)
                if let delimiter = Delimiter(rawValue: nextCharacter) {
                    token = .delimiter(delimiter)
                }
                else {
                    token = .identifier(nextCharacter)
                }
            }
            
        // If a valid token could not be found, loop to find a token, or return `nil`
        // when there are no remaining characters.
        } while token == nil
        
        return token
    }
    
    func firstMatch(in content: String) -> (length: Int, token: Token?)? {
        for generator in tokenizers {
            guard let match = generator.firstMatch(in: content) else { continue }
            
            // Only take the first match. Matches should be mutually exclusive.
            return match
        }
        
        return nil
    }
}

struct TokenGenerator: Sequence {
    let content: String
    
    func makeIterator() -> TokenIterator {
        return TokenIterator(content: content)
    }
}
