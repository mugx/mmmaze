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
	let rows: Int, columns: Int
	var grid: [MazeTileType]
	var freeTiles: [Tile] = []

	init(rows: Int, columns: Int) {
		self.rows = rows
		self.columns = columns
		grid = Array(repeating: .wall, count: rows * columns)
	}

	subscript(row: Int, column: Int) -> MazeTileType {
		get { grid[(row * columns) + column] }
		set { grid[(row * columns) + column] = newValue }
	}

	func markFree(_ tile: Tile) {
		freeTiles.append(tile)
	}

	func randFreeTile() -> Tile {
		return freeTiles[Int(arc4random()) % freeTiles.count]
	}
}
