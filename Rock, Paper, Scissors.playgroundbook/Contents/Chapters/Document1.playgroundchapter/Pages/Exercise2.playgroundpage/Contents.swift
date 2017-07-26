//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 **Goal:** Modify the code to personalize your game.
 
 Read through the code to understand how the game is set up. Try modifying the emoji for the actions and changing the colors for the game.
 
 When you’re ready, move on to the next page to explore adding more actions and defining new rules for the game.
 */
//#-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(currentmodule, show)
//#-code-completion(literal, show, array, boolean, color, integer, string)
//#-code-completion(bookauxiliarymodule, show)
//#-code-completion(identifier, show, if, for, while, func, var, let, ., =, (, ))
//#-code-completion(identifier, hide, GameViewController, viewController, GameResult, Game, Action, canPlay, Play())
import CoreGraphics
import PlaygroundSupport

let viewController = GameViewController.makeFromStoryboard()
viewController.needAssessment = true
PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
let game = Game()
//#-copy-source(id1)
//#-editable-code
// Actions for the game.
let rock = game.addAction("✊")
let paper = game.addAction("🖐")
let scissors = game.addAction("✌️")

// Rules for the actions.
rock.beats(scissors)
scissors.beats(paper)
paper.beats(rock)

// Opponents for the game.
game.addOpponent("🤖", color: #colorLiteral(red: 0.8, green: 0, blue: 0.3882352941, alpha: 1))

// Configurations for the game.
game.roundsToWin = 3
game.prize = "🏆"

// Colors for the game.
game.myColor = #colorLiteral(red: 0, green: 0.6392156863, blue: 0.8509803922, alpha: 1)
game.outerRingColor = #colorLiteral(red: 0.7450980392, green: 0.8352941176, blue: 0.8980392157, alpha: 1)
game.innerCircleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
game.mainButtonColor = #colorLiteral(red: 0, green: 0.6392156863, blue: 0.8509803922, alpha: 1)
game.changeActionButtonsColor = #colorLiteral(red: 0.4546349278, green: 0.6598061836, blue: 0.8290498719, alpha: 1)
game.backgroundColors = [#colorLiteral(red: 0.7843137255, green: 0.9058823529, blue: 1, alpha: 1), #colorLiteral(red: 0.9647058824, green: 0.9843137255, blue: 1, alpha: 1)]
//#-end-editable-code
//#-end-copy-source
//#-hidden-code
viewController.game = game
//#-end-hidden-code

game.play()
