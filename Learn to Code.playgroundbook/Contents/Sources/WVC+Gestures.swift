// 
//  WVC+Gestures.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//


import SceneKit

extension WorldViewController {
    
    // MARK: Adjust Speed
    
    @IBAction func changeSpeedAction(_ button: UIButton) {
        scene.commandQueue.runMode = .continuous
        
        let speedCoefficients = [1.0, 2.0, 5.0]
        
        // Some classic tag programming.
        button.tag += 1
        
        // Wrap the button tag value back to zero.
        button.tag = button.tag < speedCoefficients.count ? button.tag : 0
        
        let newSpeed = speedCoefficients[button.tag]
        button.setTitle("\(Int(newSpeed))x", for: [])
        scene.gridWorld.commandSpeed = Float(newSpeed)
    }
    
    // MARK: Command Steppers
    
    func nextCommandAction(_: UIButton) {
        scene.commandQueue.runMode = .randomAccess
        scene.commandQueue.runNextCommand()
        
        updateCommandLabel()
    }
    
    func previousCommandAction(_: UIButton) {
        // Setting the commandQueue to run continuously will run previous actions in reverse.
        scene.commandQueue.runMode = .randomAccess
        scene.commandQueue.resetPreviousCommand()
        
        updateCommandLabel()
    }
    
    func updateCommandLabel() {
        DispatchQueue.main.async {
//            self.commandsViewController.selectCurrentCommand()
        }
    }
}
