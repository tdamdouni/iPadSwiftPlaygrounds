// 
//  LiveViewScene.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import Foundation
import UIKit
import SpriteKit
import Dispatch
import PlaygroundSupport
import AVFoundation

internal let controlsMargin : CGFloat = 20

public protocol LiveViewSceneDelegate {
    var backgroundImage : Image? { get set }
}

private class BackgroundContainerNode : SKSpriteNode {
    var transparencyNode : SKTileMapNode?
    var userBackgroundNode : SKSpriteNode?
    var overlayNode = SKSpriteNode()
    
    var backgroundColor : UIColor? {
        didSet {
            if let color = backgroundColor {
                self.color = color
                transparencyNode?.isHidden = true
            }
            else {
                self.color = UIColor.clear
                transparencyNode?.isHidden = (backgroundImage == nil)
            }
            checkShouldHideSelf()
        }
    }
    
    var backgroundImage : Image? {
        didSet {
            if let image = backgroundImage {
                if transparencyNode == nil {
                    transparencyNode = self.transparentTileNode()
                    insertChild(transparencyNode!, at: 0)
                }

                if userBackgroundNode == nil  {
                    userBackgroundNode = SKSpriteNode()
                    insertChild(userBackgroundNode!, at: 1)
                }
                
                guard let texture = LiveViewGraphic.texture(for: image, type: .background) else { return }
                // When changing the texture on an SKSpriteNode, one must always reset the scale back to 1.0 first. Otherwise, strange additive scaling effects can occur.
                userBackgroundNode?.xScale = 1.0
                userBackgroundNode?.yScale = 1.0
                userBackgroundNode?.texture = texture
                userBackgroundNode?.size = texture.size()

                let wRatio = sceneSize.width / texture.size().width
                let hRatio = sceneSize.height / texture.size().height
                
                // Aspect fit the image if needed
                if (wRatio < 1.0 || hRatio < 1.0) {
                    let ratio = min(wRatio, hRatio)
                    userBackgroundNode?.xScale = ratio
                    userBackgroundNode?.yScale = ratio
                }

                transparencyNode?.isHidden = (backgroundColor != nil)
                userBackgroundNode?.isHidden = false
            }
            else {
                // Cleared the image
                userBackgroundNode?.isHidden = true
                transparencyNode?.isHidden = true
            }
            checkShouldHideSelf()
        }
    }
    
    var overlayImage : Image? {
        didSet {
            if let image = overlayImage {
                guard let texture = LiveViewGraphic.texture(for: image, type: .background) else { return }
                overlayNode.texture = texture
                overlayNode.size = texture.size()
            }
            
            checkShouldHideSelf()
        }
    }

    func checkShouldHideSelf() {
        self.isHidden = (backgroundColor == nil && backgroundImage == nil && overlayImage == nil)
    }
    
