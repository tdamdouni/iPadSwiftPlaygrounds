//
//  EnvironmentSounds.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import GameplayKit
import AVFoundation

struct EnvironmentSoundsSong {

    static let mainSection: AudioSection = {
        let directory = Asset.Directory.environmentSound.path + "Song"
        let assets = Bundle.main.urls(forResourcesWithExtension: SongAssets.fileExtension, subdirectory: directory) ?? []
        
        return AudioSection(body: assets)
    }()
    
    static func shuffledSection() -> AudioSection {
        var newSection = mainSection
        
        let randomSource = GKRandomSource.sharedRandom()
        let shuffledURLs = randomSource.arrayByShufflingObjects(in: newSection.bodyURLs) as! [URL]
        newSection.bodyURLs = shuffledURLs
        
        return newSection
    }
}
