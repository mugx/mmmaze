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

		enemyCollaborator.collide(with: player) { (enemy) in
			if !player.isAngry {
				enemy.wantSpawn = true

				play(sound: .hitPlayer)
				currentLives -= 1
				delegate.didUpdateLives(currentLives)

				if currentLives > 0 {
					respawnPlayer()
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

	// MARK: - Private

	private func respawnPlayer() {
		player.isBlinking = true
		UIView.animate(withDuration: 0.4) {
			self.player.respawnAtInitialFrame()
			self.mazeView.center(to: self.player)
		} completion: { _ in
			self.player.blink(2) {
				self.player.isBlinking = false
			}
		}
	}
}
