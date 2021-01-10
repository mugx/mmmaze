//
//  GameSession+Collision.swift
//  mmmaze
//
//  Created by mugx on 10/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

extension GameSession {
	func checkWallCollision(_ frame: CGRect) -> Bool {
		return walls.contains { $0.frame.intersects(frame) }
	}

	func playerVsEnemiesCollision() {
		guard !player.isBlinking else { return }

		var collided = false
		enemyCollaborator.collide(with: player) { (enemy) in
			guard !collided else { return }
			collided = true

			if player.power > 0 {
				playerHits(enemy)
			} else {
				playerGetsHit(from: enemy)
			}
		}
	}

	func playerGoalCollision() {
		guard
			mazeGoalTile.type == TyleType.goal_open &&
				player.frame.intersects(mazeGoalTile.frame) else {
			return
		}

		currentScore += 100
		startLevel(currentLevel + 1)
	}

	// MARK: - Private

	private func playerHits(_ enemy: Enemy) {
		guard !enemy.isBlinking else { return }
		play(sound: .hitPlayer)

		enemy.isBlinking = true
		enemy.explode {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				enemy.respawnAtInitialFrame()
				enemy.isBlinking = false
				enemy.show(after: 1)
			}
		}
	}

	private func playerGetsHit(from enemy: Enemy) {
		guard !enemy.isBlinking else { return }
		play(sound: .hitPlayer)

		enemy.wantSpawn = true
		currentLives -= 1
		delegate?.didUpdateLives(currentLives)
		currentLives > 0 ? respawnPlayer() : gameOver()
	}

	private func respawnPlayer() {
		player.isBlinking = true
		UIView.animate(withDuration: 0.4) {
			self.player.respawnAtInitialFrame()
			self.mazeView.follow(self.player)
		} completion: { _ in
			self.player.blink(2) {
				self.player.isBlinking = false
			}
		}
	}
}