    init() {
        super.init(texture: nil, color: UIColor(red: 0.22, green: 0.56, blue: 0.73, alpha: 1.0), size: sceneSize)
        addChild(overlayNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func transparentTileNode() -> SKTileMapNode {
        let texture = SKTexture(imageNamed: "transparent_background")
        let tileDefinition = SKTileDefinition(texture: texture)
        let tileGroup = SKTileGroup(tileDefinition: tileDefinition)
        let tileSet = SKTileSet(tileGroups: [tileGroup], tileSetType: .grid)
        let tileMapNode = SKTileMapNode(tileSet: tileSet, columns: Int(CGFloat(sceneSize.width) / tileDefinition.size.width) + 1, 
                                                             rows: Int(CGFloat(sceneSize.height) / tileDefinition.size.height) + 1, tileSize: texture.size(), fillWith: tileGroup)
        tileMapNode.name = "transparentBackgroundNode"
        
        return tileMapNode
    }
}

private protocol QuadrantElement {
    var quadrant : Quadrant { get }
}

private protocol GraphicAccessibilityElementDelegate {
    func accessibilityLabel(element: GraphicAccessibilityElement) -> String
    func accessibilityFrame(element: GraphicAccessibilityElement) -> CGRect
}

private class GraphicAccessibilityElement : UIAccessibilityElement, QuadrantElement {
    let identifier: String
    let delegate: GraphicAccessibilityElementDelegate
    let quadrant: Quadrant
    init(delegate: GraphicAccessibilityElementDelegate, identifier: String, quadrant: Quadrant) {
        self.identifier = identifier
        self.delegate = delegate
        self.quadrant = quadrant
        super.init(accessibilityContainer: delegate)
        
        accessibilityIdentifier = identifier
    }
    
    public override var accessibilityLabel: String? {
        set {
            // no-op
        }
        get {
            return delegate.accessibilityLabel(element: self)
        }
    }
    
    public override var accessibilityFrame: CGRect {
        set {
            // no-op
        }
        get {
            return delegate.accessibilityFrame(element: self)
        }
    }
}

private protocol BackgroundAccessibilityElementDelegate {
    func accessibilityActivate(element: BackgroundAccessibilityElement) -> Bool
}

private class BackgroundAccessibilityElement : UIAccessibilityElement, QuadrantElement {
    let delegate: BackgroundAccessibilityElementDelegate
    let quadrant: Quadrant
    init(delegate: BackgroundAccessibilityElementDelegate, quadrant: Quadrant) {
        self.delegate = delegate
        self.quadrant = quadrant
        super.init(accessibilityContainer: delegate)
    }
    public override func accessibilityActivate() -> Bool {
        return delegate.accessibilityActivate(element: self)
    }
}


public class LiveViewScene: SKScene, ToolbarViewControllerDelegate, UIGestureRecognizerDelegate, GraphicAccessibilityElementDelegate, BackgroundAccessibilityElementDelegate {

   
    static let initialPrintPosition = CGPoint(x: 0, y: 400)
    static var printPosition = initialPrintPosition

    let containerNode = SKNode()
    
    var lastTouchedNode: SKNode? = nil
    var messagesAwaitingSend = [Message]()
    var waitingForTouchAcknowledegment: Bool = false
    var shouldWaitForTouchAcknowledgement: Bool = false
    
    var executionMode: PlaygroundPage.ExecutionMode? = nil {
        didSet {
            updateState(forExecutionMode: executionMode)
        }
    }
    private var steppingEnabled : Bool {
        get {
            return executionMode == .step || executionMode == .stepSlowly
        }
    }
    
    private let backgroundNode = BackgroundContainerNode()
    private var friendsNode = SKSpriteNode()
    private var buttonBar : ButtonBar? = nil
    private let toolbarController = ToolbarViewController()
    // Used to animate tool overlays on/off screen
    private var buttonBarTrailingConstraint : NSLayoutConstraint? = nil
    private var toolbarLeadingConstraint : NSLayoutConstraint? = nil
    internal var overlayHost : UIView? = nil
    internal var sceneDelegate : LiveViewSceneDelegate?
    private var connectedToUserProcess : Bool = false {
        didSet {
            // Only do this if we're turning it off, not just initializing it
            if !connectedToUserProcess && oldValue == true {
                accessibilityAllowsDirectInteraction = false
                axElements.removeAll()
            }
        }
    }

    // Items supporting spark line effects
    private var sparkLineNode = SKNode()
    private lazy var sparkLine : (path: UIBezierPath, shape: SKShapeNode, emitter: SKEmitterNode) = (UIBezierPath(), SKShapeNode(), SKEmitterNode(fileNamed:"SparkLine")!)
    private lazy var activeEmitters = Dictionary<CGPoint, SKEmitterNode>()
    private var emitterTouchPosition : CGPoint?

    // To track when we've received the last touch we sent to the user process
    private var lastSentTouch : Touch?
    
    var axElements = [UIAccessibilityElement]()
    
    var graphicsInfo = [String : LiveViewGraphic]() { // keyed by id
        didSet {
            axElements.removeAll(keepingCapacity: true)
        }
    }
    
    var selectedTool: Tool? = nil {
        didSet {
            if let selectedTool = selectedTool {
               enqueue(.toolSelected(selectedTool))
            }
        }
    }
    
    func updateState(forExecutionMode: PlaygroundPage.ExecutionMode?) {
        guard let executionMode = executionMode else { return }
        switch executionMode {
        case .step, .stepSlowly:
            shouldWaitForTouchAcknowledgement = true
            initializeSparkLineComponents()
            
        default:
            shouldWaitForTouchAcknowledgement = false
            resetSparkLinePath()
        }
    }
    
    public func toolbarDidSelectTool(toolbar: ToolbarViewController, tool: Tool) {
        self.selectedTool = tool
    }
    
    var selectedNodeForMoveOperation: SKNode? = nil
    var toolInfo = [String : Tool]()
    
    public var backgroundImage: Image? {
        didSet {
            // If the image is not exactly our expected edge-to-edge size, assume the learner has placed an image of their own.
            
            if let bgImage = backgroundImage {
                if let uiImage = UIImage(named: bgImage.path) {
                    if uiImage.size.width == TextureType.backgroundMaxSize.width && uiImage.size.height == TextureType.backgroundMaxSize.height {
                        backgroundNode.backgroundImage = nil
                        sceneDelegate?.backgroundImage = bgImage
                    }
                    else {
                        // Learner image
                        backgroundNode.backgroundImage = bgImage
                        sceneDelegate?.backgroundImage = nil
                    }
                }
            }
            else {
                // Background image cleared
                backgroundNode.backgroundImage = nil
                sceneDelegate?.backgroundImage = nil
            }
        }
    }
    
    public var shouldHideTools: Bool  = false {
        didSet {
            self.toggleToolOverlays(!shouldHideTools)
        }
    }
    
    override init() {
        super.init()
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        // The SKView hosting this scene is always sized appropriately so fit/fill really doesn't matter here.
        scaleMode = .aspectFit
        isUserInteractionEnabled = true
        backgroundColor = UIColor.clear
        toolbarController.delegate = self
        updateState(forExecutionMode: PlaygroundPage.current.executionMode)
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"PlaygroundPageExecutionModeDidChange"), object: nil, queue: OperationQueue.main) { (notification) in
            self.executionMode = PlaygroundPage.current.executionMode
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        commonInit()
    }

    func clearButtonPressed() {
        clearScene()
    }
    
    func userButtonPressed() {
        enqueue(.actionButtonTapped)
    }
    
    private func configureFriendsNode() {
        let name = "Overlay_\(arc4random_uniform(5) + 1)"
        if let img = UIImage(named: name) {
            friendsNode.texture = SKTexture(image: img)
            friendsNode.size = friendsNode.texture!.size()
            friendsNode.position = self.center
        }
    }
    
    public override func didMove(to view: SKView) {
        super.didMove(to: view)

        configureFriendsNode()

        addChild(backgroundNode)
        addChild(friendsNode)
        addChild(sparkLineNode)
        addChild(containerNode)
        containerNode.name = "container"
        backgroundNode.name = "background"
    }
    
    public override func didChangeSize(_ oldSize: CGSize) {
        backgroundNode.position = center
        containerNode.position = center
        sparkLineNode.position = center
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if connectedToUserProcess {
            enqueue(.trigger(.start(context: .tool)))

            let skTouchPosition = touches[touches.startIndex].location(in: containerNode)
            handleTouch(at: skTouchPosition, firstTouch: true)

            if steppingEnabled {
                emitterTouchPosition = skTouchPosition
                
                sparkLine.emitter.position = skTouchPosition
                sparkLine.emitter.particleBirthRate = 4.0
                sparkLine.path.move(to: skTouchPosition)
                
                sparkLine.shape.path = sparkLine.path.cgPath
            }

            if UIAccessibilityIsVoiceOverRunning() {
                graphicsPlacedCount = 0
                touchTimer?.invalidate()
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if connectedToUserProcess {
            let skTouchPosition = touches[touches.startIndex].location(in: containerNode)
            handleTouch(at: skTouchPosition)

            if steppingEnabled {
                if sparkLine.emitter.particleBirthRate < 10.0 {
                    sparkLine.emitter.particleBirthRate += 1.0 
                }
                sparkLine.emitter.position = skTouchPosition

                sparkLine.path.addLine(to: skTouchPosition)
                sparkLine.shape.path = sparkLine.path.cgPath

                // Check to see if we've traversed enough distance to drop another emitter
                if let lastTouch = emitterTouchPosition {
                    let distance = sqrt(pow(skTouchPosition.x - lastTouch.x, 2) + pow(skTouchPosition.y - lastTouch.y, 2))
                    if distance > 70, let emitter = SKEmitterNode(fileNamed:"SparkLine") {
                        emitter.particleBirthRate = 1.0
                        emitter.targetNode = self
                        emitter.position = skTouchPosition
                        emitterTouchPosition = skTouchPosition

                        sparkLineNode.addChild(emitter)
                        activeEmitters[skTouchPosition] = emitter
                    }
                }
            }
        }
    }

    private var touchTimer : Timer?
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if connectedToUserProcess {
            commonTouchEndingCleanup()

            if accessibilityAllowsDirectInteraction {
                touchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false, block: { (t : Timer) in
                    self.accessibilityAllowsDirectInteraction = false
                })
            }

            if UIAccessibilityIsVoiceOverRunning(), let placedGraphicsCount = graphicsPlacedCount {
                graphicsPlacedCount = nil
                UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, String(format: NSLocalizedString("%d graphics placed in scene", comment: "AX description of graphics placed on screen"), placedGraphicsCount))
            }

            // For tools that aren't tracking fingerMove events, we immediately remove the spark line if stepping is enabled.
            let toolSupportsFingerMoveEvents = selectedTool?.options.contains(.fingerMoveEvents)
            if (toolSupportsFingerMoveEvents == nil || toolSupportsFingerMoveEvents == false) && steppingEnabled == true {
                resetSparkLinePath()
            }
        }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if connectedToUserProcess {
            commonTouchEndingCleanup()
        }
    }

