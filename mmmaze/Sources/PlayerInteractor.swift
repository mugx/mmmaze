//
//  PlayerInteractor.swift
//  mmmaze
//
//  Created by mugx on 18/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class PlayerInteractor {
	var collisionActions: [BaseEntityType: ()->()] {
		[
			.coin: hitCoin,
			.whirlwind: hitWhirlwind,
			.time: hitTimeBonus,
			.key: hitKey,
			.hearth: hitHearth,
			.bomb: hitBomb
		]
	}

	private let gameSession: GameSession!
	private(set) var player: Player

	public init(gameSession: GameSession) {
		self.gameSession = gameSession
		self.player = Player(gameSession: gameSession)
		player.add(to: gameSession.mazeView)
	}

	func collide(with item: Tile) {
		guard item.type != .goal_close, item.collides(player) else { return }

		collisionActions[item.type]?()
		item.visible = false
		gameSession.items.remove(item)
	}

	// MARK: - Hits

	private func hitWhirlwind() {
		play(sound: .hitWhirlwind)
		gameSession.stats.mazeRotation += .pi / 2

		UIView.animate(withDuration: 0.2) {
			self.gameSession.gameView.transform = self.gameSession.gameView.transform.rotated(by: .pi / 2)
			self.player.transform = CGAffineTransform(rotationAngle: -self.gameSession.stats.mazeRotation)
			self.gameSession.items.forEach { $0.transform = CGAffineTransform(rotationAngle: -self.gameSession.stats.mazeRotation) }
			self.gameSession.walls.forEach { $0.transform = .identity }
			self.gameSession.enemyInteractor.enemies.forEach { $0.transform = CGAffineTransform(rotationAngle: -self.gameSession.stats.mazeRotation) }
		}
	}

	private func hitCoin() {
		play(sound: .hitCoin)
		gameSession.stats.currentScore += 15
		gameSession.delegate?.didUpdate(score: gameSession.stats.currentScore)
	}

	private func hitTimeBonus() {
		play(sound: .hitTimeBonus)
		gameSession.stats.currentTime += 5
	}

	private func hitKey() {
		play(sound: .hitHearth)
		gameSession.goal.type = .goal_open
		gameSession.walls.remove(gameSession.goal)
	}

	private func hitHearth() {
		play(sound: .hitHearth)
		gameSession.stats.currentLives += 1
		gameSession.delegate?.didUpdate(lives: gameSession.stats.currentLives)
	}

	private func hitBomb(){
		play(sound: .hitBomb)
		player.addPower()
	}
}
