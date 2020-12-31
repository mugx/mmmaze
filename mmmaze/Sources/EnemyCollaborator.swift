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

			spawnEnemy()
		}

		updateEnemies(delta)
	}

	// MARK: - Private

	private func spawnEnemy() {
		if enemies.isEmpty {
			show(Enemy(gameSession: gameSession))
		} else if let enemy = enemies.first(where: { $0.wantSpawn }) {
			show(enemy.spawn())
		}
	}

	private func show(_ enemy: Enemy) {
		enemies.append(enemy)
		gameSession.mazeView.addSubview(enemy)
		enemy.show(after: 1)
	}

	private func updateEnemies(_ delta: TimeInterval) {
		enemies.forEach {
			if $0.visible {
				$0.update(delta)
			}
		}
	}
}