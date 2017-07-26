// 
//  AudioComponent.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import SceneKit

class AudioComponent: ActorComponent {
    typealias Sounds = [SCNAudioSource]
    
    static var actorSoundsForType = [ActorType: [AnimationType: Sounds]]()

    // MARK: Sound Loading
    
    static func loadSounds(for type: ActorType, actions: [AnimationType]) {
        var soundsForType: [AnimationType: [SCNAudioSource]] = actorSoundsForType[type] ?? [:]

        // Load all sounds for applicable identifiers.
        for (key, identifiers) in AnimationType.allIdentifiersByType {
            for identifier in identifiers {
                let directory = type.resourceFilePathPrefix
                guard let url = Bundle.main().urlForResource(identifier, withExtension: "m4a", subdirectory: directory),
                    let audioSource = SCNAudioSource(url: url) else { continue }
                
                audioSource.load()
                soundsForType[key] = [audioSource] + (soundsForType[key] ?? [])
            }
        }
        
        actorSoundsForType[type] = soundsForType
    }
    
    // MARK: Properties
    
    unowned let actor: Actor
    
    lazy var soundsForType: [AnimationType: [SCNAudioSource]] = AudioComponent.actorSoundsForType[self.actor.type] ?? [:]
    
    required init(actor: Actor) {
        self.actor = actor
    }

    // MARK: Performer
    
    func cancel(_: Action) {
        node.removeAllAudioPlayers()
    }
    
    // MARK: ActorComponent
    
    func playRandom(animation: AnimationType, withSpeed speed: Float) {
        let rndIndex = soundsForType[animation]?.randomIndex ?? 0
        play(animation: animation, atIndex: rndIndex, speed: speed)
    }
    
    func play(animation: AnimationType, atIndex index: Int, speed: Float) {
        // Don't allow the audio component to block other components.
        actor.performerFinished(self)
        
        guard let sounds = soundsForType[animation] where sounds.indices.contains(index) else {
            log(message: "Failed to find \(animation) audio file.")
            return
        }
        
        // Grab the `SCNAudioSource`
        let source = sounds[index]
        source.rate = speed
        
        // Positional sound
        let player = SCNAudioPlayer(source: source)
        node.addAudioPlayer(player)
    }
}
