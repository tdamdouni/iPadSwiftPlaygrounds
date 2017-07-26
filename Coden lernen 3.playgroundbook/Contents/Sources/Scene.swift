// 
//  Scene.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import PlaygroundSupport

/// The scene is the container for all of the tools and graphics that are created.
public class Scene: PlaygroundRemoteLiveViewProxyDelegate {
    
    var selectedTool: Tool? = nil
    
    let size = CGSize(width: 1024, height: 1024)
    
    var toolInfo: [String : Tool]?  {
        return tools.reduce([String : Tool]()) { (toolMap, tool) in
            var returnMap = toolMap
            returnMap [tool.name] = tool
            return returnMap
        }
    }
    
    /// The collection of tools you have created to modify the scene.
    public var tools: [Tool] = [] {
        willSet {
            Message.registerTools(nil).send() // Sending nil array unregisters all tools from the Live View.
        }
        
        didSet {
            guard tools.count > 0 else { return }
            Message.registerTools(tools).send()
        }
    }
         
    public var includeSystemTools: Bool = true {
        didSet {
            Message.includeSystemTools(includeSystemTools).send()
        }
    }

    public var shouldHideTools: Bool = false {
        didSet {
            Message.hideTools(shouldHideTools).send()
        }
    }
    
    private var isTouchHandlerRegistered: Bool = false
    
    
    public var button: Button? = nil {
        
        didSet {
            let buttonName = button?.name ?? ""
            Message.setButton(name: buttonName).send()
        }
    }
    
    var runLoopRunning = false {
        didSet {
            if runLoopRunning {
                CFRunLoopRun()
            }
            else {
                CFRunLoopStop(CFRunLoopGetMain())
            }
        }
    }
    
    private var backingGraphics: [Graphic] = []
    
    public var graphics: [Graphic] {
        get {
            Message.getGraphics.send()
            runLoopRunning = true
            defer {
                backingGraphics.removeAll()
            }
            return backingGraphics
        }
    }
    
    private var lastPlacePosition: Point = Point(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude)
    private var graphicsPlacedDuringCurrentInteraction = Set<Graphic>()
    
    public init() {
        //  The user process must remain alive in order to receive touch event messages from the live view process.
        let page = PlaygroundPage.current
        page.needsIndefiniteExecution = true
        let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy
        
        proxy?.delegate = self
    }
    
    public func remoteLiveViewProxyConnectionClosed(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy) {
        clearInteractionState()
    }
    
    public func remoteLiveViewProxy(_ remoteLiveViewProxy: PlaygroundRemoteLiveViewProxy, received message: PlaygroundValue) {
        guard let message = Message(rawValue: message) else { return }
        switch message {
        case .sceneTouchEvent(let touch):
            handleSceneTouchEvent(touch: touch)
        
        case .toolSelected(let tool):
            if let candidateTool = toolInfo?[tool.name] {
                selectedTool = candidateTool
            }
            
        case .actionButtonTapped:
            if let tapBlock = button?.onTap {
                handleAssessmentTrigger(.start(context: .button))
                tapBlock()
                handleAssessmentTrigger(.stop)
                handleAssessmentTrigger(.evaluate)
            }
            
        case .setAssessment(let status):
            PlaygroundPage.current.assessmentStatus = status
            
        case .trigger(let assessmentTrigger):
            handleAssessmentTrigger(assessmentTrigger)
            
        case .getGraphicsReply(let graphicsReply):
            backingGraphics = graphicsReply
            runLoopRunning = false
            
        default:
            ()
        }
    }
    
    func handleSceneTouchEvent(touch: Touch) {
        guard let tool = selectedTool else { return }
        var touch = touch
        
        touch.previousPlaceDistance = lastPlacePosition.distance(from: touch.position)
        touch.numberOfObjectsPlaced = graphicsPlacedDuringCurrentInteraction.count
        
        if tool.options.contains(.fingerMoveEvents) {
            tool.onFingerMoved?(touch)
        }
        
        if tool.options.contains(.touchGraphicEvents), let touchedGraphic = touch.touchedGraphic {
            tool.onGraphicTouched?(touchedGraphic)
        }
        Message.touchEventAcknowledgement.send()
    }
    
