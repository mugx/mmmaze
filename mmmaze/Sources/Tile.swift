//
//  Tile.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension Tile {
	@objc func flip() {
		let anim = CABasicAnimation.flipAnimation()
		layer.add(anim, forKey: "flip")
		animations?.setObject(anim, forKey: "flip" as NSString)
	}

	@objc func spin() {
		let anim = CABasicAnimation.spinAnimation()
		layer.add(anim, forKey: "spin")
		animations?.setObject(anim, forKey: "spin" as NSString)
	}

	func restoreAnimations() {
		animations?.forEach({ (arg0) in
			layer.add(arg0.value as! CAAnimation, forKey: arg0.key as? String)
		})
	}

	// A moving tile can't match the TILE_SIZE or it collides with the borders, hence it doesn't move.
	// Instead we consider its frame as centered and resized of a speed factor so it has margin to move.
	@objc func respawnAtInitialFrame() {
		velocity = .zero

		let initialTile_x = Double(Constants.STARTING_CELL.x * CGFloat(TILE_SIZE))
		let initialTile_y = Double(Constants.STARTING_CELL.y * CGFloat(TILE_SIZE))
		frame = CGRect(
			x: initialTile_x + Double(speed) / 2.0,
			y: initialTile_y + Double(speed) / 2.0,
			width: TILE_SIZE - Double(speed),
			height: TILE_SIZE - Double(speed)
		)
	}

	@objc func explodeWall() -> Bool {
		guard let collidedWall = collidedWall,
					collidedWall.tag == TyleType.TTWall.rawValue,
					collidedWall.isDestroyable,
					isAngry else { return false }

		collidedWall.explode()
		collidedWall.tag = Int(TyleType.TTExplodedWall.rawValue)
		isAngry = false
		return true
	}
}
