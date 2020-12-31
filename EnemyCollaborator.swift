//
//  EnemyCollaborator.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

@objc class EnemyCollaborator: NSObject {
	private let gameSession: GameSession!
	private var enemies: [Enemy] = []
	private var enemyTimeAccumulator: TimeInterval = 0

	@objc public init(gameSession: GameSession) {
		self.gameSession = gameSession

		super.init()
	}

	deinit {
		enemies.forEach { $0.removeFromSuperview() }
	}

	// MARK: - Public

	@objc func collide(with tile: Tile, completion: (Enemy) -> ()){
		enemies.forEach { enemy in
			if enemy.visible && enemy.frame.intersects(tile.frame) {
				completion(enemy)
			}
		}
	}

	@objc func update(_ delta: TimeInterval) {
		enemyTimeAccumulator += delta
		if enemyTimeAccumulator > 1 {
			enemyTimeAccumulator = 0

			// spawn first enemy
			if enemies.isEmpty {
				let enemy = Enemy(gameSession: self.gameSession)
				self.enemies.append(enemy)
				self.gameSession.mazeView.addSubview(enemy)
				enemy.show()
			}

			// search for enemy to spawn
			if let spawnableEnemy = enemies.first(where: { $0.wantSpawn }) {
				let spawnedEnemy = spawnableEnemy.spawn()
				enemies.append(spawnedEnemy)
				gameSession.mazeView.addSubview(spawnedEnemy)
			}
		}

		enemies.forEach {
			if $0.visible {
				$0.update(CGFloat(delta))
			}
		}
	}
}
