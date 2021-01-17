//
//  Tile.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Tile: BaseEntity {
	var velocity: CGPoint = .zero
	var speed: Float = 0
	var isDestroyable: Bool = false
	var isBlinking: Bool = false
	var gameSession: GameSession?
	var lastDirection: Direction?

	convenience init(type: BaseEntityType, position: Position) {
		self.init(type: type, frame: Frame(row: position.row, col: position.col))
	}

	convenience init(type: BaseEntityType, row: Int, col: Int) {
		self.init(type: type, frame: Frame(row: row, col: col))
	}

	init(type: BaseEntityType, frame: Frame = .zero) {
		super.init(frame: frame, type: type)
		refresh()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public

	func didSwipe(_ direction: Direction) {
	}

	func update(_ delta: TimeInterval) {
		var frame = self.frame

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

		if self.frame != frame {
			self.frame = frame
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
		frame = Frame(row: Constants.STARTING_CELL.row, col: Constants.STARTING_CELL.col)
		frame = frame.resize(with: Float(Frame.SIZE) - Float(speed))
		frame = frame.centered()
	}
}
