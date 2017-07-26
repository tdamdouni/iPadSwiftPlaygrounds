//
//  AccessibilityComponent.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import AVFoundation

protocol AccessibilityComponentProtocol : class, Identifiable {
    func ignoreRequestToPerform(command: Action) -> Bool
    func speakText(for command: Action) -> String
}

extension AccessibilityComponentProtocol {
    // Most components aren't going to want/need to ignore the request to speak
    func ignoreRequestToPerform(command: Action) -> Bool {
        return false
    }
}

class AccessibilityComponent <Component: AccessibilityComponentProtocol> : NSObject, ActorComponent, AVSpeechSynthesizerDelegate {
    unowned let component: Component
    private var results = [AVSpeechUtterance : PerformerResult]()
    let synthesizer = AVSpeechSynthesizer()
    let queue = DispatchQueue(label: "com.LTC.AccessibilityComponentQueue")
    
    init(component: Component) {
        self.component = component
        
        super.init()
        synthesizer.delegate = self
    }
    
    deinit {
        // Configure the session for music playback when not using the accessibility component.
        AudioSession.current.configureEnvironment()
    }

    var id: ItemID {
        get {
            return component.id
        }
    }

    func applyStateChange(for action: Action) { }
    
    func perform(_ command: Action) -> PerformerResult {
        guard !component.ignoreRequestToPerform(command: command) else { return .done(self) }
        
        // Adjust the speed to a reasonable rate based on the requested `commandSpeed`
        let index = WorldConfiguration.Actor.possibleSpeeds.index(of: Actor.commandSpeed) ?? 0
        let speechRate = WorldConfiguration.Actor.speechRates[index]
        
        /// Speak the command.
        let utterance = AVSpeechUtterance(string: component.speakText(for: command))
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = speechRate
        
        queue.async {
            do {
                // Set the category to play even if audio is silenced.
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
            }
            catch {
                log(message: "Failed to configure audio environment for AccessibilityComponent \(error).")
            }
            
            self.synthesizer.speak(utterance)
        }
        
        let result = PerformerResult.differed(self)
        results[utterance] = result
        return result
    }
    
    func perform(event: EventGroup, variation: Int, speed: Float) -> PerformerResult {
        if let actor = component as? Actor {
            guard let action = actor.currentAction else { return PerformerResult.done(self) }
            return perform(action)
        }
        
        return .done(self)
    }

    func cancel(_: Action) {
        synthesizer.stopSpeaking(at: .word)
    }
    
    // MARK: AVSpeechSynthesizerDelegate
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        // Mark this component as complete for this particular utterance when speech is finished.
        guard let resultForUtterance = results.removeValue(forKey: utterance) else {
            log(message: "Failed to find PerformerResult matching utterance speaking: \"\(utterance.speechString)\"")
            return
        }

        resultForUtterance.complete()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        // Mark this component as complete for this particular utterance when speech is cancelled.
        guard let resultForUtterance = results.removeValue(forKey: utterance) else {
            log(message: "Failed to find PerformerResult matching utterance speaking: \"\(utterance.speechString)\"")
            return
        }

        resultForUtterance.complete()
    }
}

extension Action.Movement {
    var speakableDescription: String {
        switch self {
        case .walk: return NSLocalizedString("walked", comment: "AX movement description")
        case .jump: return NSLocalizedString("jumped", comment: "AX movement description")
        case .teleport: return NSLocalizedString("teleported", comment: "AX movement description")
        }
    }
}

extension Controller {
    var speakableDescription: String {
        var description = ""
        switch self.kind {
        case .movePlatforms:
            if state == true {
                description = NSLocalizedString("turn lock to move platforms up", comment: "AX controller description")
            }
            else {
                description = NSLocalizedString("turn lock to move platforms down", comment: "AX controller description")
            }

        case .toggle:
            if state == true {
                description = NSLocalizedString("toggled switch open", comment: "AX controller description")
            }
            else {
                description = NSLocalizedString("toggled switch closed", comment: "AX controller description")
            }

        case .activate:
            if state == true {
                description = NSLocalizedString("changed portal to active", comment: "AX controller description")
            }
            else {
                description = NSLocalizedString("changed portal to inactive", comment: "AX controller description")
            }
        }

        return description
    }
}

extension IncorrectAction {
    var speakableDescription: String {
        switch self {
        case .missingGem:
            return NSLocalizedString("tried to collect gem, but no gem was found", comment: "AX incorrect action description")
            
        case .missingSwitch:
            return NSLocalizedString("tried to toggle switch, but no switch was found", comment: "AX incorrect action description")
            
        case .missingLock:
            return NSLocalizedString("tried to turn lock, but no lock was found", comment: "AX incorrect action description")
            
        case .intoWall:
            return NSLocalizedString("failed to move forward, hit wall", comment: "AX incorrect action description")

        case .offEdge:
            return NSLocalizedString("failed to move forward, almost fell off edge", comment: "AX incorrect action description")
        }
    }
}

extension Actor : AccessibilityComponentProtocol {
    func ignoreRequestToPerform(command: Action) -> Bool {
        return isIdle
    }

    func speakText(for command: Action) -> String {
        return "\(speakableName) " + speakableDescription(for: command) + "."
    }
}
