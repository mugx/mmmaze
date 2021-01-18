//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Enemy: Tile {
	var path = Path()
	var wantSpawn: Bool = false
	var timeAccumulator: TimeInterval = 0.0
	private static let SPEED = 1.5

	init(gameSession: GameSession) {
		super.init(type: .enemy)

		self.gameSession = gameSession

		assignSpeed()
		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public
	
	func spawn() -> Enemy {
		wantSpawn = false

		let spawnedEnemy = Enemy(gameSession: gameSession!)
		spawnedEnemy.frame = frame
		spawnedEnemy.show(after: 0.5)
		return spawnedEnemy
	}
	
	override func update(_ delta: TimeInterval) {
		timeAccumulator += delta

		calculatePath()
		decideNextMove(delta)

		super.update(delta)
	}

	override func respawnAtInitialFrame() {
		visible = false
		super.respawnAtInitialFrame()
	}

	override func didSwipe(_ direction: Direction) {
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

	func hitted() {
		guard !isBlinking else { return }

		play(sound: .hitPlayer)
		isBlinking = true
		explode {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.respawnAtInitialFrame()
				self.isBlinking = false
				self.show(after: 1)
			}
		}
	}

	// MARK: - Private

	private func assignSpeed() {
		speed = Float(Double.random(in: Self.SPEED - 0.2 ... Self.SPEED + 0.2))
		speed = speed + 0.1 * Float((gameSession!.stats.currentLevel - 1))

		if speed > gameSession!.player.speed {
			speed = gameSession!.player.speed - 0.2
		}
	}
}
