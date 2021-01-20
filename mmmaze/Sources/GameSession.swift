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
	var mazeInteractor: MazeInteractor!
	var stats = GameStats()
	var gameView: UIView!
	var mazeView: UIView!

	var walls: Set<BaseEntity> {
		get { mazeInteractor.walls }
		set { mazeInteractor.walls = newValue}
	}

	var items: Set<BaseEntity> {
		get { mazeInteractor.items }
		set { mazeInteractor.items = newValue}
	}

	var goal: BaseEntity! {
		get { mazeInteractor.goal }
		set { mazeInteractor.goal = newValue }
	}

	func attach(to gameView: UIView, with delegate: GameSessionDelegate) {
		self.gameView = gameView
		self.delegate = delegate
	}

	func startLevel(_ levelNumber: UInt = 1) {
		gameView.alpha = 0

		// setup gameplay varables
		stats.startLevel(levelNumber)
		play(sound: levelNumber == 1 ? .startGame : .levelChange)

		// reset random rotation
		gameView.transform = CGAffineTransform(rotationAngle: 0)

		// remove old views
		for view in mazeView?.subviews ?? [] {
			view.isHidden = true
			view.removeFromSuperview()
		}

		// init scene elements
		//makeMaze()
		mazeView = UIView(frame: gameView.frame)
		gameView.addSubview(mazeView)
		stats.mazeRotation = 0
		mazeInteractor = MazeInteractor(
			mazeView: mazeView,
			dimension: (Self.BASE_MAZE_DIMENSION + Int(levelNumber) * 2) % 30
		)

		// setup interactor
		enemyInteractor = EnemyInteractor(gameSession: self)
		playerInteractor = PlayerInteractor(gameSession: self)
		mazeView.follow(playerInteractor.player)

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
		playerInteractor.player.explode {
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
		playerInteractor.update(delta)

		for item in items {
			playerInteractor.collide(with: item)
			enemyInteractor.collide(with: item)
		}
		mazeView.follow(playerInteractor.player)
	}
}

// MARK: - GestureRecognizerDelegate

extension GameSession: GestureRecognizerDelegate {
	func didSwipe(_ direction: Direction) {
		stats.isGameStarted = true
		playerInteractor.didSwipe(direction)
	}
}

// MARK: - CollisionInteractorDelegate

extension GameSession: PlayerInteractorDelegate {
	func didCollideGoal() {
		stats.currentScore += 100
		startLevel(stats.currentLevel + 1)
	}

	func didHitWhirlwind() {
		stats.mazeRotation += .pi / 2
		
		UIView.animate(withDuration: 0.2) {
			self.gameView.transform = self.gameView.transform.rotated(by: .pi / 2)
			self.playerInteractor.player.transform = CGAffineTransform(rotationAngle: -self.stats.mazeRotation)
			self.items.forEach { $0.transform = CGAffineTransform(rotationAngle: -self.stats.mazeRotation) }
			self.walls.forEach { $0.transform = .identity }
			self.enemyInteractor.enemies.forEach { $0.transform = CGAffineTransform(rotationAngle: -self.stats.mazeRotation) }
		}
	}
}