    func commonTouchEndingCleanup() {
        selectedNodeForMoveOperation = nil
        lastTouchedNode = nil
        enqueue(.trigger(.stop))
        enqueue(.trigger(.evaluate))
        
        if steppingEnabled {
            sparkLine.emitter.particleBirthRate = 0.0
            if executionMode != .step && executionMode != .stepSlowly {
                resetSparkLinePath()
            }
            else {
                for (_, emitter) in activeEmitters {
                    emitter.removeFromParent()
                }
                activeEmitters.removeAll()
            }
        }
    }
    
    func handleTouch(at: CGPoint, firstTouch: Bool = false) {
        
        guard let selectedTool = selectedTool else { return }

        switch selectedTool {
        case Tool.move where firstTouch == true:
            guard let selectedNode = containerNode.nodes(at: at).first else { break }
            selectedNodeForMoveOperation = selectedNode
            
        case Tool.move:
            guard let nodeToMove = selectedNodeForMoveOperation else { break }
            nodeToMove.position = at
                
        case Tool.erase:
            guard let selectedNode = containerNode.nodes(at: at).first  else { break }
            guard selectedNode != backgroundNode else { break }
            selectedNode.removeFromParent()

        default:
            var touch = Touch(position: Point(at), previousPlaceDistance: 0, numberOfObjectsPlaced: 0, touchedGraphic: nil) // the previousPlaceDistance * numberOfObjectsPlaced are tracked in user process.
            let node = containerNode.atPoint(at)
            if selectedTool.options.contains(.touchGraphicEvents),
                node.name != containerNode.name,
                node.name != backgroundNode.name,
                node != lastTouchedNode,
                let id = node.name, let liveGraphic = graphicsInfo[id] {
                touch.touchedGraphic = liveGraphic.graphic
            }
            lastTouchedNode = node
            enqueue(.sceneTouchEvent(touch))
            lastSentTouch = touch
        }
        
    }

