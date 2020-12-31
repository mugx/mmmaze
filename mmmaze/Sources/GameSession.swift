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

	// MARK: - Updates

	@objc func update(delta: TimeInterval) {
		updateTime(delta)
		mazeView.center(to: player)
		
		guard isGameStarted else { return }

		enemyCollaborator.update(delta)
		player.update(delta)

		checkCollisionPlayerVsEnemies()
		checkGoalHit()
	}
	
	@objc func updateTime(_ delta: TimeInterval) {
		currentTime = currentTime - delta > 0 ? currentTime - delta : 0
		delegate.didUpdateTime(currentTime)

		if currentTime <= 10 {
			delegate.didHurryUp()
		}

		if currentTime <= 0 {
			gameOver()
		}
	}

	// MARK: - Private

	@objc private func checkCollisionPlayerVsEnemies() {
		guard !player.isBlinking else { return }

		var collided = false
		enemyCollaborator.collide(with: player) { (enemy) in
			guard !collided else { return }

			collided = true
			if !player.isAngry {
				playerGetsHit(from: enemy)
			} else {
				playerHits(enemy)
			}
		}
	}

	private func checkGoalHit() {
		guard
			mazeGoalTile.tag == TyleType.TTMazeEnd_open.rawValue &&
				player.frame.intersects(mazeGoalTile.frame) else {
			return
		}

		currentScore += 100
		startLevel(currentLevel + 1)
	}


	private func playerGetsHit(from enemy: Enemy) {
		play(sound: .hitPlayer)

		enemy.wantSpawn = true
		currentLives -= 1
		delegate.didUpdateLives(currentLives)

		if currentLives > 0 {
			respawnPlayer()
		} else {
			gameOver()
		}
	}

	private func playerHits(_ enemy: Enemy) {
		play(sound: .hitPlayer)

		enemy.explode {
			enemy.respawnAtInitialFrame()
			enemy.show()
			self.player.isAngry = false
		}
	}

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

	private func gameOver() {
		guard !isGameOver else { return }

		isGameOver = true
		play(sound: .gameOver)
		player.explode {
			self.delegate.didGameOver(self)
		}
	}
}
