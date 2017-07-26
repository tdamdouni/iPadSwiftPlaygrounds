//#-hidden-code
//
//  Contents.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
//#-end-hidden-code
/*:
 Here’s a possible solution to the previous exercises. But remember—there are many ways to write code, so if your game behaves the way you want it to, don’t worry if your code is different from what’s shown here.
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
// Actions for the game.
let rock = game.addAction("✊")
let paper = game.addAction("🖐")
let scissors = game.addAction("✌️")
let hardRock = game.addAction("🤘")
let doublePaper = game.addAction("🙌")
let doubleScissors = game.addAction("🖖")

// Rules for the actions.
rock.beats([doubleScissors, scissors])
doubleScissors.beats([scissors, doublePaper, paper])
scissors.beats([doublePaper, paper])
doublePaper.beats([paper, hardRock, rock])
paper.beats([hardRock, rock])
hardRock.beats([rock, doubleScissors, scissors])

// 'ghost' hidden action that loses to all other actions.
let ghost = game.addHiddenAction("👻")
for action in game.actions {
    action.beats(ghost)
}

// 'unicorn' hidden action that beats all other actions.
let unicorn = game.addHiddenAction("🦄")
unicorn.beats(game.actions)

// Opponents for the game.
game.addOpponent("🦁", color: #colorLiteral(red: 0.556862771511078, green: 0.352941185235977, blue: 0.968627452850342, alpha: 1.0))
game.addOpponent("🐸", color: #colorLiteral(red: 0.941176474094391, green: 0.498039215803146, blue: 0.352941185235977, alpha: 1.0))
game.addOpponent("🐼", color: #colorLiteral(red: 0.584313750267029, green: 0.823529422283173, blue: 0.419607847929001, alpha: 1.0))
game.addOpponent("🐵", color: #colorLiteral(red: 0.239215686917305, green: 0.674509823322296, blue: 0.968627452850342, alpha: 1.0))

// Configurations for the game.
game.roundsToWin = 5
game.prize = "🍦"

// Colors for the game.
game.myColor = #colorLiteral(red: 0.960784316062927, green: 0.705882370471954, blue: 0.200000002980232, alpha: 1.0)
game.outerRingColor = #colorLiteral(red: 0.10196078568697, green: 0.278431385755539, blue: 0.400000005960464, alpha: 1.0)
game.innerCircleColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
game.mainButtonColor = #colorLiteral(red: 0.952941179275513, green: 0.686274528503418, blue: 0.133333340287209, alpha: 1.0)
game.changeActionButtonsColor = #colorLiteral(red: 0.10196078568697, green: 0.278431385755539, blue: 0.400000005960464, alpha: 1.0)
game.backgroundColors = [#colorLiteral(red: 0.474509805440903, green: 0.839215695858002, blue: 0.976470589637756, alpha: 1.0), #colorLiteral(red: 0.976470589637756, green: 0.850980401039124, blue: 0.549019634723663, alpha: 1.0)]
//#-end-editable-code
//#-hidden-code
viewController.game = game
//#-end-hidden-code

game.play()