    func handleMessage(message: Message) {
        switch message {
            
        case .createNode(let id):
            createNode(id: id)
            
        case .placeGraphic(let id, let position, let isPrintable):
            placeGraphic(id: id, position: position, isPrintable: isPrintable)
        
        case .removeGraphic(let id):
            removeGraphic(id: id)
            
        case .setSceneBackgroundImage(let image):
            setSceneBackgroundImage(image: image)
            
        case .setSceneBackgroundColor(let color):
            setSceneBackgroundColor(color: color)
            
        case .setImage(let id, let image):
            setImage(id: id, image: image)

        case .hideTools(let isHidden):
            hideTools(isHidden: isHidden)
            
        case .clearScene:
            clearScene()
            
        case .registerTools(let tools):
            registerTools(tools: tools)
    
        case .runAction(let id, action: let action, let key):
           runAction(id: id, action: action, key: key)
            
        case .swirlAway(let id, let duration, let rotations):
            swirlAway(id: id, after: duration, rotations: rotations)
            
        case .setText(let id, let text):
            setText(id: id, text: text)
       
        case .setTextColor(let id, let color):
            setTextColor(id: id, color: color)
            
        case .setFontName(let id, let fontName):
            setFontName(id: id, name: fontName)
            
        case .setFontSize(let id, let size):
            setFontSize(id: id, size: size)
            
        case .setButton(let name):
            setButton(name: name)
            
        case .getGraphics:
            sendGraphics()
            
        case .touchEventAcknowledgement:
            handleTouchEventAck()
            
        case .includeSystemTools(let includeTools):
            includeSystemTools(includeTools: includeTools)
            
        case .useOverlay(let overlay):
            useOverlay(overlay)
            
        default:
            ()
        }
    }
    
    func enqueue(_ message: Message) {
        DispatchQueue.main.async {
            guard self.shouldWaitForTouchAcknowledgement else {
                message.send(to: .user)
                return
            }
            if self.waitingForTouchAcknowledegment {
                self.messagesAwaitingSend.insert(message, at: 0)
                return
            }
            if case .sceneTouchEvent(_) = message {
                self.waitingForTouchAcknowledegment = true
            }
            message.send(to: .user)
        }
    }
    
    func useOverlay(_ overlay: Overlay) {
        backgroundNode.overlayImage = overlay.image()
    }
    
    func handleTouchEventAck() {
        DispatchQueue.main.async {
            guard self.waitingForTouchAcknowledegment else { return }
            self.waitingForTouchAcknowledegment = false
            var keepIterating = true
            repeat {
                if let message = self.messagesAwaitingSend.popLast() {
                    if case .sceneTouchEvent(let touch) = message {
                        if let lastTouch = self.lastSentTouch, touch == lastTouch {
                            if self.steppingEnabled {
                                self.resetSparkLinePath()
                            }
                        }
                        self.waitingForTouchAcknowledegment = true
                        if self.shouldWaitForTouchAcknowledgement {
                            keepIterating = false
                        }
                        message.send(to: .user)
                        continue
                    }
                    message.send(to: .user)
                }
            } while keepIterating && self.messagesAwaitingSend.count > 0
            
        }
    }
    
    func sendGraphics() {
        var returnGraphics = [Graphic]()
        
        for liveViewGraphic in graphicsInfo.values {
            returnGraphics.append(liveViewGraphic.graphic)
        }
        enqueue(.getGraphicsReply(graphics: returnGraphics))
    }
    
    
    func createNode(id: String) {
        DispatchQueue.main.async {
            let graphic = LiveViewGraphic(id: id)
            self.graphicsInfo[id] = graphic
            graphic.backingNode.name = id
        }
    }

    func placeGraphic(id: String, position: CGPoint, isPrintable: Bool) {
        DispatchQueue.main.async {
            if let graphic = self.graphicsInfo[id] {
                if graphic.backingNode.parent == nil {
                    self.containerNode.addChild(graphic.backingNode)
                    if UIAccessibilityIsVoiceOverRunning() {
                        self.graphicPlacedAudioPlayer.play()
                        if self.graphicsPlacedCount != nil {
                            self.graphicsPlacedCount! += 1
                        }
                    }
                }
                graphic.backingNode.position = isPrintable ? LiveViewScene.printPosition : position
                if self.steppingEnabled {
                    self.updateSparkLine(to: position)
                }
                
                if isPrintable {
                    LiveViewScene.printPosition.y -= graphic.backingNode.size.height
                }
            }
        }
    }
   
    func removeGraphic(id: String) {
        DispatchQueue.main.async {
            if let spriteNode = self.containerNode.childNode(withName: id) as? SKSpriteNode {
                spriteNode.removeFromParent()
                self.axElements.removeAll(keepingCapacity: true)
            }
        }
    }
    
