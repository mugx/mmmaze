//
//  Maze.swift
//  mmmaze
//
//  Created by mugx on 11/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

enum MazeBaseEntityType: Int {
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
	private let dimension: Int
	private var grid: [MazeBaseEntityType]
	private var freePositions: [Position] = []

	init(dimension: Int) {
		self.dimension = dimension
		grid = Array(repeating: .wall, count: dimension * dimension)
	}

	subscript(row: Int, column: Int) -> MazeBaseEntityType {
		get { grid[(row * dimension) + column] }
		set { grid[(row * dimension) + column] = newValue }
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
