// 
//  ContentsChecker.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation

let blackListCalls = [
    "playgroundPrologue",
    "playgroundEpilogue",
    "startPlayback"
]

/**:
 This does not analyze the code execution. It only makes statements about 
 the static nature of the contents.
 */
public class ContentsChecker {
    let contents: String
    let nodes: [Node]
    
    public let numberOfStatements: Int
    
    public init(contents: String) {
        self.contents = contents
        
        let tokens = TokenGenerator(content: contents).reduce([]) { tokens, currentToken in
            return tokens + [currentToken]
        }
        
        let parser = SimpleParser(tokens: tokens)
        
        let nodes: [Node]
        do {
            nodes = try parser.createNodes()
        }
        catch {
            nodes = []
        }
        
        let filteredNodes = nodes.filter { node in
            // Exclude function calls identified by the `blackListCalls`.
            if let call = node as? CallNode {
                return !blackListCalls.contains(call.identifier)
            }
            return true
        }
        self.nodes = filteredNodes
        
        numberOfStatements = filteredNodes.reduce(0) { $0 + $1.lineCount }
    }
    
    func nodesOfType<T: Node>(_ type: T.Type) -> [T] {
        return nodes.flatMap { node -> [T] in
            var subNodes = [node]
            if let statement = node as? Statement {
                 subNodes += statement.flattenedBodyNodes
            }
            
            return subNodes.flatMap { $0 as? T }
        }
    }
    
    public lazy var definitionNodes: [DefinitionNode] = self.nodesOfType(DefinitionNode.self)
    public lazy var callNodes: [CallNode] = self.nodesOfType(CallNode.self)
    public lazy var loopNodes: [LoopNode] = self.nodesOfType(LoopNode.self)
    public lazy var conditionalNodes: [ConditionalStatementNode] = self.nodesOfType(ConditionalStatementNode.self)

    /// The names of the custom functions defined in the contents.
    public var customFunctions: [String] {
        return definitionNodes.map {
            $0.name
        }
    }
    
    /// The names of the functions that were called.
    public var calledFunctions: [String] {
        return callNodes.map {
            $0.identifier
        }
    }
    
    public var hasForLoop: Bool {
        return loopNodes.contains {
            $0.type == .for
        }
    }
    
    public var hasWhileLoop: Bool {
        return loopNodes.contains {
            $0.type == .while
        }
    }
    
    public var hasConditionalStatement: Bool {
        return !conditionalNodes.isEmpty
    }
    
    public func hasConditionalStatement(_ name: String) -> Bool {
        guard let word = Keyword(rawValue: name) else { return false }
        return conditionalNodes.contains {
            $0.type == word
        }
    }
    
    /// Returns `true` if a function was defined and then contains a call to 
    /// the function at least once.
    public func calledCustomFunction() -> Bool {
        return customFunctions.contains {
            functionCallCount(forName: $0) > 0
        }
    }
    
    public func functionCallCount(forName name: String) -> Int {
        return callNodes.filter {
            $0.identifier == name
        }.count
    }
    
    public func function(_ name: String, matchesCalls calls: [String]) -> Bool {
        guard let functionNode = definitionNodes.first else { return false }
        guard !functionNode.body.isEmpty else { return false }
        
        let sanitizedCalls: [String] = calls.map {
            if $0.hasSuffix("()") {
                return String($0.characters.dropLast(2))
            }
            return $0
        }
        
        guard functionNode.body.count == sanitizedCalls.count else { return false }
        for (bodyNode, check) in Zip2Sequence(_sequence1: functionNode.body, _sequence2: sanitizedCalls) {
            guard let call = bodyNode as? CallNode else { continue }
            
            if call.identifier != check {
                return false
            }
        }
        
        return true
    }
}
