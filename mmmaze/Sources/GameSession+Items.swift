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

	func makeItem(col: Int, row: Int) -> Tile? {
		let item = Tile(frame: CGRect(row: row, col: col))

		switch Int.random(in: 0 ..< 100) {
		case 99 ... 100:
			item.type = TyleType.hearth
			item.image = TyleType.hearth.image
		case 98 ... 100:
			item.type = TyleType.time
			item.animationImages = TyleType.time.image?.sprites(with: TILE_SIZE)
			item.animationDuration = 1
			item.startAnimating()
		case 90 ... 100:
			item.type = TyleType.whirlwind
			item.image = TyleType.whirlwind.image
			item.spin()
		case 85 ... 100:
			item.type = TyleType.bomb
			item.image = TyleType.bomb.image
		case 50 ... 100:
			item.type = TyleType.coin
			item.image = TyleType.coin.image
			item.spin()
		default:
			break
		}

		if item.type != .none {
			item.x = Int(col)
			item.y = Int(row)
			mazeView.addSubview(item)
			items.append(item)
			return item
		} else {
			return nil
		}
	}

	func checkItemsCollisions() {
		var itemsToRemove = [Tile]()
		for item in items {
			if checkPlayerCollision(with: item) || checkEnemyCollision(with: item) {
				item.isHidden = true
				itemsToRemove.append(item)
			}

			item.transform = CGAffineTransform(rotationAngle: CGFloat(-mazeRotation))
		}
		items.removeAll { itemsToRemove.contains($0) }
	}

	// MARK: - Private

	private func checkPlayerCollision(with item: Tile) -> Bool {
		guard item.frame.intersects(player.frame) else { return false }

		if item.type == TyleType.coin {
			play(sound: .hitCoin)
			currentScore += 15
			delegate?.didUpdateScore(currentScore)
			return true
		} else if item.type == TyleType.whirlwind {
			play(sound: .hitWhirlwind)

			if DEBUG { return true }

			UIView.animate(withDuration: 0.2) {
				self.mazeRotation += .pi / 2
				self.gameView.transform = self.gameView.transform.rotated(by: .pi / 2)
				self.player.transform = CGAffineTransform(rotationAngle: -CGFloat(self.mazeRotation))
			}
			return true
		} else if item.type == TyleType.time {
			play(sound: .hitTimeBonus)
			currentTime += 5
			return true
		} else if item.type == TyleType.key {
			play(sound: .hitHearth)

			if DEBUG { return true }
			
			mazeGoalTile.type = TyleType.goal_open
			mazeGoalTile.image = TyleType.goal_open.image
			wallsDictionary.removeValue(forKey: NSValue(cgPoint: CGPoint(x: mazeGoalTile.x, y: mazeGoalTile.y)))
			return true
		} else if item.type == TyleType.hearth {
			play(sound: .hitHearth)
			currentLives += 1
			delegate?.didUpdateLives(currentLives)
			return true
		} else if item.type == TyleType.bomb {
			play(sound: .hitBomb)
			if DEBUG { return true }

			player.power += 1
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				self.player.power -= self.player.power > 0 ? 1 : 0
			}
			return true
		}

		return false
	}

	private func checkEnemyCollision(with item: Tile) -> Bool {
		guard item.type == TyleType.bomb else { return false }

		var collide = false
		enemyCollaborator.collide(with: item) { enemy in
			enemy.wantSpawn = !DEBUG
			play(sound: .enemySpawn)
			collide = true
		}
		return collide
	}
}
