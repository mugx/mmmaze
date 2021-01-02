//
//  Tile.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Tile: UIImageView {
	var type: TyleType = .none
	var velocity: CGPoint = .zero
	var speed: Float = 0
	var x: Int = 0
	var y: Int = 0
	var isDestroyable: Bool = false
	var isBlinking: Bool = false
	var isAngry: Bool = false
	var gameSession: GameSession?
	var lastSwipe: UISwipeGestureRecognizer.Direction?
	var animations: [String: CABasicAnimation] = [:]

	init(type: TyleType = .none, frame: CGRect = .zero) {
		super.init(frame: frame)

		self.type = type
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		lastSwipe = direction
		
		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: velocity.y)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: self.velocity.y)
		case .up:
			velocity = CGPoint(x: velocity.x, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: velocity.x, y: CGFloat(speed))
		default:
			break
		}
	}

	func update(_ delta: TimeInterval) {
		let velx = velocity.x + velocity.x * CGFloat(delta)
		let vely = velocity.y + velocity.y * CGFloat(delta)
		manageWallCollision(velx, vely)
	}
	
	func isWall(at frame: CGRect, direction: UISwipeGestureRecognizer.Direction) -> Bool {
		let col = Int(round(Double(frame.origin.x) / TILE_SIZE))
		let row = Int(round(Double(frame.origin.y) / TILE_SIZE))
		let col_offset = direction == .left ? col - 1 : direction == .right ? col + 1 : col
		let row_offset = direction == .up ? row - 1 : direction == .down ? row + 1 : row
		let wallPosition = NSValue(cgPoint: CGPoint(x: row_offset, y: col_offset))
		
		guard let tile = gameSession?.wallsDictionary[wallPosition] else { return false }
		return tile.type != TyleType.explodedWall
	}
	
	func spin() {
		let anim = CABasicAnimation.spinAnimation()
		layer.add(anim, forKey: "spin")
		animations["spin"] = anim
	}
	
	func restoreAnimations() {
		animations.forEach({ (arg0) in
			layer.add(arg0.value, forKey: arg0.key)
		})
	}
	
	// A moving tile can't match the TILE_SIZE or it collides with the borders, hence it doesn't move.
	// Instead we consider its frame as centered and resized of a speed factor so it has margin to move.
	func respawnAtInitialFrame() {
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

	// MARK: - Private

	private func manageWallCollision(_ velx: CGFloat, _ vely: CGFloat) {
		var frame = self.frame
		var collidedWall: Tile?

		// check vertical collision
		var frameOnMove = frame.translate(y: vely)
		collidedWall = gameSession?.checkWallCollision(frameOnMove)
		if collidedWall == nil {
			frame = frameOnMove

			if velx != 0 && lastSwipe?.isVertical ?? false {
				velocity = CGPoint(x: 0, y: velocity.y)
			}
		}

		// check horizontal collision
		frameOnMove = frame.translate(x: velx)
		collidedWall = gameSession?.checkWallCollision(frameOnMove)
		if collidedWall == nil {
			frame = frameOnMove

			if vely != 0 && lastSwipe?.isHorizontal ?? false {
				velocity = CGPoint(x: velocity.x, y: 0)
			}
		}

		if self.frame != frame || explodeWall(collidedWall) {
			self.frame = frame
		} else {
			velocity = .zero
		}
	}

	private func explodeWall(_ collidedWall: Tile?) -> Bool {
		guard let collidedWall = collidedWall,
					collidedWall.type == TyleType.wall,
					collidedWall.isDestroyable,
					isAngry else { return false }

		collidedWall.explode()
		collidedWall.type = TyleType.explodedWall
		isAngry = false
		return true
	}
}
