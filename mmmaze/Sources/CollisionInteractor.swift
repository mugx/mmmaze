//
//  CollisionInteractor.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

protocol CollisionInteractorDelegate {
	func didCollideGoal()
}

class CollisionInteractor {
	let gameSession: GameSession
	weak var player: Player!

	init(_ gameSession: GameSession) {
		self.gameSession = gameSession
	}

	func update() {
		self.player = gameSession.player

		playerGoalCollision()
		playerVsEnemiesCollision()
		playerWallsCollision()
		enemiesVsItemsCollisions()
	}

	// MARK: - Private

	private func playerGoalCollision() {
		guard gameSession.goal.type == .goal_open && player.collides(gameSession.goal) else { return }
		gameSession.didCollideGoal()
	}

	private func playerVsEnemiesCollision() {
		guard let player = player else { return }
		gameSession.enemyInteractor.collide(with: player)
	}

	private func enemiesVsItemsCollisions() {
		for item in gameSession.items {
			gameSession.playerInteractor.collide(with: item)
			gameSession.enemyInteractor.collide(with: item)
		}
	}

	private func playerWallsCollision() {
		guard let player = player else { return }
		guard player.isInvulnerable else { return }

		for wall in gameSession.walls {
			guard wall.isDestroyable, player.frame.isNeighbour(of: wall.frame) else { continue }

			wall.explode()
			gameSession.walls.remove(wall)
		}
	}
}
