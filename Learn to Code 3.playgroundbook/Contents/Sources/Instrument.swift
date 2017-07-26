// 
//  Instrument.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import AVFoundation


/// Notes in the musical scale with associated midi note numbers
enum MusicNote: UInt8 {
    
    case C1 = 24
    case CS1 = 25
    case D1 = 26
    case DS1 = 27
    case E1 = 28
    case F1 = 29
    case FS1 = 30
    case G1 = 31
    case GS1 = 32
    case A1 = 33
    case AS1 = 34
    case B1 = 35
    
    case C2 = 36
    case CS2 = 37
    case D2 = 38
    case DS2 = 39
    case E2 = 40
    case F2 = 41
    case FS2 = 42
    case G2 = 43
    case GS2 = 44
    case A2 = 45
    case AS2 = 46
    case B2 = 47
    
    case C3 = 48
    case CS3 = 49
    case D3 = 50
    case DS3 = 51
    case E3 = 52
    case F3 = 53
    case FS3 = 54
    case G3 = 55
    case GS3 = 56
    case A3 = 57
    case AS3 = 58
    case B3 = 59
    
    case C4 = 60
    case CS4 = 61
    case D4 = 62
    case DS4 = 63
    case E4 = 64
    case F4 = 65
    case FS4 = 66
    case G4 = 67
    case GS4 = 68
    case A4 = 69
    case AS4 = 70
    case B4 = 71
    
    case C5 = 72
    case CS5 = 73
    case D5 = 74
    case DS5 = 75
    case E5 = 76
    case F5 = 77
    case FS5 = 78
    case G5 = 79
    case GS5 = 80
    case A5 = 81
    case AS5 = 82
    case B5 = 83
}

/// An instrument that can play musical notes.
public class Instrument {

    /// The kind of instrument, which can be either an electricGuitar, bassGuitar, cosmicDrums, or piano.
    public enum Kind {
        case electricGuitar, bassGuitar, cosmicDrums, piano
        
        var allMusicNotes: [MusicNote] {
            
            var musicNotes = [MusicNote]()
            for i in MusicNote.C3.rawValue...MusicNote.B5.rawValue {
                musicNotes.append(MusicNote(rawValue: i)!)
            }
            return musicNotes
        }
        
        var allNotes: [UInt8] {
            var notes = [UInt8]()
            for i in MusicNote.C3.rawValue...MusicNote.B5.rawValue {
                notes.append(i)
            }
            return notes
        }

        var wavURLs: [URL] {
            let fileNames: [String]
            
            switch self {
            case .electricGuitar:
                fileNames = ["80s Electric Guitar A1", "80s Electric Guitar A2", "80s Electric Guitar A4", "80s Electric Guitar B1", "80s Electric Guitar B3", "80s Electric Guitar C#5", "80s Electric Guitar D2", "80s Electric Guitar D3", "80s Electric Guitar D4", "80s Electric Guitar E1", "80s Electric Guitar E2", "80s Electric Guitar E3", "80s Electric Guitar E4", "80s Electric Guitar F#4", "80s Electric Guitar F3", "80s Electric Guitar G2"]
            case .bassGuitar:
                fileNames = ["Trad E Bass C1", "Trad E Bass C2", "Trad E Bass C3", "Trad E Bass C4", "Trad E Bass C5", "Trad E Bass E1", "Trad E Bass E2", "Trad E Bass E3", "Trad E Bass E4", "Trad E Bass E5", "Trad E Bass G#1", "Trad E Bass G#2", "Trad E Bass G#3", "Trad E Bass G#4", "Trad E Bass G#5"]
            default:
                fileNames = []
            }
            
            var urls = [URL]()
            
            if fileNames.count > 0 {
                urls = fileNames.map { Bundle.main.url(forResource: $0, withExtension: "wav")! }
            }
            
            return urls
        }
        
        var sf2URL : URL? {
            
            var sf2FileName: String?
            
            switch self {
            case .cosmicDrums:
                sf2FileName = "CosmicDrums"
            case .piano:
                sf2FileName = "Full Grand Piano"
            default: break
            }
            guard let fileName = sf2FileName else { return nil }
            
            return Bundle.main.url(forResource: fileName, withExtension: "sf2")
        }
        
        var availableNotes: [UInt8] {
            return self.availableMusicNotes.map{ $0.rawValue }
        }
        
        var availableMusicNotes: [MusicNote] {
            switch self {
            case .electricGuitar:
                return [.E1, .A1, .B1, .D2, .E2, .G2, .A2, .D3, .E3, .F3, .B3, .D4, .E4, .FS4, .A4, .CS5]
            case .bassGuitar:
                return [.C1, .E1, .CS1, .C2, .E2, .GS2, .C3, .E3, .GS3, .C4, .E4, .GS4, .C5, .E5, .GS5]
            case .piano:
                var musicNotes = [MusicNote]()
                for i in MusicNote.C3.rawValue...MusicNote.B4.rawValue {
                    musicNotes.append(MusicNote(rawValue: i)!)
                }
                return musicNotes

            default:
                var musicNotes = [MusicNote]()
                for i in MusicNote.C2.rawValue...MusicNote.B3.rawValue {
                    musicNotes.append(MusicNote(rawValue: i)!)
                }
                return musicNotes
            }
        }
        
