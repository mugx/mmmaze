//
//  GameSession+Items.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension GameSession {
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
		case 80 ... 100:
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
			if checkPlayerCollision(with: item) || checkEnemyCollision(with: item){
				item.isHidden = true
				itemsToRemove.append(item)
			}

			item.transform = CGAffineTransform(rotationAngle: CGFloat(-mazeRotation))
		}
		items.removeAll { itemsToRemove.contains($0) }
	}

	func checkPlayerCollision(with item: Tile) -> Bool {
		guard item.frame.intersects(player.frame) else { return false }

		if item.type == TyleType.coin {
			play(sound: .hitCoin)
			currentScore += 15
			delegate?.didUpdateScore(currentScore)
			return true
		} else if item.type == TyleType.whirlwind {
			play(sound: .hitWhirlwind)

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
			player.isAngry = true

			let player_x = Double(player.frame.origin.x)
			let player_y = Double(player.frame.origin.y)

			for tile in wallsDictionary.values {
				if !tile.isDestroyable { continue }

				if tile.frame.intersects(CGRect(x: player_x + TILE_SIZE, y: player_y, width: TILE_SIZE, height: TILE_SIZE)) ||
					tile.frame.intersects(CGRect(x: player_x - TILE_SIZE, y: player_y, width: TILE_SIZE, height: TILE_SIZE)) ||
						tile.frame.intersects(CGRect(x: player_x, y: player_y + TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE)) ||
				tile.frame.intersects(CGRect(x: player_x, y: player_y - TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE)) {
					tile.explode()
					tile.type = TyleType.explodedWall
				} else if tile.frame.intersects(CGRect(x: player_x - TILE_SIZE, y: player_y, width: TILE_SIZE, height: TILE_SIZE)) {
					tile.explode()
					tile.type = TyleType.explodedWall
				}
			}
			return true
		}

		return false
	}

	func checkEnemyCollision(with item: Tile) -> Bool {
		guard item.type == TyleType.bomb else { return false }

		var collide = false
		enemyCollaborator.collide(with: item) { enemy in
			item.isHidden = true
			enemy.wantSpawn = true
			play(sound: .enemySpawn)
			collide = true
		}
		return collide
	}
}
