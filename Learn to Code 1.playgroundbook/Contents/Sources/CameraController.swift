// 
//  CameraController.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import SceneKit
import UIKit

final class CameraController {
    // MARK: Types
    
    enum ViewMode {
        case overhead, poster, movable
    }
    
    static let absoluteFovMax = 140.0
    
    // MARK: Properties
    
    unowned let scnView: SCNView
    
    /// The lowest yFov angle the camera is allowed to reach when zooming (most zoom).
    let minYFov: Double
    
    /// The largest yFov angle the camera is allowed to reach when zooming (least zoom).
    let maxYFov: Double
    
    let rootHandle = SCNNode()
    
    let camera: SCNCamera
    
    let cameraNode: SCNNode
    
    let orignialFOVy: Double

    let originalRotation: SCNVector4
    
    let originalCameraTransform: SCNMatrix4

    var mode: ViewMode = .movable

    var shouldSuppressGestureControl = false
    
    var trackball: Trackball
    
    var currentFOVy = 0.0

    // MARK: Initialization
 
    /// Registers for camera gesture recognizers.
    init?(view: SCNView) {
        guard let scene = view.scene else { return nil }
        guard let cameraHandle = scene.rootNode.childNode(withName: CameraHandleName, recursively: true) else { return nil }
        guard let cameraNode = scene.rootNode.childNode(withName: CameraNodeName, recursively: true) else { return nil }
        
        self.scnView = view
        self.cameraNode = cameraNode
        self.camera = cameraNode.camera!
        
        // Set the minimum and maximum FOV based on the original camera Fov.
        minYFov = camera.yFov * 0.5
        
        // The maximum should be constrained the the `absoluteFovMax` or the camera's initial Fov.
        let upperLimit = max(camera.yFov, CameraController.absoluteFovMax)
        maxYFov = min(camera.yFov * 1.5, upperLimit)
        
        rootHandle.name = CameraHandleName
        scene.rootNode.addChildNode(rootHandle)
        
        // Put the camera into the rootHandle's coordinate system
        cameraNode.transform = cameraHandle.convertTransform(cameraNode.transform, to: rootHandle)
        
        // Reparent the camera under the normalized `rootHandle`. 
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
        cameraNode.transform = SCNMatrix4Mult(cameraNode.transform, SCNMatrix4MakeRotation(yRotation, 0.0, -1.0, 0.0))
        
        // rotate the rootHandle to the proper y rotation
        rootHandle.eulerAngles.y = yRotation
        
        let radius = cameraNode.position.length()
        trackball = Trackball(center: scene.rootNode.position, radius: -radius, multiplier: 6.0, inRect: scnView.bounds, transform: rootHandle.transform)
        
        // Save the initial camera information.
        orignialFOVy = camera.yFov
        originalCameraTransform = cameraNode.transform
        originalRotation = rootHandle.rotation
        
        self.registerCameraGestureRecognizers()
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
        guard mode == .movable else { return }
        
        // SCNAction will rotation through the whole rotation
        let actionY = SCNAction.rotate(by: CGFloat(rotation), around: SCNVector3(0, 1, 0), duration: duration)
        actionY.timingMode = .easeInEaseOut
        rootHandle.runAction(actionY) {
            DispatchQueue.main.async {
                self.trackball.transform = self.rootHandle.transform
            }
        }
    }
    
    // MARK: Camera View Modes
    
    func switchToPosterView() {
        mode = .poster

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        
        rootHandle.position.y = 100
        rootHandle.rotation = SCNVector4Zero
        camera.yFov = 30
        cameraNode.transform = SCNMatrix4Identity
        
        SCNTransaction.commit()
    }
    
    func switchToOverheadView() {
        mode = .overhead
        
        // goal is a perceived value of xRot = -π/2.0 and yRot = 0.0
        // rootHandle.xrot = -(π/2.0 + cameraNode.eulerAngles.x)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0

        let xAngle = -(π/2.0 + cameraNode.eulerAngles.x)
        let xTransform = SCNMatrix4MakeRotation(xAngle, 1.0, 0.0, 0.0)
        rootHandle.transform = xTransform
        
        SCNTransaction.commit()
    }
    
    // MARK: Camera Adjustments
    
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
        
        camera.yFov = max(min(fov, maxYFov), minYFov)

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
        guard mode == .overhead else { return }
        mode = .movable
        
        camera.yFov = orignialFOVy
        rootHandle.transform = SCNMatrix4Identity
        rootHandle.rotation = originalRotation
        self.trackball.transform = self.rootHandle.transform
    }

    func resetCamera(duration: CFTimeInterval = 0.75) {
        mode = .movable
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        camera.yFov = orignialFOVy
        
        // Reset the handle.
        rootHandle.position.y = 0
        cameraNode.transform = originalCameraTransform
        
        SCNTransaction.commit()

        let delta = (originalRotation.y * originalRotation.w) - (rootHandle.rotation.y * rootHandle.rotation.w)
        let yRotation = SCNAction.rotate(by: CGFloat(delta), around: SCNVector3(0, 1, 0), duration: duration)
        yRotation.timingMode = .easeInEaseOut
        
        rootHandle.runAction(yRotation) {
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
            if yFov > maxYFov {
                let scale = yFov / maxYFov
                recognizer.scale = CGFloat(factor * scale)
            }
            if yFov < minYFov {
                let scale = yFov / minYFov
                recognizer.scale = CGFloat(factor * scale)
            }
            // zoomCamera clips yFov to between minYFov and maxYFov
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
