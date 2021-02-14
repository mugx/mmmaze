//
//  GameInteractor.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

protocol GameInteractorDelegate: class {
	func didUpdate(score: UInt)
	func didUpdate(time: TimeInterval)
	func didUpdate(lives: UInt)
	func didUpdate(level: UInt)
	func didHurryUp()
	func didGameOver(with score: UInt)
}

class GameInteractor {
	private enum State {
		case idle
		case gameOver
		case started
		case running
	}

	private var currentScore: UInt = 0 { didSet { delegate?.didUpdate(score: currentScore) } }
	private var currentLevel: UInt = 0 { didSet { delegate?.didUpdate(level: currentLevel) } }
	private var enemyInteractor: EnemyInteractor!
	private var mazeInteractor: MazeInteractor!
	private var playerInteractor: PlayerInteractor!
	private var timeInteractor: TimeInteractor!
	private var state: State = .idle
	private unowned let gameView: UIView
	private weak var delegate: GameInteractorDelegate?

	init(gameView: UIView, delegate: GameInteractorDelegate) {
		self.gameView = gameView
		self.delegate = delegate
	}

	// MARK: - Private

	func start(level: UInt) {
		let completion = { [self] in
			state = .idle
			currentLevel = level
			gameView.transform = .identity
			timeInteractor = TimeInteractor(delegate: self)
			mazeInteractor = MazeInteractor(gameView: gameView, levelNumber: currentLevel)
			enemyInteractor = EnemyInteractor(mazeInteractor: mazeInteractor)
			playerInteractor = PlayerInteractor(delegate: self, mazeInteractor: mazeInteractor)
			mazeInteractor.follow(playerInteractor.player)
			state = .started
			play(sound: .startGame)
		}

		gameView.fadeIn {
			completion()
		}
	}

	private func gameOver() {
		guard state == .running else { return }

		state = .gameOver
		play(sound: .gameOver)
		ScoreManager.save(currentScore)

		playerInteractor.player.explode {
			self.delegate?.didGameOver(with: self.currentScore)
		}
	}
}

// MARK: - DisplayLinkDelegate

extension GameInteractor: DisplayLinkDelegate {
	func start() {
		switch state {
		case .idle, .gameOver:
			play(sound: .startGame)
			currentScore = 0
			start(level: 1)
		default:
			break
		}
	}

	func update(delta: TimeInterval) {
		switch state {
		case .running:
			enemyInteractor.update(delta: delta, playerInteractor: playerInteractor)
			mazeInteractor.update(playerInteractor: playerInteractor, enemyInteractor: enemyInteractor)
			fallthrough
		case .started:
			timeInteractor.update(delta)
			playerInteractor.update(delta, enemyInteractor: enemyInteractor)
		default:
			break
		}
	}
}

// MARK: - GestureRecognizerDelegate

extension GameInteractor: GestureRecognizerDelegate {
	func didSwipe(_ direction: Direction) {
		state = .running
		playerInteractor.move(to: direction)
	}
}

// MARK: - PlayerInteractorDelegate

extension GameInteractor: PlayerInteractorDelegate {
	func didUpdate(lives: UInt) {
		delegate?.didUpdate(lives: lives)
	}

	func didHitGoal() {
		start(level: currentLevel + 1)
	}

	func didGetBonus(score: UInt) {
		currentScore += score
	}

	func didGameOver(from interactor: PlayerInteractor) {
		gameOver()
	}
}

// MARK: - TimeInteractorDelegate

extension GameInteractor: TimeInteractorDelegate {
	func didUpdate(time: TimeInterval) {
		delegate?.didUpdate(time: time)
	}

	func didHurryUp() {
		delegate?.didHurryUp()
	}

	func didGameOver(from timeInteractor: TimeInteractor) {
		gameOver()
	}
}
