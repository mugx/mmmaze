//
//  GameSession.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

protocol GameSessionDelegate {
	func didUpdateScore(_ score: UInt)
	func didUpdateTime(_ time: TimeInterval)
	func didUpdateLives(_ livesCount: UInt)
	func didUpdateLevel(_ levelCount: UInt)
	func didHurryUp()
	func didGameOver(_ gameSession: GameSession)
}

class GameSession {
	static let MAX_TIME: TimeInterval = 60
	static let MAX_LIVES: UInt = 3
	static let BASE_MAZE_DIMENSION: Int = 9
	var delegate: GameSessionDelegate?
	var currentLives: UInt = 0
	var currentTime: TimeInterval = 0
	var isGameOver: Bool = false
	var numRow: Int = 0
	var numCol: Int = 0
	var enemyCollaborator: EnemyCollaborator!
	var player: Player!
	var currentLevel: UInt = 0
	var currentScore: UInt = 0
	var walls: Set<Tile> = []
	var items: Set<Tile> = []
	var mazeView: UIView!
	var gameView: UIView!
	var mazeGoalTile: Tile!
	var mazeRotation: CGFloat = 0
	var isGameStarted: Bool = false

	init(view: UIView) {
		self.gameView = view
	}

	func play(sound: SoundType) {
		playSound(sound)
	}

	func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		isGameStarted = true
		player.didSwipe(direction)
		play(sound: .selectItem)
	}

	func startLevel(_ levelNumber: UInt) {
		gameView.alpha = 0

		// setup gameplay varables
		currentLevel = levelNumber
		currentTime = Self.MAX_TIME
		isGameStarted = false
		isGameOver = false

		if levelNumber == 1 {
			play(sound: .startGame)
			currentScore = 0
			currentLives = Self.MAX_LIVES
			
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
		makePlayer()
		mazeView.follow(player)

		// setup collaborator
		enemyCollaborator = EnemyCollaborator(gameSession: self)

		// update external delegate
		delegate?.didUpdateScore(currentScore)
		delegate?.didUpdateLives(currentLives)

		UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions.curveEaseOut) {
			self.gameView.alpha = 1
		} completion: { _ in
			self.delegate?.didUpdateLevel(self.currentLevel)
		}
	}

	func update(_ delta: TimeInterval) {
		guard !isGameOver else { return }

		updateTime(delta)

		guard isGameStarted else { return }

		enemyCollaborator.update(delta)
		player.update(delta)
		mazeView.follow(player)

		playerGoalCollision()
		playerVsEnemiesCollision()
		playerWallsCollision()
		itemsCollisions()
	}
	
	func gameOver() {
		guard !isGameOver else { return }

		isGameOver = true
		play(sound: .gameOver)
		player.explode {
			self.delegate?.didGameOver(self)
		}
	}

	// MARK: - Private

	private func updateTime(_ delta: TimeInterval) {
		currentTime = currentTime - delta > 0 ? currentTime - delta : 0
		delegate?.didUpdateTime(currentTime)

		if currentTime <= 10 {
			delegate?.didHurryUp()
		}

		if currentTime <= 0 {
			gameOver()
		}
	}

	private func makePlayer() {
		player?.removeFromSuperview()
		player = Player(gameSession: self)
		mazeView.addSubview(player)
	}

	func playerWallsCollision() {
		guard player.power > 0 else { return }

		for wall in walls {
			guard wall.isDestroyable, player.frame.isNeighbour(of: wall.frame) else { continue }

			wall.explode()
			walls.remove(wall)
		}
	}
}
