//
//  EnemyCollaborator.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

@objc class EnemyCollaborator: NSObject {
	@objc var enemies: [Enemy] = []
	@objc var spawnableEnemies: [Enemy] = []
	private let gameSession: GameSession!
	private let MAX_ENEMIES = 5
	private let MIN_SPEED = 1.5
	private var speed: Double = 0
	private var enemyTimeAccumulator: TimeInterval = 0

	@objc public init(gameSession: GameSession) {
		self.gameSession = gameSession

		super.init()

		initEnemies()
	}

	@objc func spawn(from enemy: Enemy) {
		guard let indexToSpawn = spawnableEnemies.firstIndex(where: { $0.isHidden }) else { return }
		let enemyToSpawn = spawnableEnemies[indexToSpawn]
		let size = CGSize(width: TILE_SIZE, height: TILE_SIZE)
		enemyToSpawn.animationImages = UIImage(named: "enemy")?.sprites(with: size)
		enemyToSpawn.startAnimating()
		spawnableEnemies.remove(at: indexToSpawn)
		enemies.append(enemyToSpawn)

		UIView.animateKeyframes(withDuration: 0.5, delay: 1.0) {
			enemyToSpawn.isHidden = false
			enemyToSpawn.alpha = 1.0
		} completion: { _ in
			enemyToSpawn.speed = Float(self.speed)
		}

		enemyToSpawn.frame = enemy.frame;
	}

	@objc func update(_ delta: TimeInterval) {
		enemyTimeAccumulator += delta
		if enemyTimeAccumulator > 1 {
			enemyTimeAccumulator = 0
			let enemiesArray = enemies.isEmpty ? spawnableEnemies : enemies
			if let enemy = enemiesArray.first(where: { $0.wantSpawn }) {
				enemy.wantSpawn = false
				spawn(from: enemy)
			}
		}

		enemies.forEach {
			$0.update(CGFloat(delta))
		}
	}

	// MARK: - Private

	func initEnemies() {
		refreshEnemySpeed()

		for i in 0 ..< MAX_ENEMIES {
			let enemy = Enemy(gameSession: gameSession)
			enemy.animationDuration = 0.4
			enemy.animationRepeatCount = 0
			enemy.alpha = 0.0
			enemy.isHidden = true
			enemy.wantSpawn = i == 0
			gameSession.mazeView.addSubview(enemy)
			spawnableEnemies.append(enemy)
		}
	}

	private func refreshEnemySpeed() {
		let level = gameSession.currentLevel - 1
		speed = Double(MIN_SPEED + 0.1 * Double(level))
		if speed > Player.SPEED {
			speed = Player.SPEED
		}
	}
}