    func clearInteractionState() {
        graphicsPlacedDuringCurrentInteraction.removeAll()
        lastPlacePosition = Point(x: Double.greatestFiniteMagnitude, y: Double.greatestFiniteMagnitude)
    }
    
    func handleAssessmentTrigger(_ assessmentTrigger: AssessmentTrigger) {
        guard assessmentController?.style == .continuous else { return }
        
        switch assessmentTrigger {
            
        case .start(let context):
            assessmentController?.removeAllAssessmentEvents()
            assessmentController?.allowAssessmentUpdates = true
            assessmentController?.context = context
            
        case .stop:
            assessmentController?.allowAssessmentUpdates = false
            clearInteractionState()
            
        case .evaluate:
            assessmentController?.setAssessmentStatus()
        }

    }
    
    
    /// The background image for the scene.
    public var backgroundImage: Image? = nil {
        didSet {
            Message.setSceneBackgroundImage(backgroundImage).send()
            assessmentController?.append(.setSceneBackgroundImage(backgroundImage))
        }
    }
    
    /// The background color for the scene.
    public var backgroundColor: Color  = .white {
        didSet {
            Message.setSceneBackgroundColor(backgroundColor).send()
        }
    }
    
    public var touchHandler: ((Touch)-> Void)? = nil {
        didSet {
            guard (touchHandler == nil && isTouchHandlerRegistered) || ( touchHandler != nil && !isTouchHandlerRegistered) else { return }
            Message.registerTouchHandler(touchHandler == nil).send()
        }
    }
    
    /// Removes all of the graphics from the scene.
    public func clear() {
        Message.clearScene.send()
    }
    
    /// Places a graphic at a point on screen.
    public func place(_ graphic: Graphic, at: Point) {
        Message.placeGraphic(id: graphic.id, position: CGPoint(at), isPrintable: false).send()
        assessmentController?.append(.placeAt(graphic: graphic, position: at))
        graphicsPlacedDuringCurrentInteraction.insert(graphic)
        lastPlacePosition = at
    }
    
    
    /// Returns an array of count points on a circle with the specified radius.
    public func circlePoints(radius: Number, count: Number) -> [Point] {
        
        var points = [Point]()
        
        let slice = 2 * Double.pi / count.double
        
        let center = Point(x: 0, y: 0)
        
        for i in 0..<count.int {
            let angle = slice * Double(i)
            let x = center.x + (radius.double * cos(angle))
            let y = center.y + (radius.double * sin(angle))
            points.append(Point(x: x, y: y))
        }
        
        return points
    }
    
    /// Returns an array of count points in a box with specified width.
    public func squarePoints(width: Number, count: Number) -> [Point] {
        
        var points = [Point]()
        
        guard count.int > 4 else { return points }
        
        let n = count.int / 4
        
        let sparePoints = count.int - (n * 4)
        
        let delta = width.double / Double(n)
        
        var point = Point(x: -width/2, y: -width/2)
        points.append(point)
        for _ in 0..<(n - 1) {
            point.y += delta
            points.append(point)
        }
        point = Point(x: -width/2, y: width/2)
        points.append(point)
        for _ in 0..<(n - 1) {
            point.x += delta
            points.append(point)
        }
        point = Point(x: width/2, y: width/2)
        points.append(point)
        for _ in 0..<(n - 1) {
            point.y -= delta
            points.append(point)
        }
        point = Point(x: width/2, y: -width/2)
        points.append(point)
        for _ in 0..<(n - 1) {
            point.x -= delta
            points.append(point)
        }
        
        // Duplicate remainder points at the end
        for _ in 0..<sparePoints {
            points.append(point)
        }
        
        return points
    }
    
