//
//  AVExtensions.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import AVFoundation

extension AVAsset {
    var identifier: String {
        return (self as? AVURLAsset)?.url.lastPathComponent ?? ""
    }
}

extension AVPlayerItem {
    var identifier: String {
        return asset.identifier
    }
    
    var remainingTime: Double {
        guard status == .readyToPlay else { return 0 }
        return CMTimeGetSeconds(duration) - CMTimeGetSeconds(currentTime())
    }
}

extension AVQueuePlayer {
    
    var isPlaying: Bool {
        return rate > 0
    }
    
    func append(_ asset: AVAsset) {
        insert(asset, after: nil)
    }
    
    @discardableResult
    func insert(_ asset: AVAsset, after trailingItem: AVPlayerItem?) -> AVPlayerItem {
        let item = AVPlayerItem(asset: asset)
        insert(item, after: trailingItem)
        
        return item
    }
}
