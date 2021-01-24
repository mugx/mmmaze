//
//  EnemyInteractor.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class EnemyInteractor {
	private var collisionActions: [BaseEntityType: (Enemy, BaseEntity)->()] {
		[
			.bomb: hitBomb,
			.player: hitPlayer
		]
	}

	private unowned let mazeInteractor: MazeInteractor
	private var enemies: [Enemy] = []
	private var timeAccumulator: TimeInterval = 0

	init(mazeInteractor: MazeInteractor) {
		self.mazeInteractor = mazeInteractor
	}

	// MARK: - Public

	func collide(with entity: BaseEntity) {
		guard [.bomb, .player].contains(entity.type) else { return }
		guard let enemy = enemies.first(where: { $0.collides(entity) }) else { return }

		collisionActions[entity.type]?(enemy, entity)
	}

	func update(delta: TimeInterval, playerInteractor: PlayerInteractor) {
		timeAccumulator += delta

		switch timeAccumulator {
		case 1...:
			spawn()
			timeAccumulator = 0
			fallthrough
		default:
			enemies.forEach {
				$0.update(delta: delta, target: playerInteractor.player.frame)
			}
		}
	}

	// MARK: - Private

	private func spawn() {
		switch (enemies.isEmpty, enemies.first(where: { $0.wantSpawn })) {
		case (true, _):
			show(Enemy(mazeInteractor: mazeInteractor))
		case (false, let spawnable?):
			show(Enemy(from: spawnable, mazeInteractor: mazeInteractor))
		default:
			break
		}
	}

	private func show(_ enemy: Enemy) {
		play(sound: .enemySpawn)
		enemies.append(enemy)
		mazeInteractor.add(enemy)
		enemy.show(after: 1)
	}

	// MARK: - Hits

	private func hitBomb(_ enemy: Enemy, entity: BaseEntity) {
		enemy.wantSpawn = true
		entity.visible = false
		mazeInteractor.remove(entity)
	}

	private func hitPlayer(_ enemy: Enemy, entity: BaseEntity) {
		guard let player = entity as? Player, !player.isBlinking else { return }

		play(sound: .hitPlayer)
		enemy.wantSpawn = true
		player.takeHit()
	}
}
