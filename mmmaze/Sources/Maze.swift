//
//  Maze.swift
//  mmmaze
//
//  Created by mugx on 11/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

enum MazeTileType: Int {
	case wall
	case path
	case start
	case goal
}

struct MazeTile {
	let row: Int
	let col: Int
	let steps: Int
}

class Maze {
	private let rows: Int, columns: Int
	private var grid: [MazeTileType]
	private var freePositions: [Position] = []

	init(rows: Int, columns: Int) {
		self.rows = rows
		self.columns = columns
		grid = Array(repeating: .wall, count: rows * columns)
	}

	subscript(row: Int, column: Int) -> MazeTileType {
		get { grid[(row * columns) + column] }
		set { grid[(row * columns) + column] = newValue }
	}

	func markFree(position: Position) {
		freePositions.append(position)
	}

	func getFreePosition() -> (Position) {
		return freePositions[Int(arc4random()) % freePositions.count]
	}

	func removeFreePositions() {
		freePositions.removeAll()
	}
}
