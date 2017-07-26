// 
//  Scene.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
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


