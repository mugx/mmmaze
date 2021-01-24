//
//  Maze.swift
//  mmmaze
//
//  Created by mugx on 11/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

class Maze {
	enum TileType: Int {
		case wall
		case path
		case start
		case goal
	}

	private let dimension: Int
	private var grid: [TileType]
	private var freePositions: [Position] = []

	init(dimension: Int) {
		self.dimension = dimension
		grid = Array(repeating: .wall, count: dimension * dimension)
	}

	subscript(row: Int, column: Int) -> TileType {
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
