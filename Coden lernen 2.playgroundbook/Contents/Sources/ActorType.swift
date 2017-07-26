//
//  ActorType.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
import SceneKit

/// An enum used to group all the characters.
public enum ActorType: String {
    case byte
    case blu
    case hopper
    case expert
    case octet
    
    static var cases: [ActorType] = [
        .byte, .blu, .hopper, .expert, .octet
    ]
    
    var color: Color {
        switch self {
        case .byte, .octet: return .orange
        case .blu: return .blue
        case .hopper: return .green
        case .expert: return .red
        }
    }
    
    var directory: Asset.Directory {
        return .actor(self)
    }
    
    func sounds(for group: EventGroup) -> [SCNAudioSource] {
        return Asset.sounds(for: group, in: directory)
    }
    
    func animations(for group: EventGroup) -> [CAAnimation] {
        return Asset.animations(for: group, in: directory)
    }
    
    func createNode() -> SCNNode {
        // Attempt to find the actor's 'NeutralPose' as a "dae", fallback to look for "scn".
        guard let node = Asset.neutralPose(in: directory) ?? Asset.neutralPose(in: directory, fileExtension: "scn") else {
            fatalError("Could not load 'NeutralPose' from: \(directory.path).")
        }
        
        // Configure the node. 
        node.enumerateChildNodes { child, _ in
            child.castsShadow = true
            child.categoryBitMask = WorldConfiguration.shadowBitMask
        }

        return node
    }
    
    func resourceStub() -> String {
        switch self {
        case .byte, .octet:
            return ActorType.byte.rawValue.uppercased()
        default:
            return self.rawValue.uppercased()
            
        }
    }
    
    func name() -> String {
        if self == .byte, let languageCode = Locale.autoupdatingCurrent.languageCode, languageCode == "fr" {
            return ActorType.octet.rawValue
        }

        return self.rawValue
    }
}
