// 
//  Image.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit

public class Image: _ExpressibleByImageLiteral, Equatable, Hashable {
    
    let path: String
    let description: String
    
    public required init(imageLiteralResourceName path: String) {
        self.path = path
        self.description = Image.parseDescription(from: path)
    }    
    
    public static func ==(lhs: Image, rhs: Image) -> Bool {
        return lhs.path == rhs.path
    }
    
    public var hashValue: Int {
        return path.hashValue
    }
    
    public var isEmpty: Bool {
        return path.characters.count == 0
    }

    static private func parseDescription(from path: String) -> String {
        var name = path
        if let atCharRange = path.range(of: "@") {
            name = path.substring(to: atCharRange.lowerBound)
        }
        else if let periodCharRange = path.range(of: ".") {
            name = path.substring(to: periodCharRange.lowerBound)
        }
        return name
    }
}

// MARK: Background image overlays

public enum Overlay : Int {
    case gridWithCoordinates
    case cosmicBus
    
    func image() -> Image {
        switch self {
        case .gridWithCoordinates:
            return Image(imageLiteralResourceName: "GridCoordinates")
        case .cosmicBus:
            return Image(imageLiteralResourceName: "CosmicBus")
        }
    }
}
