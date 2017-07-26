// 
//  HelperExtensions.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import SpriteKit

public extension String {

    /// Splits the String into each character you see, returned as an Array of Strings.
    /* 
        Note: This cannot simply be implemented as self.characters.map { String($0) } since some emojis are sequences of characters e.g. a face with a skin tone modifer i.e. composed character sequences.
    */
    public func componentsByCharacter() -> [String] {
        
        var sequences = [String]()
        let range = self.startIndex ..< self.endIndex
        self.enumerateSubstrings(in: range, options: .byComposedCharacterSequences) {sequence,_,_,_ in
            if let sequence = sequence {
                sequences.append(sequence)
            }
        }
        return sequences
    }
    
    /// Returns a random composed character sequence as a String.
    public var randomCharacter: String {
        
        var randomString = ""
        let characterStrings = self.componentsByCharacter()
        
        if characterStrings.count > 0 {
            let index = Int(arc4random_uniform(UInt32(characterStrings.count)))
            randomString = characterStrings[index]
        }
        return randomString
    }
    
    /// Returns the number of characters in the string.
    public var numberOfCharacters: Int {
        return self.componentsByCharacter().count
    }
    
    // Note: used in assessment but always hidden from the user.
    /// Returns the string without any whitespace characters.
    public var withoutWhitespace: String {
        let separatedComponents = self.components(separatedBy: .whitespaces)
        return separatedComponents.joined()
    }
    
    /// Returns the String with the characters reversed.
    public func reversed() -> String {
        
        let reversedCharacters = self.componentsByCharacter().reversed()
        return reversedCharacters.joined()
    }
    
    /// Returns the String the with characters randomly shuffled.
    public func shuffled() -> String {
        
        let shuffledCharacters = self.componentsByCharacter().shuffled()
        return shuffledCharacters.joined()
    }
}

extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        return clamped(min: range.lowerBound, max: range.upperBound)
    }
    
    func clamped(min: Int, max: Int) -> Int {
        return Swift.max(min, Swift.min(max, self))
    }
}

extension Point {
    
    /// Return the distance from another point.
    public func distance(from: Point) -> Double {
        
        let distanceVector = Point(x: from.x - self.x, y: from.y - self.y)
        return Double(sqrt(Double(distanceVector.x * distanceVector.x) + Double(distanceVector.y * distanceVector.y)))
    }
}

// In this app we are clamping the values the user can enter to a defined range to be more approachable. This extension is used to apply it consistently across the app.
extension ClampedInteger {
    init(clampedUserValueWithDefaultOf integer: Int) {
        self.init(integer, in: Constants.userValueRange)
    }
}

public extension Array {

    /// Return a random index into the array.
    var randomIndex: Int {
        return Int(arc4random_uniform(UInt32(self.count)))
    }
    
    /// Return a random item from the array.
    var randomItem: Element {
        return self[self.randomIndex]
    }
    
    /// Shuffle the items of the array in-place.
    mutating func shuffle() {
        for i in 0..<(count - 1) {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
    
    /// Return a shuffled copy of the array.
    func shuffled() -> [Element] {
        var list = self
        list.shuffle()
        return list
    }
}

struct Constants {
    static let userValueRange: ClosedRange<Int> = 0...100
    
    static var maxUserValue: Int {
        return userValueRange.upperBound
    }
}

public extension UIImage {

    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        
        draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage ?? self
    }

}

extension CGSize {
    
    /// Returns a size that is fits this size within a given size, while preserving this size's aspect ratio.
    public func fit(within: CGSize) -> CGSize  {
        
        let ratio = width > height ?  (height / width) : (width / height)
        
        if width >= height {
            return CGSize(width: within.width, height: within.width * ratio)
        }
        else {
            return CGSize(width: within.height * ratio, height: within.height)
        }
    }
}


extension UIColor {
    
    var redComponent: CGFloat {
        var component = CGFloat()
        getRed(&component, green: nil, blue: nil, alpha: nil)
        return component
    }

    var greenComponent: CGFloat {
        var component = CGFloat()
        getRed(nil, green: &component, blue: nil, alpha: nil)
        return component
    }
    
    var blueComponent: CGFloat {
        var component = CGFloat()
        getRed(nil, green: nil, blue: &component, alpha: nil)
        return component
    }
    
    var alphaComponent: CGFloat {
        var component = CGFloat()
        getRed(nil, green: nil, blue: nil, alpha: &component)
        return component
    }

}


extension SKScene {
    var center: CGPoint { return CGPoint(x: size.width / 2, y: size.height / 2) }
}