    /// Returns an array of count points on an archimedian spiral with the specified spacing.
    public func spiralPoints(spacing: Number, count: Number) -> [Point] {
        
        let arc: Double = 25.0
        
        func p2c(r: Double, phi: Double) -> (Double, Double) {
            return (r * cos(phi), r * sin(phi))
        }
        
        var points = [Point]()
        
        var r = arc
        let b = spacing.double / (2.0 * Double.pi)
        var phi: Double = r / b
        
        let center = Point(x: 0, y: 0)
        
        for _ in 0..<count.int {
            let c = p2c(r: r, phi: phi)
            points.append(Point(x: center.x + c.0, y: center.y + c.1))
            phi += arc / r
            r = b * phi
        }
        
        return points
    }
    
    /// Returns an array of count points in a hypotrochoid curve where:
    ///     r1: radius of outer circle
    ///     r2: radius of interior circle that rolls around inside of outer circle
    ///     d:  ratio of distance of trace point from center of interior circle to r2
    ///         if d = 1 the curve is a hypocycloid
    public func hypotrochoidPoints(r1: Double, r2: Double, d: Double, count: Int) -> [Point] {
        
        var points = [Point]()
        
        let numberOfRotations = r1 / r2  // number of rotations to close the curve
        let distance = d * r2   // distance of trace point from center of interior circle
        
        let angularIncrement = numberOfRotations * 2 * Double.pi / Double(count)
        
        for i in 0..<count {
            let theta = angularIncrement * Double(i)
            let phi = ((r1 - r2) / r2) * theta
            let x = ((r1 - r2) * cos(theta)) + (distance * cos(phi))
            let y = ((r1 - r2) * sin(theta)) - (distance * sin(phi))
            points.append(Point(x: x, y: y))
        }
        return points
    }
    
    /// Returns an array of points rotated by angle (in degrees).
    func rotatePoints(points: [Point], angle: Double) -> [Point] {
        
        var rotatedPoints = [Point]()
        
        let angleRadians = (angle / 360.0) * (2.0 * Double.pi)
        
        for point in points {
            let x = point.x * cos(angleRadians) - point.y * sin(angleRadians)
            let y = point.y * cos(angleRadians) + point.x * sin(angleRadians)
            rotatedPoints.append(Point(x: x, y: y))
        }
        return rotatedPoints
    }
    
    /// Returns an array of count points in a square grid of specified size, rotated by angle (in degrees).
    public func gridPoints(size: Number, count: Number, angle: Number = 0) -> [Point] {
        
        var points = [Point]()
        
        // Get closest value for n that will fit an n * n grid inside count.
        let n = Int(floor(sqrt(count.double)))
        
        if n <= 1 {
            return [Point(x: 0, y: 0)]
        }

        let surplusPoints = count.int - (n * n)
        
        let delta = size.double / Double(n - 1)
        
        let startX = -(size / 2.0)
        let startY = -(size / 2.0)
        
        var x = startX
        var y = startY

        for _ in 0..<n {
            for _ in 0..<n {
                points.append(Point(x: x, y: y))
                x += delta
            }
            y += delta
            x = startX
        }
        
        // Duplicate and overlay any surplus points after the n * n grid has been added.
        for i in 0..<surplusPoints {
            points.append(points[i])
        }
        
        if angle != 0 {
            points = rotatePoints(points: points, angle: angle.double)
        }
        
        return points
    }

    
    /// Prints the provided text to the scene.
    public func write(_ text: String) {
        let textGraphic = Graphic(text: text) // the initiaizer sends a message to the liveView process to create the graphic image from text.
        Message.placeGraphic(id: textGraphic.id, position:.zero, isPrintable: true).send()
        assessmentController?.append(.print(graphic: textGraphic))
    }

    public func useOverlay(overlay: Overlay) {
        Message.useOverlay(overlay).send()
    }
}


