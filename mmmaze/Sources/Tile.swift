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
	var isDestroyable: Bool = false
	var isBlinking: Bool = false
	var power: UInt = 0
	var gameSession: GameSession?
	var lastSwipe: UISwipeGestureRecognizer.Direction?
	var animations: [String: CABasicAnimation] = [:]
	private var col: Int = 0
	private var row: Int = 0

	init(type: TyleType = .none, row: Int, col: Int) {
		super.init(frame: CGRect(row: row, col: col))

		self.type = type
		self.col = col
		self.row = row
	}

	init(type: TyleType = .none, frame: CGRect = .zero) {
		super.init(frame: frame)

		self.type = type
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	override func explode(_ completion: (() -> ())? = nil) {
		super.explode(completion)
		type = type == .wall ? TyleType.explodedWall : type
	}

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
		let new_col = direction == .left ? col - 1 : direction == .right ? col + 1 : col
		let new_row = direction == .up ? row - 1 : direction == .down ? row + 1 : row
		return gameSession!.checkWallCollision(CGRect(row: new_row, col: new_col))
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
