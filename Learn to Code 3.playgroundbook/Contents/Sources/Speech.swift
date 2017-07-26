// 
//  Speech.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import AVFoundation

public enum SpeechAccent {
    
    case `default`, american, australian, british, irish, southAfrican
    
    var language: String {
        switch self {
        case .american:
            return "en-US"
        case .australian:
            return "en-AU"
        case .british:
            return "en-GB"
        case .irish:
            return "en-IE"
        case .southAfrican:
            return "en-ZA"
        default:
            return ""
        }
    }
}

public struct SpeechVoice {
    
    public var speed: Int
    public var pitch: Int
    public var accent: SpeechAccent
    
    static var defaultSpeed: Int { return 25 }
    static var defaultPitch: Int { return 50 }
    
    public init() {
        self.speed = SpeechVoice.defaultSpeed
        self.pitch = SpeechVoice.defaultPitch
        self.accent = .default
    }
    
    public init(accent: SpeechAccent) {
        self.speed = SpeechVoice.defaultSpeed
        self.pitch = SpeechVoice.defaultPitch
        self.accent = accent
    }
}

public class Speech {
    
    public init() {
        
    }
    
    // MARK: Properties
    
    private var _defaultVolume = ClampedInteger(clampedUserValueWithDefaultOf: 5)
    public var defaultVolume: Int {
        get { return _defaultVolume.clamped }
        set { _defaultVolume.clamped = newValue }
    }
    
    var normalizedVolume: CGFloat {
        return CGFloat(defaultVolume) / CGFloat(Constants.maxUserValue)
    }
    
    private var _defaultSpeed = ClampedInteger(clampedUserValueWithDefaultOf: 30)
    public var defaultSpeed: Int {
        get { return _defaultSpeed.clamped }
        set { _defaultSpeed.clamped = newValue }
    }
    
    var normalizedSpeed: CGFloat {
        return CGFloat(defaultSpeed) / CGFloat(Constants.maxUserValue)
    }
    
    private var _defaultPitch = ClampedInteger(clampedUserValueWithDefaultOf: 33)
    public var defaultPitch: Int {
        get { return _defaultPitch.clamped }
        set { _defaultPitch.clamped = newValue }
    }
    
    var normalizedPitch: CGFloat {
        return CGFloat(defaultPitch) / CGFloat(Constants.maxUserValue)
    }
    
    
    // MARK: Private Properties
    
    private var speechWords: [String] = []
    
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    // MARK: Initializers
    
    /**
     Speaks the provided text.
     */
    public func speak(_ text: String, voice: SpeechVoice = SpeechVoice()) {

        defaultSpeed = voice.speed
        defaultPitch = voice.pitch

        let volume = SpeechTweak.tweak(normalizedValue: normalizedVolume, forType: .volume)
        let rate = SpeechTweak.tweak(normalizedValue: normalizedSpeed, forType: .speed)
        let pitchMultiplier = SpeechTweak.tweak(normalizedValue: normalizedPitch, forType: .pitch)
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = rate
        utterance.volume = volume
        utterance.pitchMultiplier = pitchMultiplier
        if !voice.accent.language.isEmpty {
            utterance.voice = AVSpeechSynthesisVoice(language: voice.accent.language)
        }
        speechSynthesizer.speak(utterance)
        assessmentController?.append(.speak(text: text))

    }
    
    func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .word)
    }
}
