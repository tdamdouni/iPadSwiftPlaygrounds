// 
//  CharacterName.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import Foundation

public enum CharacterName: String {
    case byte
    case blu
    case hopper
    
    /// This ties the pubilc facing `CharacterName` with the internal `ActorType` used for all the characters.
    var type: ActorType {
        switch self {
        case .byte: return .byte
        case .blu: return .blu
        case .hopper: return .hopper
        }
    }
}
