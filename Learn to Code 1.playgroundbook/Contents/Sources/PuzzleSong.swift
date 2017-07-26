//
//  PuzzleSong.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import AVFoundation

struct PuzzleSong {
    // MARK: Properties 
    
    let identifier: String
    
    var puzzleSection: AudioSection
    
    let congratulations: AudioSection
    
    let congratsResumingURL: URL
    
    var congratsResumingItem: AVURLAsset {
        return AVURLAsset(url: congratsResumingURL)
    }
    
    // MARK: Initialization
    
    init(type: ActorType) {
        let dir = type.rawValue.uppercased()
        self.init(subdirectory: dir)
    }
    
    init(subdirectory: String) {
        identifier = subdirectory
        
        // Load in all the assets.
        let assets = SongAssets(subdirectory: subdirectory)
        
        // Intro/ Outro
        let intro = assets.orderedAssets(for: .intro).first!
        let outro = assets.orderedAssets(for: .outro).first!
        
        // Puzzle Segments
        let puzzleItems = assets.orderedAssets(for: .puzzle)
        self.puzzleSection = AudioSection(intro: intro, body: puzzleItems, outro: outro)
        
        // Congratulations
        var congratsItems = assets.orderedAssets(for: .congrats)
        let congratsOutro = congratsItems.removeFirst {
            return SongAssets.match($0.lastPathComponent, to: .congratsTransition)
        }!
        
        let congratsTransition = congratsItems.removeFirst {
            return SongAssets.match($0.lastPathComponent, to: .congratsFX)
        }!
        
        self.congratulations = AudioSection(body: congratsItems, outro: congratsOutro, transition: congratsTransition)
        
        // Find the resuming item suffix from the outro identifier.
        let songIdentifier = NSString(string: congratsOutro.lastPathComponent)
        let endIndex = songIdentifier.length
        let suffixRange = NSRange(location: endIndex - 6, length: 6)
        let resumingSuffix = songIdentifier.substring(with: suffixRange)
        
        self.congratsResumingURL = puzzleItems.first(where: {
            return $0.lastPathComponent.hasSuffix(resumingSuffix)
        })!
    }
}

extension PuzzleSong: Song {
    var mainSection: AudioSection {
        return puzzleSection
    }
}

extension PuzzleSong: Equatable {}

func ==(lhs: PuzzleSong, rhs: PuzzleSong) -> Bool {
    return lhs.identifier == rhs.identifier
}

extension Array {
    
    mutating func removeFirst(where predicate: (Element) -> Bool) -> Element? {
        guard let i = index(where: predicate) else { return nil }
        return remove(at: i)
    }
    
    func element(at index: Int) -> Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}

