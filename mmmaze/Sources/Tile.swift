//
//  Tile.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Tile: Entity {
	var type: TileType { didSet { refresh() } }
	var velocity: CGPoint = .zero
	var speed: Float = 0
	var isDestroyable: Bool = false
	var isBlinking: Bool = false
	var power: UInt = 0
	var gameSession: GameSession?
	var lastDirection: Direction?

	convenience init(type: TileType = .none, row: Int, col: Int) {
		self.init(type: type, rect: Frame(row: row, col: col).rect)
	}

	init(type: TileType = .none, rect: Rect = .zero) {
		self.type = type
		super.init(frame: Frame(rect: rect))
		refresh()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func didSwipe(_ direction: Direction) {
	}

	func update(_ delta: TimeInterval) {
		var frame = self.theFrame

		// check vertical collision
		var frameOnMove = frame.translate(y: velocity.y)
		if !gameSession!.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.x != 0 && lastDirection?.isVertical ?? false {
				velocity = CGPoint(x: 0, y: velocity.y)
			}
		}

		// check horizontal collision
		frameOnMove = frame.translate(x: velocity.x)
		if !gameSession!.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.y != 0 && lastDirection?.isHorizontal ?? false {
				velocity = CGPoint(x: velocity.x, y: 0)
			}
		}

		if self.theFrame != frame {
			self.theFrame = frame
		} else {
			velocity = .zero
		}
	}

	func isWall(at frame: Frame, direction: Direction) -> Bool {
		let col = frame.col
		let row = frame.row
		let new_col = direction == .left ? col - 1 : direction == .right ? col + 1 : col
		let new_row = direction == .up ? row - 1 : direction == .down ? row + 1 : row
		return gameSession!.checkWallCollision(Frame(row: new_row, col: new_col))
	}
	
	// A moving tile can't match the TILE_SIZE or it collides with the borders, hence it doesn't move.
	// Instead we consider its frame as centered and resized of a speed factor so it has margin to move.
	func respawnAtInitialFrame() {
		velocity = .zero
		theFrame = Frame(row: Constants.STARTING_CELL.row, col: Constants.STARTING_CELL.col)
		theFrame = theFrame.resize(with: Float(Frame.SIZE) - Float(speed))
		theFrame = theFrame.centered()
	}

	func refresh() {
		imageView?.image = type.image
	}
}
