//
//  PlayerInteractor.swift
//  mmmaze
//
//  Created by mugx on 18/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

protocol PlayerInteractorDelegate {
	func didCollideGoal()
	func didHitWhirlwind()
}

class PlayerInteractor {
	var collisionActions: [BaseEntityType: (BaseEntity)->()] {
		[
			.coin: hitCoin,
			.whirlwind: hitWhirlwind,
			.time: hitTimeBonus,
			.key: hitKey,
			.hearth: hitHearth,
			.bomb: hitBomb,
			.goal_open: hitGoal,
		]
	}

	let gameInteractor: GameInteractor!
	private(set) var player: Player!

	public init(gameInteractor: GameInteractor) {
		self.gameInteractor = gameInteractor

		defer {
			self.player = Player(interactor: self)
			player.add(to: gameInteractor.mazeView)
		}
	}

	// MARK: - Public

	func update(_ delta: TimeInterval) {
		player.update(delta)

		gameInteractor.enemyInteractor.collide(with: player)
	}

	func collide(with entity: BaseEntity) {
		guard entity.collides(player) else { return }

		collisionActions[entity.type]?(entity)
	}

	func didSwipe(_ direction: Direction) {
		player.didSwipe(direction)
		play(sound: .selectItem)
	}

	// MARK: - Private

	private func hitWhirlwind(entity: BaseEntity) {
		play(sound: .hitWhirlwind)
		gameInteractor.didHitWhirlwind()
		remove(entity: entity)
	}

	private func hitCoin(entity: BaseEntity) {
		play(sound: .hitCoin)
		gameInteractor.stats.currentScore += 15
		gameInteractor.delegate?.didUpdate(score: gameInteractor.stats.currentScore)
		remove(entity: entity)
	}

	private func hitTimeBonus(entity: BaseEntity) {
		play(sound: .hitTimeBonus)
		gameInteractor.stats.currentTime += 5
		remove(entity: entity)
	}

	private func hitKey(entity: BaseEntity) {
		play(sound: .hitHearth)
		gameInteractor.goal.type = .goal_open
		gameInteractor.walls.remove(gameInteractor.goal)
		remove(entity: entity)
	}

	private func hitHearth(entity: BaseEntity) {
		play(sound: .hitHearth)
		gameInteractor.stats.currentLives += 1
		gameInteractor.delegate?.didUpdate(lives: gameInteractor.stats.currentLives)
		remove(entity: entity)
	}

	private func hitBomb(entity: BaseEntity) {
		play(sound: .hitBomb)
		player.addPower()
		destroyWalls()
		remove(entity: entity)
	}

	private func hitGoal(entity: BaseEntity) {
		gameInteractor.didCollideGoal()
	}

	private func destroyWalls() {
		for wall in gameInteractor.walls {
			guard wall.isDestroyable, player.frame.isNeighbour(of: wall.frame) else { return }

			wall.explode()
			gameInteractor.walls.remove(wall)
		}
	}

	private func remove(entity: BaseEntity) {
		entity.visible = false
		gameInteractor.items.remove(entity)
	}
}
