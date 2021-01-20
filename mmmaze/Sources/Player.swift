//
//  Player.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Player: BaseEntity {
	var gameSession: GameSession { return interactor.gameSession }
	override var color: UIColor { isInvulnerable ? .red : .white }
	var isInvulnerable: Bool { power > 0 }
	var power: UInt = 0 { didSet { refresh() } }
	private let interactor: PlayerInteractor
	private static let SPEED = 3.0

	deinit {
		remove()
	}

	init(interactor: PlayerInteractor) {
		self.interactor = interactor
		super.init(type: .player)

		self.speed = Float(Self.SPEED)

		respawnAtInitialFrame()
		refresh()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func didSwipe(_ direction: Direction) {
		lastDirection = direction

		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: velocity.y)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: velocity.y)
		case .up:
			velocity = CGPoint(x: velocity.x, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: velocity.x, y: CGFloat(speed))
		}
	}

	func update(_ delta: TimeInterval) {
		var frame = self.frame

		// check vertical collision
		var frameOnMove = frame.translate(y: velocity.y)
		if !gameSession.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.x != 0 && lastDirection?.isVertical ?? false {
				velocity = CGPoint(x: 0, y: velocity.y)
			}
		}

		// check horizontal collision
		frameOnMove = frame.translate(x: velocity.x)
		if !gameSession.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.y != 0 && lastDirection?.isHorizontal ?? false {
				velocity = CGPoint(x: velocity.x, y: 0)
			}
		}

		if self.frame != frame {
			self.frame = frame
		} else {
			velocity = .zero
		}
	}

	func hitted(from enemy: Enemy) {
		// TO MOVE THIS CODE AWAY FROM HERE:
		
		guard !enemy.isBlinking else { return }
		play(sound: .hitPlayer)

		enemy.wantSpawn = true
		gameSession.stats.currentLives -= 1
		gameSession.delegate?.didUpdate(lives: gameSession.stats.currentLives)
		gameSession.stats.currentLives > 0 ? respawnPlayer() : gameSession.gameOver()
	}

	func addPower() {
		power += 1
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
			self.power -= self.isInvulnerable ? 1 : 0
		}
	}

	private func respawnPlayer() {
		isBlinking = true
		UIView.animate(withDuration: 0.4) {
			self.respawnAtInitialFrame()
			self.gameSession.mazeView.follow(self)
		} completion: { _ in
			self.blink(2) {
				self.isBlinking = false
			}
		}
	}
}
