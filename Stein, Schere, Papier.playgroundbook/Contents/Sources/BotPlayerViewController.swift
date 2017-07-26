//
//  BotPlayerViewController.swift
//
//  Copyright © 2016,2017 Apple Inc. All rights reserved.
//

import UIKit

class BotPlayerViewController: PlayerViewController {
    
    override init(player: Player, game: Game) {
        super.init(player: player, game: game)
        
        ringTrackMultiplier = 0.16
        innerCircleMultiplier = 0.62
    }
    
    override func setupViews() {
        super.setupViews()
        actionView.setText(player.emoji)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented.")
    }

    override func prepareViewsForCurrentStatus() {
        super.prepareViewsForCurrentStatus()
        
        if game.status == .ready || game.status == .play {
            actionView.setText(player.emoji)
        }
    }
}
