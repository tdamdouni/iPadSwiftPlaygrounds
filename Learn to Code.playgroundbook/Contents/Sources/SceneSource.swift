// 
//  SceneSource.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit

// MARK: Proxy Classes

/*
 Proxy classes are used to substitute full unarchiving of SCN types.
 */

private class ProxyGeometry: SCNGeometry {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyMaterial: SCNMaterial {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyNode: SCNNode {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyAnimation: CAAnimation {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxySkinner: SCNSkinner {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

private class ProxyReferenceNode: SCNReferenceNode {
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
}

extension SCNSceneSource {
    
    
    func entry<T: AnyObject>(withID id: String, ofType type: T.Type) -> SCNNode? {
        guard let url = url, data = try? Data(contentsOf: url, options: .dataReadingMappedAlways) else { return nil }
        
        // Index based proxy unarchiving objects.
        let proxyUnarchivers: [AnyClass] = [
            ProxyGeometry.self,
            ProxyMaterial.self,
            ProxyNode.self,
            ProxyAnimation.self,
            ProxySkinner.self,
            ProxyReferenceNode.self,
            ProxySkinner.self
        ]
        
        let possibleTypes: [AnyClass] = [
            SCNGeometry.self,
            SCNMaterial.self,
            SCNNode.self,
            CAAnimation.self,
            SCNSkinner.self,
            SCNReferenceNode.self,
            SCNMorpher.self,
            SCNLight.self,
            SCNCamera.self,
        ]
        
        // Ensure `T` is a possible type.
        guard let typeIndex = possibleTypes.index(where: { $0 == type }) else { return nil }
        
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
        
        // Replace all other types with proxy unarchivers.
        for (index, proxyType) in proxyUnarchivers.enumerated() {
            guard index != typeIndex else { continue }
            
            let type: AnyClass = possibleTypes[index]
            unarchiver.setClass(proxyType, forClassName: NSStringFromClass(type))
        }
        
        let partialScene = unarchiver.decodeObject(forKey: NSKeyedArchiveRootObjectKey) as? SCNScene
        unarchiver.finishDecoding()
        
        return partialScene?.rootNode.childNode(withName: id, recursively: true)
    }
}
