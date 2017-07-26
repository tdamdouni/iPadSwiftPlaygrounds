//
//  AudioController.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

protocol Song {
    var mainSection: AudioSection { get }
}

final class AudioController: AudioSectionPlayerDelegate {
    /// The player responsible for background music.
    let backgroundAudio = AudioSectionPlayer()
    
    /// The song used when in the character picker.
    let pickerSong = PickerSong()
    
    private(set) var currentSong: Song?
    
    /// The type of actor that the music stem started with.
    private(set) var baseType = ActorType.loadDefault()
    
    /// The playlist for puzzle songs.
    private(set) var playlist = Playlist()
    
    var isPlaying: Bool {
        get {
            return backgroundAudio.isPlaying
        }
        
        set {
            backgroundAudio.isPlaying = newValue
        }
    }
    
    init() {
        backgroundAudio.delegate = self
    }
    
    /// Starts playing from the previously played song, or from the song 
    /// associated with the default `actorType`.
    func resumePlaying() {
        if let resumingSong = playlist.resumingSong() {
            currentSong = resumingSong
            
            backgroundAudio.transition(to: resumingSong.puzzleSection, playIntro: false)
        }
        else {
            let startingSong = playlist.firstSong(forType: baseType)
            currentSong = startingSong
            
            backgroundAudio.transition(to: startingSong.puzzleSection, playIntro: true)
        }
        
        backgroundAudio.isPlaying = Persisted.isBackgroundAudioEnabled
    }
    
    func startPuzzleSong(for type: ActorType) {
        guard baseType != type else {
            resumePlaying()
            return
        }
        
        let characterSong = playlist.firstSong(forType: type)
        currentSong = characterSong
        baseType = type
        
        backgroundAudio.transition(to: characterSong.puzzleSection, playOutro: false)
        
        // Clear the persisted track when starting a new type. 
        Persisted.resumingTrackIdentifier = nil
    }
    
    func playSuccess() {
        guard let song = currentSong as? PuzzleSong else { return }
        backgroundAudio.insert(song.congratulations, resumingAt: song.congratsResumingItem)
    }
    
    func endCurrentSong(maximumDelay delay: Double = 1.5) {
        guard let song = currentSong else { return }
        backgroundAudio.endCurrentSection(with: song.mainSection.outro, maximumDelay: delay)
        
        currentSong = nil
    }
    
    func transitionToCharacterPicker() {
        currentSong = pickerSong
        backgroundAudio.transition(to: pickerSong.nextSection())
    }
    
    func transitionFromSuccess() {
        // Transition away from an `insertedSection`.
        // (Congrats track plays as an inserted section)
        if backgroundAudio.insertedSection != nil, let song = currentSong {
            backgroundAudio.transition(to: song.mainSection, playOutro: false)
        }
    }
    
    // MARK: AudioLoopDelegate

    func audioSectionPlayerIsReadyForNextSection(_: AudioSectionPlayer) -> AudioSection {
        // If currently in the character picker, play the next picker section.
        if currentSong is PickerSong {
            return pickerSong.nextSection()
        }
        else {
            currentSong = playlist.nextSong()
            return currentSong!.mainSection
        }
    }
    
    func audioSectionPlayer(_: AudioSectionPlayer, isPlayingTrack track: String) {
        guard let currentSong = currentSong, currentSong is PuzzleSong &&
            currentSong.mainSection.containsTrack(matching: track) else { return }
        
        // Start from the current item if the puzzle ends right now.
        Persisted.resumingTrackIdentifier = track
    }
}
