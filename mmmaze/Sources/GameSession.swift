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

	@objc func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		isGameStarted = true
		player.didSwipe(direction)
		play(sound: .selectItem)
	}

	@objc func update(delta: TimeInterval) {
		updateTime(delta)

		guard isGameStarted else { return }

		enemyCollaborator.update(delta)
		player.update(delta)
		mazeView.follow(player)

		checkCollisionPlayerVsEnemies()
		checkGoalHit()
	}

	func gameOver() {
		guard !isGameOver else { return }

		isGameOver = true
		play(sound: .gameOver)
		player.explode {
			self.delegate.didGameOver(self)
		}
	}

	// MARK: - Private

	private func updateTime(_ delta: TimeInterval) {
		currentTime = currentTime - delta > 0 ? currentTime - delta : 0
		delegate.didUpdateTime(currentTime)

		if currentTime <= 10 {
			delegate.didHurryUp()
		}

		if currentTime <= 0 {
			gameOver()
		}
	}

	@objc private func checkCollisionPlayerVsEnemies() {
		guard !player.isBlinking else { return }

		var collided = false
		enemyCollaborator.collide(with: player) { (enemy) in
			guard !collided else { return }
			collided = true
			
			if player.isAngry {
				playerHits(enemy)
			} else {
				playerGetsHit(from: enemy)
			}
		}
	}

	func playerHits(_ enemy: Enemy) {
		guard !enemy.isBlinking else { return }
		play(sound: .hitPlayer)

		player.isAngry = false
		enemy.isBlinking = true
		enemy.explode {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				enemy.respawnAtInitialFrame()
				enemy.isBlinking = false
				enemy.show(after: 1)
			}
		}
	}

	func playerGetsHit(from enemy: Enemy) {
		guard !enemy.isBlinking else { return }
		play(sound: .hitPlayer)

		enemy.wantSpawn = true
		currentLives -= 1
		delegate.didUpdateLives(currentLives)
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

	private func checkGoalHit() {
		guard
			mazeGoalTile.tag == TyleType.mazeEnd_open.rawValue &&
				player.frame.intersects(mazeGoalTile.frame) else {
			return
		}

		currentScore += 100
		startLevel(currentLevel + 1)
	}
}