    func setSceneBackgroundImage(image: Image?) {
        DispatchQueue.main.async {
            self.backgroundImage = image
            self.axElements.removeAll(keepingCapacity: true)
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.accessibilityElements?.first)
        }
    }
    
    func setSceneBackgroundColor(color: UIColor) {
        DispatchQueue.main.async { [unowned self] in
            self.backgroundNode.backgroundColor = color
            self.axElements.removeAll(keepingCapacity: true)
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.accessibilityElements?.first)
        }
    }
    
    func setImage(id: String, image: Image?) {
        DispatchQueue.main.async { [unowned self] in
            guard let graphic = self.graphicsInfo[id] else { return }
            graphic.image = image
        }
    }
    
    func hideTools(isHidden: Bool) {
        DispatchQueue.main.async {
            self.shouldHideTools = isHidden
        }
    }
    
    func includeSystemTools(includeTools: Bool) {
        DispatchQueue.main.async {
            self.toolbarController.includeSystemTools = includeTools
        }
    }
    
    func clearScene() {
        DispatchQueue.main.async {
            self.containerNode.removeAllChildren()
            self.graphicsInfo.removeAll()
            type(of: self).printPosition = type(of:self).initialPrintPosition
        }
    }
    
    func registerTools(tools: [Tool]?) {
        DispatchQueue.main.async {
            if let t = tools {
                self.toolbarController.userTools = t
            }
            else {
                self.toolbarController.userTools.removeAll()
            }
        }
    }
    
    func runAction(id: String, action: SKAction, key: String?) {
        DispatchQueue.main.async {
            guard let graphic = self.graphicsInfo[id] else { return }
            if let key = key {
                graphic.backingNode.run(action, withKey: key)
            }
            else {
                graphic.backingNode.run(action)
            }
        }
    }
    
    func swirlAway(id: String, after seconds: Double, rotations: Double) {
        
        DispatchQueue.main.async {
            guard let graphic = self.graphicsInfo[id] else { return }
            graphic.swirlAway(after: seconds, rotations: CGFloat(rotations))
            self.axElements.removeAll(keepingCapacity: true)
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, self.accessibilityElements?.first)
        }
    }
    
    func setText(id: String, text: String?) {
        DispatchQueue.main.async {
            guard let graphic = self.graphicsInfo[id] else { return }
            graphic.text = text
        }
    }
    
    func setTextColor(id: String, color: UIColor) {
        DispatchQueue.main.async {
            guard let graphic = self.graphicsInfo[id] else { return }
            graphic.textColor = color
        }
    }
    
    func setFontName(id: String, name: String) {
        DispatchQueue.main.async {
            guard let graphic = self.graphicsInfo[id] else { return }
            graphic.fontName = name
        }
    }

    func setFontSize(id: String, size: Int) {
        DispatchQueue.main.async {
            guard let graphic = self.graphicsInfo[id] else { return }
            graphic.fontSize = size
        }
    }
    
    private var userButtonName : String? = nil
    func setButton(name: String) {
        let maxNameLength = 22
        if name.characters.count > maxNameLength { // arbitrary cutoff to keep the button name from getting too long
            userButtonName = name.substring(to: name.index(name.startIndex, offsetBy: maxNameLength - 1)) + "…"
        }
        else {
            userButtonName = name
        }
    }
    
    func disconnectedFromUserCode() {
        DispatchQueue.main.async {
            self.connectedToUserProcess = false
            self.shouldHideTools = true
            self.messagesAwaitingSend.removeAll()
            self.waitingForTouchAcknowledegment = false
            if self.steppingEnabled {
                self.resetSparkLinePath()
            }
        }
    }
    
    func connectedToUserCode() {
        DispatchQueue.main.async {
            self.connectedToUserProcess = true
            self.friendsNode.removeFromParent()
            self.backgroundNode.backgroundColor = nil
            self.messagesAwaitingSend.removeAll()
            self.waitingForTouchAcknowledegment = false
        }
    }
    
    private func toggleToolOverlays(_ showOverlays: Bool) {
        if showOverlays {
            if buttonBar == nil {
                if let view = overlayHost {
                    var buttons = Array<UIView>()
                    let clearButton = ButtonBarButton.createANewButton(title: "Clear", target: self, action: #selector(clearButtonPressed))
                    buttons.append(clearButton)
                    if let ubName = userButtonName {
                        let b = ButtonBarButton.createANewButton(title: ubName, target: self, action: #selector(self.userButtonPressed))
                        buttons.insert(b, at: 0)
                    }
                    
                    buttonBar = ButtonBar(origin: CGPoint(x: view.frame.size.width + 10, y: controlsMargin), buttons: buttons)
                    view.addSubview(buttonBar!)
                    
                    self.buttonBarTrailingConstraint = buttonBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: buttonBar!.frame.size.width + 10)
                    
                    NSLayoutConstraint.activate([
                        self.buttonBarTrailingConstraint!,
                        buttonBar!.topAnchor.constraint(equalTo: view.topAnchor, constant: controlsMargin)
                        ])

                    // We need the currently offscreen buttonBarTrailingConstraint to be noticed by the layout engine before we later change the constraint constant to animate it in later.
                    view.layoutIfNeeded()
                }
            }
            

            if !toolbarController.isViewLoaded {
                if let view = overlayHost {
                    view.addSubview(toolbarController.view)
                    
                    self.toolbarLeadingConstraint = toolbarController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -toolbarController.view.frame.size.width - 10)
                    
                    NSLayoutConstraint.activate([
                        self.toolbarLeadingConstraint!,
                        toolbarController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: controlsMargin)
                        ])

                    // We need the currently offscreen toolbarLeadingConstraint to be noticed by the layout engine before we later change the constraint constant to animate it in later.
                    view.layoutIfNeeded()
                }
            }

            // Ensure the layout engine has all constraints in place before attempting to animate them.
            view?.layoutIfNeeded()

            self.buttonBarTrailingConstraint!.constant = -controlsMargin
            self.toolbarLeadingConstraint!.constant = controlsMargin
            
            UIView.animate(withDuration: 0.2, delay: 0.1, options: (.curveLinear), animations: {
                self.overlayHost?.layoutIfNeeded()
                }, completion: nil)
        }
        else {
            guard buttonBar != nil && toolbarController.isViewLoaded else { return }

            self.buttonBarTrailingConstraint?.constant = buttonBar!.frame.size.width + 10
            self.toolbarLeadingConstraint?.constant = CGFloat(-toolbarController.view.frame.size.width) - 10

            UIView.animate(withDuration: 0.2, delay: 0.1, options: (.curveLinear), animations: {
                self.overlayHost?.layoutIfNeeded()
                }, completion: { (completed: Bool) in 
                    if completed {
                        // Nuke everything and rebuild it. It's not optimal but not terribly expensive either, plust there's less complexity to manage in trying to discern when things change.
                        self.buttonBar?.removeFromSuperview()
                        self.toolbarController.view.removeFromSuperview()

                        self.buttonBar = nil 
                        self.toolbarController.view = nil

                        self.userButtonName = nil

                        self.selectedTool = nil
                    }
            })
        }
    }
    
    private func initializeSparkLineComponents() {
        sparkLine.shape.lineWidth = 8.0
        sparkLine.shape.lineCap = .round
        sparkLine.shape.strokeColor = UIColor.white
        
        // Start the emitter with a zero birth rate so we can immediately add it to the scene.
        sparkLine.emitter.particleBirthRate = 0.0
        sparkLine.emitter.targetNode = self
        
        // We need to add the spark line components to the scene only once
        guard sparkLine.emitter.parent == nil else { return }
        sparkLineNode.addChild(sparkLine.emitter)
        sparkLineNode.addChild(sparkLine.shape)
    }
    
    private func updateSparkLine(to position: CGPoint) {
        let elementsOnPath = sparkLine.path.cgPath.pathElements()
        var foundPoint : Bool = false
        var removedElementPoints = Array<CGPoint>()
        let remainingElementsOnPath = elementsOnPath.filter { (e : PathElement) -> Bool in
            // Expect that all of these elements are just moveToPoint and addLineToPoint
            var elementPoint : CGPoint = .zero
            switch e.type {
            case .moveToPoint, .addLineToPoint:
                elementPoint = e.points[0]
            default:
                break
            }

            if position == elementPoint {
                foundPoint = true
            }

            // Once we've found the point that the line has been updated to, all elements from here on need to be added for the next path
            if foundPoint {
                return true
            }

            if let emitter = activeEmitters[elementPoint] {
                emitter.removeFromParent()
                activeEmitters.removeValue(forKey: elementPoint)
            }

            removedElementPoints.append(elementPoint)
            
            return false
        }

        if remainingElementsOnPath.count > 0 {
            let newPath : UIBezierPath = UIBezierPath()
            // We must always move to the first element's point. If the first element is an addLineToPoint and we don't have a starting point, the path becomes broken and won't accept new points later.
            newPath.move(to: remainingElementsOnPath.first!.points[0])
            for element in remainingElementsOnPath {
                switch element.type {
                case .moveToPoint:
                    newPath.move(to: element.points[0])
                case .addLineToPoint:
                    newPath.addLine(to: element.points[0])
                default:
                    break
                }
            }
            
            resetSparkLinePath(newPath: newPath)
        }
        
        // When stepping, we want to remove the line between points a bit more dramatically than just removing it. This builds an animation that fades the removed line out while "burning" the line.
        if executionMode == .step || executionMode == .stepSlowly {
            if !removedElementPoints.isEmpty, let endPoint = remainingElementsOnPath.first?.points[0] {
                var removedPoints = removedElementPoints
                removedPoints.append(endPoint)

                let animationDuration : TimeInterval = 1.0

                let burnLineShape = SKShapeNode()
                burnLineShape.lineWidth = 8.0
                burnLineShape.lineCap = .round
                burnLineShape.strokeColor = UIColor.white
                sparkLineNode.addChild(burnLineShape)

                let emitter = SKEmitterNode(fileNamed:"SparkLine")!
                emitter.targetNode = sparkLineNode
                emitter.particleBirthRate = 30.0
                emitter.position = removedElementPoints.first!
                sparkLineNode.addChild(emitter)

                let burnLinePath = UIBezierPath()
                burnLinePath.move(to: removedPoints.first!)

                var actions = [SKAction]()
                for p in removedPoints {
                    // We don't need to move for the first point
                    if p != removedPoints[0] {
                        burnLinePath.addLine(to: p)
                        actions.append(SKAction.move(to: p, duration: animationDuration / Double(removedPoints.count)))
                        actions.append(SKAction.wait(forDuration: 0.05))
                    }
                }

                // Shut down the emitter and then wait for all particles to die before removing it from the scene
                actions.append(SKAction.run { emitter.particleBirthRate = 0.0 } )
                actions.append(SKAction.wait(forDuration: 2.0))
                actions.append(SKAction.run {
                    emitter.removeFromParent()
                    burnLineShape.removeFromParent()
                } )
                emitter.run(SKAction.sequence(actions))

                burnLineShape.path = burnLinePath.cgPath
                burnLineShape.run(SKAction.fadeOut(withDuration: animationDuration))
            }
        }
    }

    private func resetSparkLinePath(newPath: UIBezierPath? = nil) {
        sparkLine.path = newPath != nil ? newPath! : UIBezierPath()
        sparkLine.shape.path = sparkLine.path.cgPath
        
        // If we're clearing the path, clear any remaining emitters as well
        if newPath == nil {
            for (_,emitter) in activeEmitters {
                emitter.removeFromParent()
            }
            activeEmitters.removeAll()
        }
    }
    
    // MARK: Accessibility
        
    private var graphicsPlacedCount : Int?
    
    private var accessibilityAllowsDirectInteraction: Bool = false {
        didSet {
            UIAccessibilityPostNotification(UIAccessibilityLayoutChangedNotification, "Direct interaction \(accessibilityAllowsDirectInteraction ? "enabled" : "disabled")")
        }
    }

    public override var isAccessibilityElement: Bool {
        set { }
        get { return accessibilityAllowsDirectInteraction }
    }
    
    public override var accessibilityLabel: String? {
        set { }
        get { return "Scene, direct interaction enabled" }
    }
    
    public override var accessibilityTraits: UIAccessibilityTraits {
        set { }
        get { 
            if accessibilityAllowsDirectInteraction {
                return UIAccessibilityTraitAllowsDirectInteraction
            }
            return UIAccessibilityTraitNone
        }
    }

    private func findGraphics(for quadrant: Quadrant) -> [(String, LiveViewGraphic)] {
        // Sort the graphics vertically.
        let orderedGraphicsInfo = graphicsInfo.tupleContents.sorted { lhs, rhs in
            return lhs.1.position.y > rhs.1.position.y
        }

        // Asking for all the images in the scene
        if quadrant == .wholeScene {
            return orderedGraphicsInfo.filter { (_, graphic) in
                guard graphic.backingNode.parent == containerNode else { return false }
                return true
            }
        }

        let quadRect = quadrant.rect(in: view!)
        return orderedGraphicsInfo.filter { (_, graphic) in
            guard graphic.backingNode.parent == containerNode else { return false }
            // Adjust the graphic position to be consitent with the quadrants
            let scenePosition = containerNode.convert(graphic.position, to: scene!)
            let viewPosition = scene!.convertPoint(toView: scenePosition)
            return quadRect.contains(viewPosition)
        }
    }
    
    public override var accessibilityElements: [Any]? {
        set { /* Should not need to set */ }
        
        get {
            guard !accessibilityAllowsDirectInteraction else { return nil }

            // VO will ask for accessible elements pretty frequently. We should only update our list of items when the number of graphics we're tracking changes.
            guard axElements.isEmpty else { return axElements }

            // Add accessibility elements
            var sceneLabel = NSLocalizedString("Scene, ", comment: "AX label")
            if let backgroundImage = backgroundImage {
                sceneLabel += String(format: NSLocalizedString("background image: %@, ", comment: "AX label: background image description."), backgroundImage.description)
            }
            // Describe the color even if there is an image (it's possible the image does not cover the entire scene).
            if let backgroundColor = backgroundNode.backgroundColor {
                sceneLabel += String(format: NSLocalizedString("background color: %@.", comment: "AX label: scene background color description."), backgroundColor.accessibleDescription)
            }
            _addBGElement(frame: view!.bounds, label: sceneLabel, elementCount: findGraphics(for: .wholeScene).count, quadrant: .wholeScene)

            for quadrant in Quadrant.quadrants {
                let graphics = findGraphics(for: quadrant)
                _addBGElement(frame: quadrant.rect(in: view!), label: quadrant.description, elementCount: graphics.count, quadrant: quadrant)

                // Add the individual graphics in order based on the quadrant.
                for (id, _) in graphics {
                    let element = GraphicAccessibilityElement(delegate: self, identifier: id, quadrant: quadrant)
                    axElements.append(element)
                }

            }
            
            return axElements
        }
    }
    
    private func _addBGElement(frame: CGRect, label: String, elementCount: Int, quadrant: Quadrant) {
        let element = BackgroundAccessibilityElement(delegate: self, quadrant: quadrant)
        element.accessibilityFrame = UIAccessibilityConvertFrameToScreenCoordinates(frame, view!)
        
        var label = label
        if elementCount > 0 {
            if (elementCount == 1) {
                label = String(format: NSLocalizedString("%@, %d graphic found.", comment: "AX label: count of graphics per quadrant (singular)."), label, elementCount)
            }
            else {
                label = String(format: NSLocalizedString("%@, %d graphics found.", comment: "AX label: count of graphics per quadrant (plural)."), label, elementCount)
            }
        }

        element.accessibilityLabel = label
        if connectedToUserProcess {
            element.accessibilityHint = NSLocalizedString("Double tap to enable direct interaction", comment: "AX label")
        }
        axElements.append(element)
    }
    
    // MARK: GraphicAccessibilityElementDelegate
    
    private func graphicDescription(for graphic: LiveViewGraphic, quadrant: Quadrant?) -> String {
        var label = ""
        var imageDescription = ""
        if let text = graphic.text {
            imageDescription = text
        } else if let image = graphic.image {
            imageDescription = image.description
        }

        label = String(format: NSLocalizedString("%@, at x %d, y %d, %@", comment: "AX label: description of an image and its position in the scene."), imageDescription, Int(graphic.position.x), Int(graphic.position.y), quadrant != nil ? quadrant!.description : "")

        return label
    }
    
    fileprivate func accessibilityLabel(element: GraphicAccessibilityElement) -> String {
        var label = ""
        if let liveViewGraphic = graphicsInfo[element.identifier] {
            label = graphicDescription(for: liveViewGraphic, quadrant: element.quadrant)
        }
        return label
    }
    
    fileprivate func accessibilityFrame(element: GraphicAccessibilityElement) -> CGRect {
        if let liveViewGraphic = graphicsInfo[element.identifier] {
            return liveViewGraphic.backingNode.accessibilityFrame.insetBy(dx: -10, dy: -10)
        }
        return CGRect.zero
    }
    
    fileprivate func accessibilityActivate(element: BackgroundAccessibilityElement) -> Bool {
        if (!accessibilityAllowsDirectInteraction && connectedToUserProcess) {
            // This value persists until the user starts a drag and lifts their finger for at least one second.
            accessibilityAllowsDirectInteraction = true
        }
        return true
    }
    
    public override var accessibilityCustomActions : [UIAccessibilityCustomAction]? {
        set { }
        get {
            let summary = UIAccessibilityCustomAction(name: NSLocalizedString("Scene summary.", comment: "AX action name"), target: self, selector: #selector(sceneSummaryAXAction))
            let currentQuadDetails = UIAccessibilityCustomAction(name: NSLocalizedString("Image details for current quadrant.", comment: "AX action name"), target: self, selector: #selector(imageDetailsForFocusedQuadrant))
            return [summary, currentQuadDetails]
        }
    }

    func sceneSummaryAXAction() {
        var imageListDescription = ""

        for quadrant in Quadrant.quadrants {
            let count = findGraphics(for: quadrant).count
            if count > 0 {
                if (count == 1) {
                    imageListDescription += String(format: NSLocalizedString("%@, %d graphic found.", comment: "AX label: count of graphics per quadrant (singular)."), quadrant.description, count)
                }
                else {
                    imageListDescription += String(format: NSLocalizedString("%@, %d graphics found.", comment: "AX label: count of graphics per quadrant (plural)."), quadrant.description, count)
                }
            }
        }

        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, imageListDescription)
    }

    // Note that we allow this to be called on the entire scene.
    func imageDetailsForFocusedQuadrant() {
        let focusedElement = UIAccessibilityFocusedElement(nil)
        var quadrant : Quadrant = .wholeScene
        
        if let quadrantElement = focusedElement as? QuadrantElement {
            quadrant = quadrantElement.quadrant
        }
        
        let graphics = findGraphics(for: quadrant)
        var imageListDescription = ""
        switch graphics.count {
        case 0:
            imageListDescription += String(format: NSLocalizedString("%@, no graphics found.", comment: "AX label, count of graphics per quadrant (none found)"), quadrant.description)
        case 1:
            imageListDescription += String(format: NSLocalizedString("%@, %d graphic found.", comment: "AX label: count of graphics per quadrant (singular)."), quadrant.description, graphics.count)
        default:
            imageListDescription += String(format: NSLocalizedString("%@, %d graphics found.", comment: "AX label: count of graphics per quadrant (plural)."), quadrant.description, graphics.count)            
        }
        
        for (_, liveViewGraphic) in graphics {
            imageListDescription += graphicDescription(for: liveViewGraphic, quadrant: nil)
            imageListDescription += ", "
        }

        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, imageListDescription)
    }
    
    private lazy var graphicPlacedAudioPlayer : AVAudioPlayer = {
        let url = Bundle.main.url(forResource: "GraphicPlaced", withExtension: "aifc")
        let p = try! AVAudioPlayer(contentsOf: url!)
        p.volume = 0.5

        return p
    }()
}

