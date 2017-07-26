//
//  Playlist.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import GameplayKit
import Foundation

struct Playlist {
    
    static let alternateSongsBasePath = "ALTERNATE_SONGS/"
    
    static let alternateSongsRange = 1...9
    
    // MARK: Properties 
    
    let characterSongs: [ActorType: PuzzleSong]
    
    let alternateSongs: [PuzzleSong]
    
    var pendingSongs = [PuzzleSong]()
    
    var currentSong: PuzzleSong
    
    // MARK: Initialization
    
    init() {
        characterSongs = ActorType.cases.reduce([ActorType: PuzzleSong]()) { songs, type in
            var songs = songs
            songs[type] = PuzzleSong(type: type)
            return songs
        }
        
        alternateSongs = Playlist.alternateSongsRange.map { index in
            let path = Playlist.alternateSongsBasePath + "ALT_\(index)"
            return PuzzleSong(subdirectory: path)
        }
        currentSong = alternateSongs.first!

        resetPendingSongs()
        
        let playedSongs = Persisted.playedSongIdentifiers
        pendingSongs = pendingSongs.filter {
            return !playedSongs.contains($0.identifier)
        }
    }
    
    private mutating func resetPendingSongs() {
        let randomSource = GKRandomSource.sharedRandom()
        let shuffledSongs = randomSource.arrayByShufflingObjects(in: alternateSongs) as! [PuzzleSong]
        
        pendingSongs = shuffledSongs
    }
    
    // MARK: Song Accessors
    
    mutating func firstSong(forType type: ActorType) -> PuzzleSong {
        resetPendingSongs()
        
        return characterSongs.first {
            return $0.key == type
        }!.value
    }
    
    mutating func nextSong() -> PuzzleSong {
        if pendingSongs.isEmpty {
            resetPendingSongs()
            Persisted.playedSongIdentifiers = []
        }
        
        // Persist the played songs so that they are not played again.
        Persisted.playedSongIdentifiers = alternateSongs.flatMap { altSong in
            return pendingSongs.contains(altSong) ? nil : altSong.identifier
        }
        
        currentSong = pendingSongs.removeFirst()
        return currentSong
    }
    
    mutating func resumingSong() -> PuzzleSong? {
        guard let identifier = Persisted.resumingTrackIdentifier else { return nil }
        let predicate: (PuzzleSong) -> Bool = { $0.puzzleSection.containsTrack(matching: identifier) }
        
        var song = pendingSongs.removeFirst(where: predicate)

        // Update the current song, or search it if the track has not been found.
        if let song = song {
            currentSong = song
        }
        else if currentSong.puzzleSection.containsTrack(matching: identifier)  {
            song = currentSong
        }
        
        // If the song could not be found in the pending songs, check the character songs.
        if song == nil {
            song = characterSongs.values.first(where: predicate)
        }
        
        #if DEBUG
        precondition(song != nil, "Failed to lookup saved track: \(identifier)")
        #endif
        
        // Roll the song forward to start at the `identifier`.
        song?.puzzleSection.fastForward(to: identifier)
        
        return song
    }
}
