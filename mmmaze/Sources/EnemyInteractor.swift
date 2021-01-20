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

	let gameInteractor: GameInteractor!
	private(set) var enemies: [Enemy] = []
	private var enemyTimeAccumulator: TimeInterval = 0

	public init(gameInteractor: GameInteractor) {
		self.gameInteractor = gameInteractor
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
		enemy.add(to: gameInteractor.mazeView)
		enemy.show(after: 1)
	}

	private func updateEnemies(_ delta: TimeInterval) {
		enemies.forEach {
			if $0.visible {
				$0.update(delta)
			}
		}
	}

	// MARK: - Hits

	private func hitBomb(_ enemy: Enemy, entity: BaseEntity) {
		enemy.wantSpawn = true
		entity.visible = false
		gameInteractor.items.remove(entity)
	}

	private func hitPlayer(_ enemy: Enemy, entity: BaseEntity) {
		guard let player = entity as? Player else { return }
		guard !player.isBlinking, !enemy.isBlinking else { return }

		play(sound: .hitPlayer)

		if player.isInvulnerable {
			enemy.isBlinking = true
			enemy.explode {
				DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
					enemy.respawnAtInitialFrame()
					enemy.isBlinking = false
					enemy.show(after: 1)
				}
			}
		} else {
			enemy.wantSpawn = true
			gameInteractor.stats.currentLives -= 1
			gameInteractor.delegate?.didUpdate(lives: gameInteractor.stats.currentLives)
			gameInteractor.stats.currentLives > 0 ? player.respawnPlayer() : gameInteractor.gameOver()
		}
	}
}
