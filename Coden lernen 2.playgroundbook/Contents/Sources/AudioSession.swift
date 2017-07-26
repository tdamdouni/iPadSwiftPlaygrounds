//
//  AudioSession.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioPlaybackDelegate: class {
    func audioSession(_ session: AudioSession, isPlaybackBlocked: Bool)
}

/// The shared `AVAudioSession`.
private let session = AVAudioSession.sharedInstance()

class AudioSession {
    
    static let current = AudioSession()
    
    weak var delegate: AudioPlaybackDelegate?
    
    /// Returns `true` if audio playback is blocked.
    private(set) var isPlaybackBlocked = false
    
    /// Marks if the extension is currently in the background.
    private(set) var isInBackground = false
    
    private var notificationObservers = [Any]()
    
    private init() {
        let nc = NotificationCenter.default
        
        // Register for session notifications.
        let interrupted = nc.addObserver(forName: .AVAudioSessionInterruption, object: nil, queue: .main) { [weak self] notification in
            guard let info = notification.userInfo,
                let isInterrupted = info[AVAudioSessionInterruptionTypeKey] as? Bool else {
                return
            }
            
            let isPlayingOtherAudio = session.secondaryAudioShouldBeSilencedHint
            
            self?.audioSessionIsBlocked(isInterrupted || isPlayingOtherAudio)
            
            if isPlayingOtherAudio {
                self?.configureEnvironment(forSoloPlayback: false)
            }
        }
        
        let secondaryAudio = nc.addObserver(forName: .AVAudioSessionSilenceSecondaryAudioHint, object: nil, queue: .main) { [weak self] notification in
            guard let info = notification.userInfo,
                let isPlayingSecondaryAudio = info[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? Bool else {
                    return
            }
            
            // Update the current session if we are playing audio that is not associated with VoiceOver.
            if isPlayingSecondaryAudio && !UIAccessibilityIsVoiceOverRunning() {
                self?.audioSessionIsBlocked(true)
                self?.configureEnvironment(forSoloPlayback: false)
            }
        }
        
        let routeChanged = nc.addObserver(forName: .AVAudioSessionRouteChange, object: nil, queue: .main) { [weak self] _ in
            // When the route changes mark the session as unblocked
            // (this will fallback to match the users preferences).
            self?.audioSessionIsBlocked(false)
        }
        
        // Register for extension notifications.
        let inactive = nc.addObserver(forName: .NSExtensionHostDidEnterBackground, object: nil, queue: .main) { [weak self] _ in
            self?.isInBackground = true
            
            self?.audioSessionIsBlocked(true)
        }
        
        let active = nc.addObserver(forName: .NSExtensionHostWillEnterForeground, object: nil, queue: .main) { [weak self] _ in
            self?.isInBackground = false
            
            if !session.secondaryAudioShouldBeSilencedHint {
                self?.audioSessionIsBlocked(false)
            }
        }
        
        notificationObservers = [interrupted, secondaryAudio, routeChanged, active, inactive]
    }
    
    deinit {
        for observer in notificationObservers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func audioSessionIsBlocked(_ blocked: Bool) {
        isPlaybackBlocked = blocked
        
        delegate?.audioSession(self, isPlaybackBlocked: blocked || isInBackground)
    }
    
    func configureEnvironment(forSoloPlayback: Bool = false) {
        // Configure the audio environment.
        let category = forSoloPlayback ? AVAudioSessionCategorySoloAmbient : AVAudioSessionCategoryAmbient
        do {
            try session.setCategory(category)
            
            DispatchQueue(label: "com.LTC.AudioSession").async {
                let _ = try? session.setActive(true)
            }
        } catch {
            log(message: "Failed to configure audio environment \(error).")
        }
    }
}