        var allNotesAreAvailable: Bool {
            switch self {
            case .piano:
                return true
            default:
                return false
            }
        }
    }
    
    // Private to prevent the user to edit the instrument type after it is created and playing.
    private var kind: Kind
    
    private let sampler = AVAudioUnitSampler()
    
    private weak var audioEngine: AudioPlayerEngine?
    
    var availableNotes: [UInt8] {
        return self.kind.availableNotes
    }
    
    var availableMusicNotes: [MusicNote] {
        return self.kind.availableMusicNotes
    }
    
    /// Returns a random note fromn the available notes for this instrument.
    var randomNote: UInt8 {
        return availableNotes.randomItem
    }
    
    var randomMusicNote: MusicNote {
        return availableMusicNotes.randomItem
    }
    
    // If any effect is applied on touches across the X axis.
    var xEffect: InstrumentTweak?
    
    // Any filters that are applied to the instrument
    var filter: InstrumentFilter? {
        didSet {
            // If it is already connected to an audio engine, reconnect it to apply the filter
            if let engine = audioEngine {
                connect(engine)
            }
        }
    }
    
    private var _defaultVelocity = ClampedInteger(clampedUserValueWithDefaultOf: 80)
    var defaultVelocity: Int {
        get { return _defaultVelocity.clamped }
        set { _defaultVelocity.clamped = newValue }
    }
    
    var normalizedVelocity: CGFloat {
        return CGFloat(defaultVelocity) / CGFloat(Constants.maxUserValue)
    }

    // The time before the sound is shutoff after the note is started.
    var fadeTime: Double {
        switch kind {
        case .electricGuitar:
            return 0.3
        case .bassGuitar:
            return 0.3
        default:
            return 0.3
        }
    }
    
    var extendedFadeTime: Double {
        switch kind {
        case .electricGuitar:
            return 1.5
        case .bassGuitar:
            return 2.0
        default:
            return 1.5
        }
    }
    
    init(kind: Kind) {
        self.kind = kind
    }
    
    
    var noteCount: Int {
        return availableNotes.count
    }

    // MARK: MIDI Playback
    
    func nearestAvailableNote(note: UInt8) -> UInt8 {
        
        if kind.allNotesAreAvailable { return note } // Any note is available
        
        var smallestDifference = Int.max
        var index = -1
        for i in 0..<availableNotes.count {
            
            let delta = abs(Int(availableNotes[i]) - Int(note))
            
            if delta < smallestDifference {
                smallestDifference = delta
                index = i
            }
        }
        
        if index >= 0 {
            return self.availableNotes[index]
        } else {
            return note
        }
    }
    
    func startPlaying(noteValue: UInt8, withVelocity velocity: UInt8 = 64, onChannel channel: UInt8 ) {
        sampler.startNote(noteValue, withVelocity: velocity, onChannel: channel)
    }

    func stopPlaying(noteValue: UInt8, onChannel channel: UInt8) {
        sampler.stopNote(noteValue, onChannel: channel)
    }

    /// Sets the pressure on a specific channel. Range is 0 -> 127
    func setPressure(_ pressure: UInt8, onChannel channel: UInt8) {
        sampler.sendPressure(pressure, onChannel: channel)
    }
    
    /// Sets the pitch bend on a specific channel. Range is 0 -> 16383
    func setPitchBend(_ pitchBend: UInt16, onChannel channel: UInt8) {
        sampler.sendPitchBend(UInt16(pitchBend), onChannel: channel)
    }
    
    // MARK: AudioEngineSetup
    
    func connect(_ engine: AudioPlayerEngine) {
        if sampler.engine != nil, let audioEngine = audioEngine {
            disconnect(audioEngine)
        }
        
        // Attach the player to the audio engine with an optional filter.
        engine.add(node: sampler, format: sampler.outputFormat(forBus: 0), audioUnitEffect: filter?.audioUnitEffect)
        
        if let sf2URL = kind.sf2URL {
            
            // Load from sound bank instrument (.sf2 file).
            do {
                let preset: UInt8 = 0
                try self.sampler.loadSoundBankInstrument(at: sf2URL,
                                                              program: preset,
                                                              bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                                              bankLSB: UInt8(kAUSampler_DefaultBankLSB))
            } catch {
                print("Failed to load \(sf2URL) \(error)")
            }
            
        } else {
            
            // Load from sample WAV files.
            let wavURLs = kind.wavURLs
            do {
                try sampler.loadAudioFiles(at: wavURLs)
                audioEngine = engine
            } catch {
                print("Failed to load \(wavURLs) \(error)")
            }
        }
    }
    
    func disconnect(_ engine: AudioPlayerEngine) {
        if sampler.engine != nil {
            engine.remove(node: sampler)
        }
    }
}


