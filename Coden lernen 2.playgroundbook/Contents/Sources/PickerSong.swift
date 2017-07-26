//
//  PickerSong.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import AVFoundation

final class PickerSong {
    // MARK: Properties
    
    let sections: [AudioSection]
    
    var currentSection: AudioSection {
        return sections[currentSongIndex % sections.count]
    }
    
    private var currentSongIndex = 0
    
    // MARK: Initialization
    
    init() {
        let basePath = "CHAR_SELECT"
        
        let variations = ["CHAR_SELECT_A", "CHAR_SELECT_B"]
        let paths = variations.map { basePath + "/" + $0 }
        
        sections = paths.map { dir in
            let assets = SongAssets(subdirectory: dir)
            
            let intro = assets.orderedAssets(for: .intro).first!
            let outro = assets.orderedAssets(for: .outro).first!
            
            // Grab "A" or "B" from the directory name.
            let track = dir.uppercased().characters.last!
            let loop = assets.orderedAssets(for: "_\(track)_")
            
            return AudioSection(intro: intro, body: loop, outro: outro)
        }
    }
    
    func nextSection() -> AudioSection {
        // Increment the current index to get a different variation for the `nextSection()`.
        currentSongIndex += 1
        
        return currentSection
    }
}

extension PickerSong: Song {
    var mainSection: AudioSection {
        return currentSection
    }
}
