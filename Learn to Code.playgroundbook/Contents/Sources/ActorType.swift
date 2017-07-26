// 
//  ActorType.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

/// An enum used to group all the characters.
enum ActorType: String {
    case byte
    case blu
    case hopper
    case expert
    
    var resourceFilePathPrefix: String {
        let pathPrefix = WorldConfiguration.charactersDir
        switch self {
        case .byte: return pathPrefix + "Basso/"
        case .hopper: return pathPrefix + "Grasshopper/"
        case .blu: return pathPrefix + "WaterDrop/"
        case .expert:  return pathPrefix + "Muffin/"
        }
    }
    
    func createNode() -> SCNNode {
        let fileManager = FileManager.default()
        let sceneName = self.resourceFilePathPrefix + "NeutralPose"
        let actorSceneURL: URL
        if let daeURL = Bundle.main().urlForResource(sceneName, withExtension: "dae") where fileManager.fileExists(atPath: daeURL.path!) {
            actorSceneURL = daeURL
        }
        else {
            actorSceneURL = Bundle.main().urlForResource(sceneName, withExtension: "scn")!
        }

        let actorScene: SCNScene
        do {
            actorScene = try SCNScene(url: actorSceneURL, options: nil)
        }
        catch {
            log(message:"Could not load: \(sceneName). \(error)")
            fatalError("Could not load: \(sceneName). \(error)")
        }
        
        let node = actorScene.rootNode.childNodes[0]
        
        // Configure the node. 
        node.enumerateChildNodes { child, _ in
            child.castsShadow = true
            child.categoryBitMask = WorldConfiguration.shadowBitMask
        }

        return node
    }
}
