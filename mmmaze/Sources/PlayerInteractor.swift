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

	let gameSession: GameSession!
	private(set) var player: Player!

	public init(gameSession: GameSession) {
		self.gameSession = gameSession

		defer {
			self.player = Player(interactor: self)
			player.add(to: gameSession.mazeView)
		}
	}

	// MARK: - Public

	func update(_ delta: TimeInterval) {
		player.update(delta)

		gameSession.enemyInteractor.collide(with: player)
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
		gameSession.didHitWhirlwind()
		remove(entity: entity)
	}

	private func hitCoin(entity: BaseEntity) {
		play(sound: .hitCoin)
		gameSession.stats.currentScore += 15
		gameSession.delegate?.didUpdate(score: gameSession.stats.currentScore)
		remove(entity: entity)
	}

	private func hitTimeBonus(entity: BaseEntity) {
		play(sound: .hitTimeBonus)
		gameSession.stats.currentTime += 5
		remove(entity: entity)
	}

	private func hitKey(entity: BaseEntity) {
		play(sound: .hitHearth)
		gameSession.goal.type = .goal_open
		gameSession.walls.remove(gameSession.goal)
		remove(entity: entity)
	}

	private func hitHearth(entity: BaseEntity) {
		play(sound: .hitHearth)
		gameSession.stats.currentLives += 1
		gameSession.delegate?.didUpdate(lives: gameSession.stats.currentLives)
		remove(entity: entity)
	}

	private func hitBomb(entity: BaseEntity) {
		play(sound: .hitBomb)
		player.addPower()
		destroyWalls()
		remove(entity: entity)
	}

	private func hitGoal(entity: BaseEntity) {
		gameSession.didCollideGoal()
	}

	private func destroyWalls() {
		for wall in gameSession.walls {
			guard wall.isDestroyable, player.frame.isNeighbour(of: wall.frame) else { return }

			wall.explode()
			gameSession.walls.remove(wall)
		}
	}

	private func remove(entity: BaseEntity) {
		entity.visible = false
		gameSession.items.remove(entity)
	}
}
