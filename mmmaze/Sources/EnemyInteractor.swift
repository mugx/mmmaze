//
//  EnemyInteractor.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class EnemyInteractor {
	var collisionActions: [BaseEntityType: (Enemy, BaseEntity)->()] {
		[
			.bomb: hitBomb,
			.player: hitPlayer
		]
	}

	let gameSession: GameSession!
	private(set) var enemies: [Enemy] = []
	private var enemyTimeAccumulator: TimeInterval = 0

	public init(gameSession: GameSession) {
		self.gameSession = gameSession
	}

	// MARK: - Public

	func collide(with entity: BaseEntity) {
		guard [.bomb, .player].contains(entity.type) else { return }
		guard let enemy = enemies.first(where: { $0.collides(entity) }) else { return }

		collisionActions[entity.type]?(enemy, entity)
	}

	func update(_ delta: TimeInterval) {
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
			show(Enemy(interactor: self))
		} else if let enemy = enemies.first(where: { $0.wantSpawn }) {
			show(enemy.spawn())
		}
	}

	private func show(_ enemy: Enemy) {
		play(sound: .enemySpawn)
		enemies.append(enemy)
		//enemy.speed = enemySpeed()
		enemy.add(to: gameSession.mazeView)
		enemy.show(after: 1)
	}

	private func updateEnemies(_ delta: TimeInterval) {
		enemies.forEach {
			if $0.visible {
				$0.update(delta)
			}
		}
	}

//	private func enemySpeed() -> Float {
//		var speed = Float(Double.random(in: Self.ENEMY_SPEED - 0.2 ... Self.ENEMY_SPEED + 0.2))
//		speed = speed + 0.1 * Float((gameSession!.stats.currentLevel - 1))
//
//		if speed > gameSession.playerInteractor.player.speed {
//			speed = gameSession.playerInteractor.player.speed - 0.2
//		}
//		return speed
//	}

	// MARK: - Hits

	private func hitBomb(_ enemy: Enemy, entity: BaseEntity) {
		enemy.wantSpawn = true
		entity.visible = false
		gameSession.items.remove(entity)
	}

	private func hitPlayer(_ enemy: Enemy, entity: BaseEntity) {
		guard let player = entity as? Player else { return }
		guard !player.isBlinking else { return }

		if player.isInvulnerable {
			enemy.hitted()
		} else {
			player.hitted(from: enemy)
		}
	}
}
