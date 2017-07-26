//
//  Player.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

enum PlayerType {
    case bot
    case human
}

class Player: Equatable {

    var emoji: String

    var color: UIColor
    
    var identifier: String

    let type: PlayerType

    var action: Action
    
    var winCount: UInt = 0
    
    var isRandom = false
    
    init(_ emoji: String = "", color: UIColor = UIColor.clear, type: PlayerType = .human) {
        action = Action()
        identifier = emoji
        self.emoji = emoji
        self.type = type
        self.color = color
        if type == .bot {
            isRandom = true
        }
    }
    
    public static func == (leftPlayer: Player, rightPlayer: Player) -> Bool {
        return leftPlayer.identifier == rightPlayer.identifier
    }
}
