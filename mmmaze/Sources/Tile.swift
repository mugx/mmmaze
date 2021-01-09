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
	var power: UInt = 0
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
	}

	func update(_ delta: TimeInterval) {
		var frame = self.frame

		// check vertical collision
		var frameOnMove = frame.translate(y: velocity.y)
		if !gameSession!.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.x != 0 && lastSwipe?.isVertical ?? false {
				velocity = CGPoint(x: 0, y: velocity.y)
			}
		}

		// check horizontal collision
		frameOnMove = frame.translate(x: velocity.x)
		if !gameSession!.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.y != 0 && lastSwipe?.isHorizontal ?? false {
				velocity = CGPoint(x: velocity.x, y: 0)
			}
		}

		if self.frame != frame {
			self.frame = frame
		} else {
			velocity = .zero
		}
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
}
