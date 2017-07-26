// 
//  HelperFunctions.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import AVFoundation

let speech = Speech()

var instruments: [Instrument.Kind: Instrument] = [:]

var audioController = AudioController()

@objc
class AudioController: NSObject, AVAudioPlayerDelegate {

    var activeAudioPlayers = Set<AVAudioPlayer>()
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        activeAudioPlayers.remove(player)
    }
    
    func register(_ player: AVAudioPlayer) {
        activeAudioPlayers.insert(player)
        player.delegate = self
    }
}

var audioEngine: AudioPlayerEngine = {
    let audioPlayerEngine = AudioPlayerEngine()
    audioPlayerEngine.start()
    return audioPlayerEngine
}()

/// Generates a random Int in the provided range.
public func randomInt(from: Int, to: Int) -> Int {
    let maxValue: Int = max(from, to)
    let minValue: Int = min(from, to)
    if minValue == maxValue {
        return minValue
    } else {
        return (Int(arc4random())%(1 + maxValue - minValue)) + minValue
    }
}

/// Generates a random Double (decimal number) in the provided range.
public func randomDouble(from: Double, to: Double) -> Double {
    let maxValue = max(from.double, to.double)
    let minValue = min(from.double, to.double)
    if minValue == maxValue {
        return minValue
    } else {
        // Between 0.0 and 1.0
        let randomScaler = Double(arc4random()) / Double(UInt32.max)
        return (randomScaler * (maxValue-minValue)) + minValue
    }
}


/// Speaks the provided text.
public func speak(_ text: String, voice: SpeechVoice = SpeechVoice()) {
    speech.speak(text, voice: voice)
}

/** 
 Plays the specified sound. Can optionally specify a volume and speed from 0 (none) to 100 (max), with 50 being normal. 
 */
public func playSound(_ sound: Sound, volume: Number = 80) {
    
    guard let url = sound.url else { return }
    
    do {
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        audioPlayer.volume = Float(max(min(volume.int, 100), 0)) / 100.0
        audioController.register(audioPlayer)
        audioPlayer.play()
    } catch {}
    assessmentController?.append(.playSound(sound: sound, volume: volume))
    
}

func createInstrument(_ kind: Instrument.Kind) -> Instrument {
    
    let instrument = Instrument(kind: kind)
    instrument.connect(audioEngine)
    instrument.defaultVelocity = 64
    return instrument
}

/// Plays a note (from 0 to 23) with the specified instrument and volume. Volume can be from 0 (silent) to 100 (loudest).
public func playInstrument(_ instrumentKind: Instrument.Kind, note: Number, volume: Number = 75) {
    
    if instruments[instrumentKind] == nil {
        instruments[instrumentKind] = createInstrument(instrumentKind)
    }
    guard let instrument = instruments[instrumentKind] else { return }
    
    // Get corresponding midi note value
    let noteIndex = min(max(note.int, 0), instrument.availableNotes.count - 1)
    
    let velocity = Double(max(min(volume.int, 100), 0)) / 100.0 * 127.0
    
    instrument.startPlaying(noteValue: instrument.availableNotes[noteIndex], withVelocity: UInt8(velocity), onChannel: 0)
    assessmentController?.append(.playInstrument(instrumentKind: instrumentKind, note: note, volume: volume))

}

