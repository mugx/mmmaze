//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Enemy: Tile {
	var wantSpawn: Bool = false
	var visible: Bool { alpha == 1 && !isHidden }
	var path: Path = Path()
	var timeAccumulator: TimeInterval = 0.0
	private static let SPEED = 1.5

	init(gameSession: GameSession) {
		super.init(frame: .zero)

		self.gameSession = gameSession

		assignSpeed()
		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func show(after time: TimeInterval = 1.0) {
		UIView.animate(withDuration: 0.5, delay: time) {
			self.isHidden = false
			self.alpha = 1.0
		} completion: { _ in
			self.speed = Float(self.speed)
		}
	}
	
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
		isHidden = true
		alpha = 0.0

		setupAnimations()
		super.respawnAtInitialFrame()
	}

	override func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		lastSwipe = direction

		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: 0)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: 0)
		case .up:
			velocity = CGPoint(x: 0, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: 0, y: CGFloat(speed))
		default:
			break
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

	private func setupAnimations() {
		animationDuration = Double.random(in: 0.3 ... 0.6)
		animationImages = TyleType.enemy.image?.sprites(with: TILE_SIZE)
		startAnimating()
	}
}
