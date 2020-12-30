//
//  GameSession.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension GameSession {
	@objc func play(sound: SoundType) {
		playSound(sound)
	}

	@objc func makePlayer() {
		player?.removeFromSuperview()
		player = Player(gameSession: self)
		mazeView.addSubview(player)
	}

	@objc func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		isGameStarted = true
		player.didSwipe(direction)
	}
}
