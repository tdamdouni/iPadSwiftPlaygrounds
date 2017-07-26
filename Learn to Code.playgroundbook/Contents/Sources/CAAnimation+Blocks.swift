// 
//  CAAnimation+Blocks.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//

import QuartzCore

extension CAAnimation  {
    
    var animationDidStartCompletionBlock:(()->())? {
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

    var animationDidStopCompletionBlock:(()->())? {
        set(completionBlock) {
            if self.delegate == nil {
                self.delegate = InvokingAnimationDelegate()
            }
            (self.delegate as! InvokingAnimationDelegate).stopCompletionBlock = completionBlock
        }
        
        get {
            return (self.delegate as? InvokingAnimationDelegate)?.startCompletionBlock
        }
    }

}

class InvokingAnimationDelegate : NSObject {
    
    var startCompletionBlock:(()->())?
    var stopCompletionBlock:(()->())?
    
    override init() {
        super.init()
    }
    
    override func animationDidStart(_ anim: CAAnimation) {
        if let _ = startCompletionBlock {
            startCompletionBlock!()
        }
    }
    
    override func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if let _ = stopCompletionBlock {
            stopCompletionBlock!()
        }
    }
    
}

