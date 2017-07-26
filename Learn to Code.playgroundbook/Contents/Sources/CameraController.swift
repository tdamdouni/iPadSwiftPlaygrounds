// 
//  CameraController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit
import UIKit

class CameraController {
    unowned let scnView: SCNView
    
    var originalRotation = SCNVector4Zero
    
    var shouldSuppressGestureControl = false
    
    var orignialFOVy = 0.0
    var currentFOVy = 0.0
    let minFOVy = 10.5
    let maxFOVy = 55.0
    
    var rootHandle = SCNNode()
    var cameraNode = SCNNode()

    var trackball: Trackball = {
        // this is just to satisfy the init,the real one is ceated in this init sharedInit
        var tb = Trackball(center: SCNVector3(), radius: 0.0, multiplier: 1.0, inRect: CGRect(), transform: SCNMatrix4Identity)
        return tb
    }()

    // MARK: Initialization
    
    func sharedInit(_ scene: SCNScene) {
        guard let cameraHandle = scene.rootNode.childNode(withName: CameraHandleName, recursively: true) else {
            return
        }
        guard let camera = scene.rootNode.childNode(withName: CameraNodeName, recursively: true) else {
            return
        }
        
        cameraNode = camera
        
        rootHandle.name = CameraHandleName
        scene.rootNode.addChildNode(rootHandle)
        
        // Put the camera into the rootHandle's coordinate system
        cameraNode.transform = cameraHandle.convertTransform(cameraNode.transform, to: rootHandle)

        // reparent the camer
        rootHandle.addChildNode(cameraNode)
        cameraHandle.removeFromParentNode()
        
        // BIG PICTURE:
        // pull the y axis rotation out of the camera
        // move the camera to zero degrees around the y axis
        // apply the y rotation to the rootHandle
        
        // grab the position
        var position = cameraNode.position
        // project it into the x/z plane
        position.y = 0.0
        // find the angle
        let yRotation = atan2(position.x, position.z)
        
        // move the camera to the zero rotation spot by applying a negative y rotation
        camera.transform = SCNMatrix4Mult(camera.transform, SCNMatrix4MakeRotation(yRotation, 0.0, -1.0, 0.0))
        
        // rotate the rootHandle to the proper y rotation
        rootHandle.eulerAngles.y = yRotation
        
        let radius = cameraNode.position.length()
        trackball = Trackball(center: scene.rootNode.position, radius: -radius, multiplier: 6.0, inRect: scnView.bounds, transform: rootHandle.transform)
        
        registerCameraGestureRecognizers()
    }
    
    /// Registers for camera gesture recognizers.
    init?(view: SCNView) {
        self.scnView = view
        
        guard let scene = view.scene else {
            return nil
        }
        
        sharedInit(scene)
    }
    
    init?(scene: SCNScene) {
        self.scnView = SCNView()
        sharedInit(scene)
    }
    
    /// Saves the camera's starting info.
    func setInitialCameraPosition() {
        originalRotation = rootHandle.rotation
        orignialFOVy = cameraNode.camera!.yFov
    }
    
    // MARK: Gesture Recognizers

