//
//  GameSession.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension GameSession {
	static let MAX_TIME: TimeInterval = 60
	static let MAX_LIVES: UInt = 3
	static let BASE_MAZE_DIMENSION: UInt = 7

	@objc func play(sound: SoundType) {
		playSound(sound)
	}

	@objc func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		isGameStarted = true
		player.didSwipe(direction)
		play(sound: .selectItem)
	}

	@objc func startLevel(_ levelNumber: UInt) {
		gameView.alpha = 0

		//--- setup gameplay varables ---//
		currentLevel = levelNumber
		currentTime = Self.MAX_TIME
		isGameStarted = false

		if levelNumber == 1 {
			play(sound: .startGame)
			currentScore = 0
			currentLives = Self.MAX_LIVES
			
			numCol = Self.BASE_MAZE_DIMENSION;
			numRow = Self.BASE_MAZE_DIMENSION
		} else {
			play(sound: .levelChange)
		}

		//--- reset random rotation ---//
		gameView.transform = CGAffineTransform(rotationAngle: 0)

		//--- remove old views ---//
		for view in mazeView?.subviews ?? [] {
			view.isHidden = true
			view.removeFromSuperview()
		}

		//--- init scene elements ---//
		numCol = (numCol + 2) < 30 ? numCol + 2 : numCol
		numRow = (numRow + 2) < 30 ? numRow + 2 : numRow
		makeMaze()
		makePlayer()
		mazeView.follow(player)

		//--- setup collaborator ---//
		enemyCollaborator = EnemyCollaborator(gameSession: self)

		//--- update external delegate ---//
		delegate.didUpdateScore(currentScore)
		delegate.didUpdateLives(currentLives)

		UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
			self.gameView.alpha = 1
		} completion: { _ in
			self.delegate.didUpdateLevel(self.currentLevel)
		}
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
