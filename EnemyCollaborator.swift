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

			spawnFirstEnemy()
			spawnEnemies()
		}

		updateEnemies(delta)
	}

	// MARK: - Private

	private func spawnFirstEnemy() {
		guard enemies.isEmpty else { return }

		let enemy = Enemy(gameSession: gameSession)
		enemies.append(enemy)
		gameSession.mazeView.addSubview(enemy)
		enemy.show()
	}

	private func spawnEnemies() {
		guard let spawnableEnemy = enemies.first(where: { $0.wantSpawn }) else { return }

		let spawnedEnemy = spawnableEnemy.spawn()
		enemies.append(spawnedEnemy)
		gameSession.mazeView.addSubview(spawnedEnemy)
	}

	private func updateEnemies(_ delta: TimeInterval) {
		enemies.forEach {
			if $0.visible {
				$0.update(delta)
			}
		}
	}
}
