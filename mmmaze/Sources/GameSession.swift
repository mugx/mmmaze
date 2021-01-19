//
//  GameSession.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

protocol GameSessionDelegate {
	func didUpdate(score: UInt)
	func didUpdate(time: TimeInterval)
	func didUpdate(lives: UInt)
	func didUpdate(level: UInt)
	func didHurryUp()
	func didGameOver(_ gameSession: GameSession, with score: UInt)
}

class GameSession {
	static let BASE_MAZE_DIMENSION: Int = 9
	var delegate: GameSessionDelegate?
	var enemyInteractor: EnemyInteractor!
	var playerInteractor: PlayerInteractor!
	var mazeInteractor = MazeInteractor()
	var collisionInteractor: CollisionInteractor?
	var player: Player { playerInteractor.player }
	var stats = GameStats()
	var numRow: Int = 0
	var numCol: Int = 0
	var walls: Set<Tile> = []
	var items: Set<Tile> = []
	var gameView: UIView!
	var mazeView: UIView!
	var goal: Tile!

	init() {
		collisionInteractor = CollisionInteractor(self)
	}

	func attach(to gameView: UIView, with delegate: GameSessionDelegate) {
		self.gameView = gameView
		self.delegate = delegate
	}

	func startLevel(_ levelNumber: UInt = 1) {
		gameView.alpha = 0

		// setup gameplay varables
		stats.startLevel(levelNumber)

		if levelNumber == 1 {
			play(sound: .startGame)
			numCol = Self.BASE_MAZE_DIMENSION
			numRow = Self.BASE_MAZE_DIMENSION
		} else {
			play(sound: .levelChange)
		}

		// reset random rotation
		gameView.transform = CGAffineTransform(rotationAngle: 0)

		// remove old views
		for view in mazeView?.subviews ?? [] {
			view.isHidden = true
			view.removeFromSuperview()
		}

		// init scene elements
		numCol = (numCol + 2) < 30 ? numCol + 2 : numCol
		numRow = (numRow + 2) < 30 ? numRow + 2 : numRow
		makeMaze()

		// setup interactor
		enemyInteractor = EnemyInteractor(gameSession: self)
		playerInteractor = PlayerInteractor(gameSession: self)
		mazeView.follow(player)

		// update external delegate
		delegate?.didUpdate(score: stats.currentScore)
		delegate?.didUpdate(lives: stats.currentLives)

		UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
			self.gameView.alpha = 1
		} completion: { _ in
			self.delegate?.didUpdate(level: self.stats.currentLevel)
		}
	}

	func checkWallCollision(_ frame: Frame) -> Bool {
		return walls.contains { $0.frame.collides(frame) }
	}

	func gameOver() {
		guard !stats.isGameOver else { return }

		stats.isGameOver = true
		play(sound: .gameOver)
		player.explode {
			self.delegate?.didGameOver(self, with: self.stats.currentScore)
		}
	}

	// MARK: - Private

	private func updateTime(_ delta: TimeInterval) {
		stats.currentTime = stats.currentTime - delta > 0 ? stats.currentTime - delta : 0
		delegate?.didUpdate(time: stats.currentTime)

		if stats.currentTime <= 10 {
			delegate?.didHurryUp()
		}

		if stats.currentTime <= 0 {
			gameOver()
		}
	}
}

// MARK: - DisplayLinkDelegate

extension GameSession: DisplayLinkDelegate {
	func start() {
		if !stats.isGameStarted {
			stats.isGameStarted = true
			startLevel()
		}

		items.forEach { $0.restoreAnimations() }
	}

	func update(delta: TimeInterval) {
		guard !stats.isGameOver else { return }

		updateTime(delta)

		guard stats.isGameStarted else { return }

		enemyInteractor.update(delta)
		player.update(delta)
		mazeView.follow(player)
		collisionInteractor?.update()
	}
}

// MARK: - GestureRecognizerDelegate

extension GameSession: GestureRecognizerDelegate {
	func didSwipe(_ direction: Direction) {
		stats.isGameStarted = true
		player.didSwipe(direction)
		play(sound: .selectItem)
	}
}

// MARK: - CollisionInteractorDelegate

extension GameSession: CollisionInteractorDelegate {
	func didCollideGoal() {
		stats.currentScore += 100
		startLevel(stats.currentLevel + 1)
	}
}
