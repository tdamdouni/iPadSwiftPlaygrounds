// 
//  AccessibilityComponent.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import AVFoundation

class AccessibilityComponent: NSObject, ActorComponent, AVSpeechSynthesizerDelegate {
    // MARK: Properties
    
    unowned let actor: Actor
    
    let synthesizer = AVSpeechSynthesizer()
    
    required init(actor: Actor) {
        self.actor = actor
    }
    
    // MARK: Performer
    
    func perform(_ command: Action) {
        let speed = actor.world?.commandSpeed ?? 1.0
        
        /// Speak the command.
        let utterance = AVSpeechUtterance(string:  "\(actor.speakableName) " + speakableDescription(for: command) + ".")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate + (0.25 * (speed - 1 ))
        
        synthesizer.delegate = self
        synthesizer.speak(utterance)
    }
    
    func cancel(_: Action) {
        synthesizer.stopSpeaking(at: .word)
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    @objc(speechSynthesizer:didFinishSpeechUtterance:)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Mark this component as finished when speech is complete.
        actor.performerFinished(self)
    }
    
    @objc(speechSynthesizer:didCancelSpeechUtterance:)
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        actor.performerFinished(self)
    }
    
    // MARK: Command speakableDescription
    
    func speakableDescription(for action: Action) -> String {
        switch action {
        case let .move(from, to):
            let coordinate = Coordinate(to)
            
            if from.y.isClose(to: to.y) {
                let prefix = "moved forward to "
                return prefix + coordinate.description
            }
            let isAscending = from.y < to.y
            let prefix = "moved \(isAscending ? "up" : "down") stairs to "
            return prefix + coordinate.description

        case let .jump(from, to):
            let coordinate = Coordinate(to)
    
            let isAscending = from.y < to.y
            let prefix = "jumped \(isAscending ? "up" : "down") to level \(actor.level) "
            return prefix + coordinate.description

        case .teleport(_, let end):
            let coordinate = Coordinate(end)
            
            let prefix = "moved forward into portal, ended up at "
            return prefix + coordinate.description
            
        case .place(let ids):
            guard let world = actor.world where !ids.isEmpty else { return "" }
            let item = world.item(forID: ids[0])!
            
            return "placed node at" + item.coordinate.description
            
        case .control(_, let movingUp):
            return "turn lock to move platforms \(movingUp ? "up" : "down")"
            
        case .remove(let ids):
            guard let world = actor.world where !ids.isEmpty else { return "" }
            let item = world.item(forID: ids[0])!

            return "picked up item at" + item.coordinate.description
            
        case let .toggle(coordinate, on):
            return "toggled switch \(on ? "open" : "closed") at" + coordinate.description
            
        case .turn(_, let rads, let clkwise):
            let turnDirection = clkwise ? "Right" : "Left"
            let facingDirection = Direction(radians: rads).rawValue
            return "turned" + turnDirection + ", now facing " + facingDirection
            
        case let .incorrect(command):
            return command.speakableDescription
        }
    }
}

extension IncorrectAction {
    var speakableDescription: String {
        switch self {
        case .missingGem:
            return "tried to collect gem, but no gem was found"
            
        case .missingSwitch:
            return "tried to toggle switch, but no switch was found"
            
        case .missingLock:
            return "tried to turn lock, but no lock was found"
            
        case .intoWall:
            return "failed to move forward, hit wall"

        case .offEdge:
            return "failed to move forward, almost fell off edge"
        }
    }
}
