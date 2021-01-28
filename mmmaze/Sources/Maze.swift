//
//  Maze.swift
//  mmmaze
//
//  Created by mugx on 11/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

class Maze {
	private(set) var currentTileIndex = 0
	private(set) var grid: [MazeTile]
	private let dimension: Int
	private let start: Position
	private var freePositions: [Position] = []

	init(dimension: Int, start: Position) {
		self.dimension = dimension
		self.start = start

		grid = Array()
		for row in 0 ..< dimension {
			for col in 0 ..< dimension {
				grid.append(MazeTile(.wall, row: row, col: col))
			}
		}

		defer {
			self[start]!.type = .start
		}
	}

	subscript(row: Int, col: Int) -> MazeTile? {
		get {
			guard row >= 0, col >= 0, row < dimension, col < dimension else { return nil}
			return grid[(row * dimension) + col]
		}
		set {
			guard let newValue = newValue else { return }
			grid[(row * dimension) + col] = newValue

			if newValue.type == .path {
				freePositions.append(newValue.pos)
			}
		}
	}

	subscript(tile: Position) -> MazeTile? {
		get {
			return self[tile.row, tile.col]
		}
		set {
			self[tile.row, tile.col] = newValue
		}
	}

	// MARK: - Public

	func getFreePosition() -> (Position) {
		return freePositions[Int(arc4random()) % freePositions.count]
	}

	func removeFreePositions() {
		freePositions.removeAll()
	}

	func hasWall(at pos: Position) -> Bool {
		self[pos]?.type == .wall
	}

	func digPath(_ direction: Direction, at pos: Position) -> Position {
		var pos = pos.move(direction, 1)
		self[pos]?.type = .path

		pos = pos.move(direction, 1)
		self[pos]?.type = .path

		return pos
	}
}

// MARK: - Sequence, IteratorProtocol

extension Maze: Sequence, IteratorProtocol {
	func next() -> MazeTile? {
		if currentTileIndex < grid.count {
			let oldTileIndex = currentTileIndex
			currentTileIndex += 1
			return grid[oldTileIndex]
		} else {
			return nil
		}
	}
}
