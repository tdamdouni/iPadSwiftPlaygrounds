//
//  SongAssets.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation

struct SongAssets {
    static let fileExtension = "m4a"

    // MARK: Types
    
    enum Identifier: String {
        case intro = "_In1"
        case outro = "_Out1"
        case puzzle = "_PUZL_"
        case transition = "_TRANS_FX"
        case congrats = "_CONGR"
        case congratsTransition = "_TRANS_CONGR"
        case congratsFX = "_CONGR_FX"
    }
    
    static func match(_ id: String, to assetId: Identifier) -> Bool {
        return id.containsCaseInsensitive(assetId.rawValue)
    }
    
    // MARK: Properties
    
    let urls: [URL]
    
    // MARK: Initialization
    
    init(subdirectory: String) {
        let directory = Asset.Directory.music  + subdirectory
        self.urls = Bundle.main.urls(forResourcesWithExtension: SongAssets.fileExtension, subdirectory: directory) ?? []
    }
    
    init(urls: [URL]) {
        self.urls = urls
    }
    
    func orderedAssets(for id: Identifier) -> [URL] {
        return orderedAssets(for: id.rawValue)
    }
    
    func orderedAssets(for search: String) -> [URL] {
        return urls.filter { url in
            let name = url.lastPathComponent
            return name.containsCaseInsensitive(search)
        }.sorted { i1, i2 in
            let id1 = i1.lastPathComponent
            let id2 = i2.lastPathComponent
            return id1.compare(id2, options: .numeric) == .orderedAscending
        }
    }
}

extension String {
    func containsCaseInsensitive(_ subString: String) -> Bool {
        return uppercased().contains(subString.uppercased())
    }
}
