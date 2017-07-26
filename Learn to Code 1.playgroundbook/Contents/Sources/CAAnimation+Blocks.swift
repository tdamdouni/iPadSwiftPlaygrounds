// 
//  CAAnimation+Blocks.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import QuartzCore

typealias CompletionBlock = () -> ()
typealias FinishedBlock = (Bool) -> ()

extension CAAnimation  {
    
    var startCompletionBlock: CompletionBlock? {
        set(completionBlock) {
            if self.delegate == nil {
                self.delegate = InvokingAnimationDelegate()
            }
            (self.delegate as! InvokingAnimationDelegate).startCompletionBlock = completionBlock
        }
        
        get {
            return (self.delegate as? InvokingAnimationDelegate)?.startCompletionBlock
        }
    }

    var stopCompletionBlock: FinishedBlock? {
        set(completionBlock) {
            if self.delegate == nil {
                self.delegate = InvokingAnimationDelegate()
            }
            (self.delegate as! InvokingAnimationDelegate).stopCompletionBlock = completionBlock
        }
        
        get {
            return (self.delegate as? InvokingAnimationDelegate)?.stopCompletionBlock
        }
    }

}

class InvokingAnimationDelegate: NSObject, CAAnimationDelegate {
    
    var startCompletionBlock: CompletionBlock?
    var stopCompletionBlock: FinishedBlock?
    
    func animationDidStart(_ anim: CAAnimation) {
        startCompletionBlock?()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopCompletionBlock?(flag)
    }
    
}