private enum Quadrant {
    case wholeScene, upperLeft, upperRight, lowerLeft, lowerRight
    
    func rect(in view: UIView) -> CGRect {
        let halfWidth = view.bounds.width / 2.0
        let halfHeight = view.bounds.height / 2.0
        
        switch self {
        case .wholeScene:
            return view.bounds
        case .upperLeft:
            return CGRect(x: 0, y: 0, width: halfWidth, height: halfHeight)
        case .upperRight:
            return CGRect(x: halfWidth, y: 0, width: halfWidth, height: halfHeight)
        case .lowerLeft:
            return CGRect(x: 0, y: halfHeight, width: halfWidth, height: halfHeight)
        case .lowerRight:
            return CGRect(x: halfWidth, y: halfHeight, width: halfWidth, height: halfHeight)
        }
    }
    
    var description : String {
        switch self {
        case .wholeScene:
            return NSLocalizedString("Scene",  comment: "AX quadrant label")
        case .upperLeft:
            return NSLocalizedString("Upper left quadrant",  comment: "AX quadrant label")
        case .upperRight:
            return NSLocalizedString("Upper right quadrant", comment: "AX quadrant label")
        case .lowerLeft:
            return NSLocalizedString("Lower left quadrant",  comment: "AX quadrant label")
        case .lowerRight:
            return NSLocalizedString("Lower right quadrant", comment: "AX quadrant label")
        }
    }
    
    // Returns just the four quadrants
    static var quadrants : [Quadrant] {
        return [.upperLeft, .upperRight, .lowerLeft, .lowerRight]
    }
}

extension Dictionary {
    fileprivate var tupleContents: [(Key, Value)] {
        return self.map { ($0.key, $0.value) }
    }
}

