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

	func update(delta: TimeInterval, target: Frame) {
		timeAccumulator += delta

		switch timeAccumulator {
		case 1...:
			spawn()
			timeAccumulator = 0
			fallthrough
		default:
			enemies.forEach {
				$0.update(delta: delta, target: target)
			}
		}
	}

	// MARK: - Private

	private func spawn() {
		switch (empty: enemies.isEmpty, spawnable: enemies.first(where: { $0.wantSpawn })) {
		case (empty: true, _):
			show(Enemy(interactor: self, mazeInteractor: mazeInteractor))
		case (empty: false, spawnable: let enemy?):
			let spawned = Enemy(interactor: self, mazeInteractor: mazeInteractor)
			spawned.frame = enemy.frame
			show(spawned)
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
		guard let player = entity as? Player else { return }
		guard !player.isBlinking, !enemy.isBlinking else { return }

		play(sound: .hitPlayer)
		enemy.wantSpawn = true
		player.takeHit()
	}
}
