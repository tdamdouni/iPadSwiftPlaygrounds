// 
//  CharacterName.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import Foundation

public enum CharacterName: String {
    case byte
    case blu
    case hopper
    case octet
    
    /// This ties the pubilc facing `CharacterName` with the internal `ActorType` used for all the characters.
    var type: ActorType {
        switch self {
        case .byte: return .byte
        case .blu: return .blu
        case .hopper: return .hopper
        case .octet: return .octet
        }
    }
}
