//
//  CollisionInteractor.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class CollisionInteractor {
	let gameSession: GameSession
	var player: Player!

	init(_ gameSession: GameSession) {
		self.gameSession = gameSession
	}

	func update() {
		self.player = gameSession.player

		playerGoalCollision()
		playerVsEnemiesCollision()
		playerWallsCollision()
		itemsCollisions()
	}

	// MARK: - Private

	private func playerGoalCollision() {
		// ACTORS:
		// - mazeGoalTile
		// - player
		// - stats
		// - gameSession.startLevel

		guard
			gameSession.mazeGoalTile.type == BaseEntityType.goal_open &&
				player.frame.collides(gameSession.mazeGoalTile.frame) else {
			return
		}

		gameSession.stats.currentScore += 100
		gameSession.startLevel(gameSession.stats.currentLevel + 1)
	}

	private func playerVsEnemiesCollision() {
		// ACTORS:
		// - player
		// - enemyInteractor

		guard !player.isBlinking else { return }

		var collided = false
		gameSession.enemyInteractor.collide(with: player) { (enemy) in
			guard !collided else { return }
			collided = true

			if player.power > 0 {
				enemy.hitted()
			} else {
				player.hitted(from: enemy)
			}
		}
	}

	private func playerWallsCollision() {
		// ACTORS:
		// - walls
		// - player

		guard player.power > 0 else { return }

		for wall in gameSession.walls {
			guard wall.isDestroyable, player.frame.isNeighbour(of: wall.frame) else { continue }

			wall.explode()
			gameSession.walls.remove(wall)
		}
	}

	private func itemsCollisions() {
		for item in gameSession.items {
			playerCollision(with: item)
			enemyCollision(with: item)
		}
	}

	private func playerCollision(with item: Tile) {
		// ACTORS:
		// - item
		// - player
		// - gameSession.items
		// - gameSession.collisionActions

		guard item.type != .goal_close, item.frame.collides(player.frame) else { return }
		gameSession.collisionActions[item.type]?()
		item.visible = false
		gameSession.items.remove(item)
	}

	private func enemyCollision(with item: Tile) {
		// ACTORS:
		// - enemyInteractor
		// - item: Tile
		// - items: [Tile]

		guard item.visible, item.type == BaseEntityType.bomb else { return }

		gameSession.enemyInteractor.collide(with: item) { enemy in
			enemy.wantSpawn = true
			item.visible = true
			gameSession.items.remove(item)
		}
	}
}
