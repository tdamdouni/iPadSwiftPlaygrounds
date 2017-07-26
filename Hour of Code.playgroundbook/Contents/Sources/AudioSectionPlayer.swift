//
//  AudioLoop.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation
import AVFoundation

protocol AudioSectionPlayerDelegate: class {
    func audioSectionPlayer(_: AudioSectionPlayer, isPlayingTrack: String)
    func audioSectionPlayerIsReadyForNextSection(_: AudioSectionPlayer) -> AudioSection
}

extension AudioSectionPlayerDelegate {
    func audioSectionPlayer(_: AudioSectionPlayer, isPlayingTrack: String) {
        // Optional implementation.
    }
}

class AudioSectionPlayer {
    // MARK: Properties
    
    /// The cut-off percentage with which to enqueuing the next track.
    static let remainingItemPercentage = 0.75
    
    /// The amount to fade by for each `interval` callback.
    static let fadeIncrement: Float = 0.05
    
    static let baseVolume: Float = 0.7
    
    /// The time interval with which this loop updates.
    /// 5/10 - half a second interval.
    static let interval = CMTime(value: 5, timescale: 10)
    
    /// The main player responsible for playing sections.
    private let queue = AVQueuePlayer()
    
    /// A player with overlaps the `queue` for transition effects.
    private let transition = AVPlayer()
    
    /// The section that has been inserted (does not loop).
    private(set) var insertedSection: AudioSection?
    
    /// The current section which will loop until it is interrupted via
    /// a call to `insert(:resumingAt:)` or is replaced by `transition(to:)`.
    private(set) var currentSection: AudioSection?
    
    private var observer: Any = NSObject()
    
    weak var delegate: AudioSectionPlayerDelegate?
    
    // MARK: Computed Properties
    
    var isPlaying: Bool {
        get {
            return queue.isPlaying
        }
        
        set {
            // If requested to play, start the `currentSection`.
            if newValue {
                checkCurrentSection()
                if queue.items().isEmpty, let item = currentSection?.nextItem() {
                    queue.append(item)
                }
            }
            
            queue.rate = newValue ? 1.0 : 0
        }
    }
    
    /// Only fade the transition when not playing an inserted section.
    var shouldFadeTransition: Bool {
        return insertedSection == nil
    }
    
    // MARK: Initialization
    
    init() {
        queue.volume = AudioSectionPlayer.baseVolume
        
        let observerQueue = DispatchQueue(label: "AudioLoop.observerQueue")
        observer = queue.addPeriodicTimeObserver(forInterval: AudioSectionPlayer.interval, queue: observerQueue, using: observeCurrentItem)
    }
    
    deinit {
        queue.removeTimeObserver(observer)
    }
    
    /// Inserts the section immediately after the queue's current item, plays the entire section,
    /// and returns to the `resumingItem` in the original loop.
    /// Returns the remaining number of seconds before the transition will occur.
    @discardableResult
    func insert(_ section: AudioSection, resumingAt: AVURLAsset? = nil) -> Double {
        insertedSection = section
        
        playTransition(section.transition)
        
        if let resumingAsset = resumingAt {
            // Progress the tracks in-between the end of the inserted section and the
            // `resumingItem` to the end of the `currentSection`'s loop.
            let loop = currentSection?.bodyURLs ?? []
            for item in loop {
                guard item != resumingAsset.url else { break }
                currentSection?.loopNextItem()
            }
        }
        
        return remainingTimeInCurrentLoop()
    }
    
    /// Transitions from the current section to the provided section.
    /// Returns the remaining number of seconds before the transition will occur.
    @discardableResult
    func transition(to section: AudioSection, playOutro: Bool = true, playIntro: Bool = false) -> Double {
        insertedSection = nil
        
        // Add the outro
        if playOutro, let outro = currentSection?.outro {
            playTransition(outro)
        }
        
        // Determine the amount of time remaining for the `currentItem`.
        let remainingTime = remainingTimeInCurrentLoop()
        
        currentSection = section
        
        // If the queue is not currently playing, remove old items.
        if !isPlaying {
            queue.removeAllItems()
        }
        
        // Add a track from the next section.
        if playIntro, let intro = section.intro {
            queue.append(intro)
        }
        else if let item = currentSection?.nextItem() {
            queue.append(item)
        }
        
        return remainingTime
    }
    
    /// Fades out the current item playing an optional overlay after the current item or
    /// the `maximumDelay`.
    func endCurrentSection(with overlay: AVAsset? = nil, maximumDelay: Double = 1.5) {
        currentSection = nil
        
        // Delay for the remaining time, or for the `maximumDelay`.
        let delay = min(remainingTimeInCurrentLoop(), maximumDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.queue.removeAllItems()
            self.playTransition(overlay)
        }
    }
    
    /// Plays the item in a separate player to transition content.
    private func playTransition(_ asset: AVAsset?) {
        guard isPlaying, let asset = asset else { return }
        
        // Create a new item to play the asset.
        transition.replaceCurrentItem(with: AVPlayerItem(asset: asset))
        transition.volume = AudioSectionPlayer.baseVolume
        transition.playImmediately(atRate: 1.0)
    }
    
    // MARK: Observing
    
    func observeCurrentItem(time: CMTime) {
        let duration = queue.currentItem?.duration ?? AudioSectionPlayer.interval
        let elapsedRatio = CMTimeGetSeconds(time) / CMTimeGetSeconds(duration)
        
        // Check if it's time to append another item to the queue.
        if elapsedRatio > AudioSectionPlayer.remainingItemPercentage && queue.items().count == 1 {
            
            // Grab a new `currentSection` if the current one isFinished.
            checkCurrentSection(shouldRequestIfNil: false)
            
            // Work through inserted items first.
            if let insertedItem = insertedSection?.nextItem() {
                queue.append(insertedItem)
            }
            else if let nextItem = currentSection?.nextBodyItem() {
                queue.append(nextItem)
            }
            
            // Notify the delegate about the current item.
            if let currentTrack = queue.currentItem?.identifier {
                delegate?.audioSectionPlayer(self, isPlayingTrack: currentTrack)
            }
        }
        
        // Fade out the transition item.
        if shouldFadeTransition, transition.currentItem != nil {
            transition.volume = max(0, transition.volume - AudioSectionPlayer.fadeIncrement)
        }
    }
    
    /// Calculates the time left adding the time for each item in the `queue`.
    func remainingTimeInCurrentLoop() -> Double {
        return queue.items().reduce(0) { totalTime, item in
            return totalTime + item.remainingTime
        }
    }
    
    /// Checks if the current section has remaining tracks to play, or requests a 
    /// new `currentSection`.
    private func checkCurrentSection(shouldRequestIfNil: Bool = true) {
        // Ready if there is no `currentSection` or it is finished.
        let isReadyForNextSection = currentSection?.isFinished ?? shouldRequestIfNil
        
        if isReadyForNextSection {
            currentSection = delegate?.audioSectionPlayerIsReadyForNextSection(self)
        }
    }
}

