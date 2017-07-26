//
//  AudioSection.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import AVFoundation

struct AudioSection {
    typealias Asset = AVURLAsset
    
    /// The initial segment to a section.
    var introURL: URL?
    
    /// The items which will continually loop until the section is exited.
    var bodyURLs: [URL]
    
    /// The final segment to play when transitioning from a segment.
    var outroURL: URL?
    
    /// Transition segment used to overlay other tracks when moving into, and out of this section.
    var transitionURL: URL?
    
    var isFinished: Bool {
        return bodyURLs.isEmpty
    }
    
    init(intro: URL? = nil, body: [URL], outro: URL? = nil, transition: URL? = nil) {
        precondition(!body.isEmpty, "Invalid section: Must contain loop items.")
        
        self.introURL = intro
        self.bodyURLs = body
        self.outroURL = outro
        self.transitionURL = transition
    }
    
    /// Loops the first item to the end of the body array.
    mutating func loopNextItem() {
        let url = bodyURLs.removeFirst()
        bodyURLs.append(url)
    }
    
    mutating func nextBodyItem() -> Asset? {
        guard !isFinished else { return nil }
        
        let url = bodyURLs.removeFirst()
        return Asset(url: url)
    }
    
    mutating func nextItem() -> Asset? {
        if bodyURLs.isEmpty{
            guard let end = outroURL else { return nil }
            outroURL = nil
            
            return Asset(url: end)
        }
        else {
            // Pull from the body of the section.
            let first = bodyURLs.removeFirst()
            return Asset(url: first)
        }
    }
    
    func assets(includingOutro: Bool = false) -> [Asset] {
        var assets = [URL]()
        
        if let intro = introURL {
            assets.append(intro)
        }
        
        assets += bodyURLs
        
        if includingOutro, let outro = outroURL {
            assets.append(outro)
        }
        
        return assets.map { Asset(url: $0) }
    }
    
    func containsTrack(matching identifier: String) -> Bool {
        return bodyURLs.contains { url in
            return url.lastPathComponent == identifier
        }
    }
}

extension AudioSection {
    // MARK: Asset Access 
    
    var intro: Asset? {
        guard let url = introURL else { return nil }
        return Asset(url: url)
    }
    
    var outro: Asset? {
        guard let url: URL = outroURL else { return nil }
        return Asset(url: url)
    }
    
    /// Computes the last item that will be played for this section.
    var end: Asset {
        let url: URL = outroURL ?? bodyURLs.last!
        return Asset(url: url)
    }
    
    var transition: Asset? {
        guard let url = transitionURL else { return nil }
        return Asset(url: url)
    }
}

extension AudioSection {
    
    /**
     Progresses through the section body until reaching the provided identifier.
     Returns `true` if the `identifier` could be found in this section.
     
     - parameters:
        - appendingTracks: Determines if the skipped tracks should be added to the end of the body.
    */
    @discardableResult
    mutating func fastForward(to identifier: String, appendingTracks: Bool = false) -> Bool {
        var skippedTracks = [URL]()
        while let next = nextItem(), next.identifier != identifier {
            skippedTracks.append(next.url)
        }
                
        // Append the skipped tracks to the end.
        if appendingTracks {
            bodyURLs += skippedTracks
        }
        
        return !skippedTracks.isEmpty
    }
}
