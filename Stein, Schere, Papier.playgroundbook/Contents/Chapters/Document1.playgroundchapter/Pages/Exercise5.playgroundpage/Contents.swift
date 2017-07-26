//#-hidden-code
//
//  Contents.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Add more opponents.

 You can play against up to four opponents. To add new opponents to the game, call `addOpponent` on the `game` object.
 
 To win a round with more than two players, a player must beat at least one other player and not lose to any others.
 
 Try adding three more opponents to the game.
 
 **Play:** Experiment with modifying the actions and rules to see how the game changes with more opponents.
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
PlaygroundPage.current.liveView = viewController
//#-end-hidden-code
let game = Game()
//#-editable-code
//#-copy-destination("Exercise4", id1)
// Actions for the game.
let rock = game.addAction("✊")
let paper = game.addAction("🖐")
let scissors = game.addAction("✌️")
let hardRock = game.addAction("🤘")

// Rules for the actions.
rock.beats(scissors)
scissors.beats(paper)
paper.beats([hardRock, rock])
hardRock.beats([rock, scissors])

// 'ghost' hidden action that loses to all other actions.
let ghost = game.addHiddenAction("👻")
for action in game.actions {
    action.beats(ghost)
}

// 'unicorn' hidden action that beats all other actions.
let unicorn = game.addHiddenAction("🦄")
unicorn.beats(game.actions)

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
//#-end-copy-destination
//#-end-editable-code
//#-hidden-code
viewController.game = game
//#-end-hidden-code

game.play()
