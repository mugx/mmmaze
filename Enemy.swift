//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

class Enemy: Tile {
	@objc var wantSpawn: Bool = false
	var visible: Bool { alpha == 1 && !isHidden }
	
	private static let SPEED = 1.5
	var path: NSMutableArray
	var timeAccumulator: TimeInterval = 0.0

	init(gameSession: GameSession) {
		path = NSMutableArray()

		super.init(frame: .zero)

		self.gameSession = gameSession

		assignSpeed()
		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	@objc func show(after time: TimeInterval = 1.0) {
		UIView.animate(withDuration: 0.5, delay: time) {
			self.isHidden = false
			self.alpha = 1.0
		} completion: { _ in
			self.speed = Float(self.speed)
		}
	}
	
	@objc func spawn() -> Enemy {
		wantSpawn = false

		let spawnedEnemy = Enemy(gameSession: gameSession)
		spawnedEnemy.frame = frame
		spawnedEnemy.show(after: 0)
		return spawnedEnemy
	}
	
	@objc override func update(_ delta: TimeInterval) {
		timeAccumulator += delta

		calculatePath()

		if path.count > 0 {
			refinesPath()
			decideNextMove(delta)
		}

		super.update(delta)
	}

	override func respawnAtInitialFrame() {
		isHidden = true
		alpha = 0.0

		setupAnimations()
		super.respawnAtInitialFrame()
	}

	//MARK: - Private

	private func assignSpeed() {
		speed = Float(Double.random(in: Self.SPEED - 0.2 ... Self.SPEED + 0.2))
	}

	private func setupAnimations() {
		animationDuration = Double.random(in: 0.3 ... 0.6)
		animationImages = UIImage(named: "enemy")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
		startAnimating()
	}
}
