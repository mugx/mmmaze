//
//  EnemyCollaborator.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

@objc class EnemyCollaborator: NSObject {
	let STARTING_CELL = CGPoint(x: 1, y: 1)
	let MAX_ENEMIES = 5
	let gameSession: GameSession!
	var enemyTimeAccumulator: TimeInterval = 0
	@objc var enemies: [Enemy] = []
	@objc var spawnableEnemies: [Enemy] = []
	let medusaWasOut: Bool = false
	var speed: Double = 0

	@objc public init(gameSession: GameSession) {
		self.gameSession = gameSession

		super.init()

		initEnemies()
	}

	func initEnemies() {
		let level = Double(gameSession.currentLevel - 1)
		self.speed = Double(Enemy.SPEED + 0.1 * level)
		if speed > Player.SPEED {
			speed = Player.SPEED
		}

		let initialTile_x = Double(STARTING_CELL.y * CGFloat(TILE_SIZE))
		let initialTile_y = Double(STARTING_CELL.x * CGFloat(TILE_SIZE))
		for i in 0 ..< MAX_ENEMIES {
			let rect = CGRect(
				x: initialTile_x + speed / 2.0,
				y: initialTile_y + speed / 2.0,
				width: TILE_SIZE - speed,
				height: TILE_SIZE - speed
			)

			let enemy = Enemy(frame: rect, gameSession: gameSession)
			enemy.animationDuration = 0.4
			enemy.animationRepeatCount = 0
			enemy.alpha = 0.0
			enemy.isHidden = true
			enemy.wantSpawn = i == 0
			gameSession.mazeView.addSubview(enemy)
			spawnableEnemies.append(enemy)
		}
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
}