    func registerCameraGestureRecognizers() {
        scnView.isUserInteractionEnabled = true
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(resetCameraAction(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        scnView.addGestureRecognizer(doubleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCameraAction(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomCameraAction(_:)))
        scnView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: Flyovers
    
    /// Returns the duration the camera will take during it's rotation.
    func performShortestFlyover(toFace direction: SCNFloat) -> Double {
        let deltaRot = angleBetweenCamera(and: direction)
        
        // Adjusts duration per radian rotated.
        let duration = abs(Double(deltaRot)) * 0.55
        performFlyover(withRotation: deltaRot, duration: duration)
        
        return duration
    }
    
    /// Returns the duration and rotation the camera will take during it's rotation.
    func performFlyover(toFace direction: SCNFloat) -> (duration: Double, rotation: Float) {
        let deltaRot = angleBetweenCamera(and: direction)
        let longestRot = deltaRot < 0 ? deltaRot + 2 * π : deltaRot - 2 * π
        
        // Adjusts duration per radian rotated.
        let duration = abs(Double(longestRot)) * 0.25
        performFlyover(withRotation: longestRot, duration: duration)
        
        return (duration, longestRot)
    }
    
    func performFlyover(withRotation rotation: SCNFloat, duration: Double) {
        // SCNAction will rotation through the whole rotation
        let actionY = SCNAction.rotate(byAngle: CGFloat(rotation), aroundAxis: SCNVector3(0, 1, 0), duration: duration)
        actionY.timingMode = .easeInEaseOut
        rootHandle.run(actionY) {
            DispatchQueue.main.async {
                self.trackball.transform = self.rootHandle.transform
            }
        }
    }
    
    // MARK: Camera Work
    
    func switchToOverheadView() {
        // this needs to happen outside of a transaction
        // so that it takes effect immediately
        
        // goal is a perceived value of xRot = -π/2.0 and yRot = 0.0
        // rootHandle.xrot = -(π/2.0 + cameraNode.eulerAngles.x)
        
        let xAngle = -(π/2.0 + cameraNode.eulerAngles.x)
        let xTransform = SCNMatrix4MakeRotation(xAngle, 1.0, 0.0, 0.0)
        
        rootHandle.transform = xTransform
        zoomCamera(toYFov: 32, duration: 0) // 32 seems like a good fit. Increase value to zoom out.
    }
    
    /// Returns the shortest angle between the camera and the supplied direction.
    func angleBetweenCamera(and direction: SCNFloat) -> SCNFloat {
        // Use the presentation node to ensure the rotation info is up to date.
        let delta = direction.capPhase() - (rootHandle.presentation.rotation.y * rootHandle.presentation.rotation.w)
        return atan2(sin(delta), cos(delta))
    }

    func zoomCamera(toYFov fov: Double, duration: Double = 1.0, completionHandler: (() -> Void)? = nil) {
        guard let camera = cameraNode.camera else { return }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        
        camera.yFov = max(min(fov, maxFOVy), minFOVy)
        
        SCNTransaction.completionBlock = completionHandler
        SCNTransaction.commit()
    }
    
    private func adjustCameraPitch(toRadians pitch: Float, duration: Double = 0.4, completionHandler: (() -> Void)? = nil) {
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = duration
        
        // -angle: underworld
        // +angle: above world
        // Control the pitch so it does not pass the zero point of the level.
        rootHandle.eulerAngles.x = pitch //min(max(pitch, -π / 2), -0.2)
        
        SCNTransaction.completionBlock = completionHandler
        SCNTransaction.commit()
    }
    
    /// Adjusts the arc angle for the camera moving around the world.
    private func adjustCameraArc(toRadians arc: Float, duration: Double = 0.4, completionHandler: (() -> Void)? = nil) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        
        rootHandle.eulerAngles.y = arc
        
        SCNTransaction.completionBlock = completionHandler
        SCNTransaction.commit()
    }

    func resetFromVoiceOver() {
        if let camera = cameraNode.camera {
            camera.yFov = orignialFOVy
        }
        rootHandle.transform = SCNMatrix4Identity
        rootHandle.rotation = originalRotation
        self.trackball.transform = self.rootHandle.transform
    }

    func resetCamera() {

        guard let camera = cameraNode.camera else { return }
        
        let duration: CFTimeInterval = 0.75
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        camera.yFov = orignialFOVy
        SCNTransaction.commit()

        let delta = (originalRotation.y * originalRotation.w) - (rootHandle.rotation.y * rootHandle.rotation.w)
        let actionY = SCNAction.rotate(byAngle: CGFloat(delta), aroundAxis: SCNVector3(0, 1, 0), duration: duration)
        actionY.timingMode = .easeInEaseOut
        rootHandle.run(actionY) {
            self.trackball.transform = self.rootHandle.transform
        }
    }
    
    // MARK: Gesture Recognizers
    
    @objc func panCameraAction(_ recognizer: UIPanGestureRecognizer) {
        guard shouldSuppressGestureControl == false else { return }
        switch recognizer.state {
        case .began:
            trackball.startingPoint = recognizer.location(in: self.scnView)
        case .changed:
            let matrix = trackball.transformFor(recognizer.location(in: self.scnView))
            SCNTransaction.begin()
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            rootHandle.transform = matrix
            SCNTransaction.commit()
        case .ended:
            let matrix = trackball.transformFor(recognizer.location(in: self.scnView))
            SCNTransaction.begin()
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
            rootHandle.transform = matrix
            SCNTransaction.commit()
            trackball.finish(recognizer.location(in: self.scnView))
        default:
            break
        }
        return
    }
    
    @objc func zoomCameraAction(_ recognizer: UIPinchGestureRecognizer) {
        guard shouldSuppressGestureControl == false else { return }
        guard let camera = cameraNode.camera else { return }
        
        switch recognizer.state {
        case .began:
            currentFOVy = camera.yFov
        case .changed:
            let factor = Double(recognizer.scale)
            let yFov = currentFOVy / factor
            // make sure the scale is reset so if we change directions after
            // zooming past the yFOV we reverse the scale
            if yFov > maxFOVy {
                let scale = yFov / maxFOVy
                recognizer.scale = CGFloat(factor * scale)
            }
            if yFov < minFOVy {
                let scale = yFov / minFOVy
                recognizer.scale = CGFloat(factor * scale)
            }
            // zoomCamera clips yFov to between minFOVy and maxFOVy
            zoomCamera(toYFov: yFov, duration: 0.0)
        default:
            break
        }
    }
    
    @objc func resetCameraAction(_: UITapGestureRecognizer) {
        guard shouldSuppressGestureControl == false else { return }
        resetCamera()
    }
}
