//
//  GameSession+Items.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

extension GameSession {
	func makeItem(col: Int, row: Int) -> Tile? {
		let col = Double(col)
		let row = Double(row)
		let frame = CGRect(x: col * TILE_SIZE, y: row * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE)
		let item = Tile(frame: frame)
		item.tag = -1

		let rand = Int.random(in: 0 ..< 100)
		switch rand {
		case 99 ... 100:
			item.tag = TyleType.hearth.rawValue
			item.image = UIImage(named: "hearth")
		case 98 ... 100:
			item.tag = TyleType.time.rawValue
			item.animationImages = UIImage(named: "time")?.sprites(with: TILE_SIZE)
			item.animationDuration = 1
			item.startAnimating()
		case 90 ... 100:
			item.tag = TyleType.whirlwind.rawValue
			item.image = UIImage(named: "whirlwind")?.colored(with: UIColor.white)
			item.spin()
			break
		case 80 ... 100:
			item.tag = TyleType.bomb.rawValue
			item.image = UIImage(named: "bomb")?.colored(with: UIColor.red)
		case 50 ... 100:
			item.tag = TyleType.coin.rawValue
			item.image = UIImage(named: "coin")?.colored(with: UIColor.yellow)
			item.spin()
		default:
			break
		}

		if item.tag != -1 {
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

		if item.tag == TyleType.coin.rawValue {
			play(sound: .hitCoin)
			currentScore += 15
			delegate?.didUpdateScore(currentScore)
			return true
		} else if item.tag == TyleType.whirlwind.rawValue {
			play(sound: .hitWhirlwind)

			UIView.animate(withDuration: 0.2) {
				self.mazeRotation += .pi / 2
				self.gameView.transform = self.gameView.transform.rotated(by: .pi / 2)
				self.player.transform = CGAffineTransform(rotationAngle: -CGFloat(self.mazeRotation))
			}
			return true
		} else if item.tag == TyleType.time.rawValue {
			play(sound: .hitTimeBonus)
			currentTime += 5
			return true
		} else if item.tag == TyleType.key.rawValue {
			play(sound: .hitHearth)
			mazeGoalTile.tag = TyleType.mazeEnd_open.rawValue
			mazeGoalTile.image = UIImage(named: "gate_open")
			wallsDictionary.removeValue(forKey: NSValue(cgPoint: CGPoint(x: mazeGoalTile.x, y: mazeGoalTile.y)))
			return true
		} else if item.tag == TyleType.hearth.rawValue {
			play(sound: .hitHearth)
			currentLives += 1
			delegate?.didUpdateLives(currentLives)
			return true
		} else if item.tag == TyleType.bomb.rawValue {
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
					tile.tag = TyleType.explodedWall.rawValue
				} else if tile.frame.intersects(CGRect(x: player_x - TILE_SIZE, y: player_y, width: TILE_SIZE, height: TILE_SIZE)) {
					tile.explode()
					tile.tag = TyleType.explodedWall.rawValue
				}
			}
			return true
		}

		return false
	}

	func checkEnemyCollision(with item: Tile) -> Bool {
		guard item.tag == TyleType.bomb.rawValue else { return false }

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
