//
//  GameSession+Items.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension GameSession {

	// MARK: - Public

	func makeItem(for maze: Maze, col: Int, row: Int) {
		let item = Tile(type: .none, row: row, col: col)

		switch Int.random(in: 0 ..< 100) {
		case 99 ... 100:
			item.type = .hearth
		case 98 ... 100:
			item.type = .time
		case 90 ... 100:
			item.type = .whirlwind
			item.spin()
		case 85 ... 100:
			item.type = .bomb
		case 50 ... 100:
			item.type = .coin
			item.spin()
		default:
			maze.markFree(item)
			return
		}

		mazeView.addSubview(item)
		items.insert(item)
	}

	func itemsCollisions() {
		for item in items {
			playerCollision(with: item)
			enemyCollision(with: item)
		}
	}

	// MARK: - Private

	private func playerCollision(with item: Tile) {
		guard item.theFrame.collides(player.theFrame) else { return }

		switch item.type {
		case .coin:
			hitCoin()
		case .whirlwind:
			hitWhirlwind()
		case .time:
			hitTimeBonus()
		case .key:
			hitKey()
		case .hearth:
			hitHearth()
		case .bomb:
			hitBomb()
		default:
			return
		}

		item.isHidden = true
		items.remove(item)
	}


	private func enemyCollision(with item: Tile) {
		guard !item.isHidden, item.type == TileType.bomb else { return }

		enemyInteractor.collide(with: item) { enemy in
			play(sound: .enemySpawn)
			enemy.wantSpawn = true
			item.isHidden = true
			items.remove(item)
		}
	}

	// MARK: - Hits

	private func hitWhirlwind() {
		play(sound: .hitWhirlwind)
		stats.mazeRotation += .pi / 2

		UIView.animate(withDuration: 0.2) {
			self.gameView.transform = self.gameView.transform.rotated(by: .pi / 2)
			self.player.transform = CGAffineTransform(rotationAngle: -self.stats.mazeRotation)
			self.items.forEach { $0.transform = CGAffineTransform(rotationAngle: -self.stats.mazeRotation) }
			self.walls.forEach { $0.transform = .identity }
			self.enemyInteractor.enemies.forEach { $0.transform = CGAffineTransform(rotationAngle: -self.stats.mazeRotation) }
		}
	}

	private func hitCoin() {
		play(sound: .hitCoin)
		stats.currentScore += 15
		delegate?.didUpdate(score: stats.currentScore)
	}

	private func hitTimeBonus() {
		play(sound: .hitTimeBonus)
		stats.currentTime += 5
	}

	private func hitKey() {
		play(sound: .hitHearth)
		mazeGoalTile.type = TileType.goal_open
		mazeGoalTile.image = TileType.goal_open.image
		walls.remove(mazeGoalTile)
	}

	private func hitHearth() {
		play(sound: .hitHearth)
		stats.currentLives += 1
		delegate?.didUpdate(lives: stats.currentLives)
	}

	private func hitBomb(){
		play(sound: .hitBomb)
		player.power += 1

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
			self.player.power -= self.player.power > 0 ? 1 : 0
		}
	}
}
