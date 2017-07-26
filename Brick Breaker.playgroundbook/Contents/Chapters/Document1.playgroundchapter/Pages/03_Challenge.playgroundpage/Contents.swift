//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal** Handle collisions.
 
 You can now configure what happens when the ball hits the wall, the paddle, or a brick. This is a perfect opportunity to change how the game handles these events and to choose your own sounds.
 
 You can make the game unpredictable by using `randomInt`, which generates a random integer using values that you pass in. Use your imagination and see what you can create!
 
 Options to try:
 - Randomize the layout and strength of the bricks.
 - Change the color of the bricks when the ball hits them.
 - Make a brick that destroys neighboring bricks when it’s broken.
 - Play different sounds for bricks of different strengths.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(module, show, Swift)
//#-code-completion(currentmodule, show)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(identifier, show, if, func, var, let, ., =, <=, >=, <, >, ==, !=, +, -, true, false, &&, ||, !, *, /)

import UIKit
import PlaygroundSupport

//#-end-hidden-code
//#-editable-code
func setupBricks(columnCount: Int, rowCount: Int) {
    for row in 0 ..< rowCount {
        for column in 0 ..< columnCount {
            let coord = Coordinate(column: column, row: row)
            let brick = Brick()
            
            if row.isEven {
                brick.strength = 1
                
                if column.isEven {
                    brick.color = #colorLiteral(red: 0.3254901961, green: 0.5960784314, blue: 1, alpha: 1)
                } else {
                    brick.color = #colorLiteral(red: 0.3254901961, green: 0.6941176471, blue: 0.4117647059, alpha: 1)
                }
            } else {
                brick.color = #colorLiteral(red: 0.968627451, green: 0.3215686275, blue: 0.3215686275, alpha: 1)
                brick.strength = 2
            }
            
            place(brick, at: coord)
        }
    }
}

func ballDidHitBrick(ball: Ball, brick: Brick) {
    // Try changing .pop to .beep and listen for the difference.
    playSound(.pop)
    brick.strength -= 1
    
    if brick.strength == 0 {
        remove(brick)
    }
}

func ballDidHitPaddle(ball: Ball) {
    playSound(.blip)
}

func ballDidHitWall(ball: Ball) {
    playSound(.wall)
}

playGame()
//#-end-editable-code
//#-hidden-code

level.setupBricks = setupBricks
level.ballHitBrick = ballDidHitBrick
level.ballHitPaddle = ballDidHitPaddle
level.ballHitWall = ballDidHitWall

if _playGameCalled {
    let gameViewController = GameViewController.loadFromStoryboard()
    PlaygroundPage.current.liveView = gameViewController
    gameViewController.game = Game(levels: [level])
}

//#-end-hidden-code
