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

	@objc func collisionPlayerVsEnemies() {
		guard !player.isBlinking, currentLives > 0 else { return }

		enemyCollaborator.enemies.filter {
			!$0.isHidden && player.frame.intersects($0.frame)
		}.forEach { enemy in
			if !player.isAngry {
				play(sound: .hitPlayer)
				enemy.wantSpawn = true
				currentLives -= 1
				delegate.didUpdateLives(currentLives)
				if currentLives > 0 {
					respawnPlayer(atOrigin: 2)
				}
			} else {
				UIView.animate(withDuration: 0.4) {
					enemy.respawnAtInitialFrame()
				} completion: { _ in
					self.player.isAngry = false
				}
			}
		}
	}
}
