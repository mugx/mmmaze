//
//  GameSession+Player.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension GameSession {
	@objc func makePlayer() {
		player?.removeFromSuperview()
		player = Player(gameSession: self)
		mazeView.addSubview(player)
	}
}
