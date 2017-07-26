// 
//  SimpleParser.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
/*
     <abstract>
         A very limited parser which looks for simple language constructs.
         
          Known limitations:
          - Cannot distinguish between functions based on argument labels or parameter type (only name).
          - Only checks for (func, if, else, else if, for, while) keywords.
          - Makes no attempt to recover if a parsing error is discovered.
     </abstract>     
*/

import Foundation

enum ParseError: Error {
    case fail(String)
}

class SimpleParser {
    let tokens: [Token]
    var index = 0
    
    init(tokens: [Token]) {
        self.tokens = tokens
    }
    
    var currentToken: Token? {
        guard tokens.indices.contains(index) else { return nil }
        return tokens[index]
    }
    
    var nextToken: Token? {
        let nextIndex = tokens.index(after: index)
        guard nextIndex < tokens.count else { return nil }

        return tokens[nextIndex]
    }
    
    /// Advances the index, and returns the new current token if any.
    @discardableResult
    func advanceToNextToken() -> Token? {
        index = tokens.index(after: index)
        
        return currentToken
    }
    
    /// Converts the `tokens` into `Node`s.
    func createNodes() throws -> [Node] {
        var nodes = [Node]()
        
        while let token = currentToken {
            if let node = try parseToken(token) {
                nodes.append(node)
            }
        }
        
        return nodes
    }
    
    // MARK: Main Parsers
    
    private func parseToken(_ token: Token) throws -> Node? {
        var node: Node? = nil
        switch token {
        case let .keyword(word):
            node = try parseKeyword(word)
            
        case let .identifier(name):
            if case .delimiter(.openParen)? = advanceToNextToken() {
                // Ignoring parameters for now.
                consumeTo(.closingParen)
                advanceToNextToken()
                
                node = CallNode(identifier: name)
            }
            else {
                // This is by no means completely correct, but works for the
                // kind of information we're trying to glean.
                node = VariableNode(identifier: name)
            }
            
        case .number(_):
            // Discard numbers for now.
            advanceToNextToken()
            
        case .delimiter(_):
            // Discard tokens that don't map to a top level node.
            advanceToNextToken()
        }
        
        return node
    }
    
    func parseKeyword(_ word: Keyword) throws -> Node {
        let node: Node

        // Parse for known keywords.
        switch word {
        case .func:
            node = try parseDefinition()
            
        case .if, .else, .elseIf:
            node = try parseConditionalStatement()
            
        case .for, .while:
            node = try parseLoop()
        }
        
        return node
    }
    
    // MARK: Token Parsers
    
    func parseDefinition() throws -> DefinitionNode {
        guard case .identifier(let funcName)? = advanceToNextToken() else { throw ParseError.fail(#function) }
        
        // Ignore any hidden comments (e.g. /*#-end-editable-code*/).
        consumeTo(.openParen)
        
        let argTokens = consumeTo(.closingParen)
        let args = reduce(argTokens)
        
        consumeTo(.openBrace)
        let body = try parseToClosingBrace()
        return DefinitionNode(name: funcName, parameters: args, body: body)
    }
    
    func parseConditionalStatement() throws -> Node {
        guard case .keyword(var type)? = currentToken else { throw ParseError.fail(#function) }
        
        // Check if this is a compound "else if" statement.
        if case .keyword(let subtype)? = nextToken, subtype == .if {
            type = .elseIf
            advanceToNextToken()
        }
        
        let conditionTokens = consumeTo(.openBrace)
        let condition = reduce(conditionTokens)
        
        let body = try parseToClosingBrace()
        return ConditionalStatementNode(type: type, condition: condition, body: body)
    }
    
    func parseLoop() throws -> Node {
        guard case .keyword(let type)? = currentToken else { throw ParseError.fail(#function) }

        let conditionTokens = consumeTo(.openBrace)
        let condition = reduce(conditionTokens)
        
        let body = try parseToClosingBrace()
        return LoopNode(type: type, condition: condition, body: body)
    }
    
    // MARK: Convenience Methods
    
    func parseToClosingBrace() throws -> [Node] {
        var nodes = [Node]()

        loop: while let token = currentToken {
            switch token {
            case .delimiter(.openBrace):
                advanceToNextToken()
                
                // Recurse on opening brace.
                nodes += try parseToClosingBrace()
                break loop
                
            case .delimiter(.closingBrace):
                // Complete.
                advanceToNextToken()
                break loop
                
            default:
                if let node = try parseToken(token) {
                    nodes.append(node)
                }
            }
        }
        
        return nodes
    }
    
    @discardableResult
    func consumeTo(_ match: Token) -> [Token] {
        var content = [Token]()
        while let token = advanceToNextToken() {
            if token == match {
                break
            }
            
            content.append(token)
        }
        
        return content
    }
    
    @discardableResult
    func consumeTo(_ delimiter: Delimiter) -> [Token] {
        return consumeTo(.delimiter(delimiter))
    }
    
    func reduce(_ tokens: [Token], separator: String = "") -> String {
        let contents = tokens.reduce("") { $0 + $1.contents + separator }
        return contents
    }
}
