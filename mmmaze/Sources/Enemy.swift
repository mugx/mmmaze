//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Enemy: BaseEntity {
	var gameInteractor: GameInteractor? { return interactor.gameInteractor }
	var path = Path()
	var wantSpawn: Bool = false
	var timeAccumulator: TimeInterval = 0.0
	private let interactor: EnemyInteractor
	private static let SPEED = 1.5

	init(interactor: EnemyInteractor) {
		self.interactor = interactor

		super.init(type: .enemy)

		assignSpeed()
		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public
	
	func spawn() -> Enemy {
		wantSpawn = false

		let spawnedEnemy = Enemy(interactor: interactor)
		spawnedEnemy.frame = frame
		spawnedEnemy.show(after: 0.5)
		return spawnedEnemy
	}
	
	func update(_ delta: TimeInterval) {
		timeAccumulator += delta

		calculatePath()
		decideNextMove(delta)

		var frame = self.frame

		// check vertical collision
		var frameOnMove = frame.translate(y: velocity.y)
		if !gameInteractor!.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.x != 0 && lastDirection?.isVertical ?? false {
				velocity = CGPoint(x: 0, y: velocity.y)
			}
		}

		// check horizontal collision
		frameOnMove = frame.translate(x: velocity.x)
		if !gameInteractor!.checkWallCollision(frameOnMove) {
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

	override func respawnAtInitialFrame() {
		visible = false
		super.respawnAtInitialFrame()
	}

	func didSwipe(_ direction: Direction) {
		lastDirection = direction

		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: 0)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: 0)
		case .up:
			velocity = CGPoint(x: 0, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: 0, y: CGFloat(speed))
		}
	}

	// MARK: - Private

	private func assignSpeed() {
		let maxSpeed = gameInteractor!.playerInteractor.player.speed
		speed = Float(Double.random(in: Self.SPEED - 0.2 ... Self.SPEED + 0.2))
		speed = speed + 0.1 * Float((gameInteractor!.stats.currentLevel - 1))

		if speed > maxSpeed {
			speed = maxSpeed - 0.2
		}
	}
}
