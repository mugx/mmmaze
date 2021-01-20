//
//  MazeInteractor.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class MazeInteractor {
	private var itemProbabilities: [Float: BaseEntityType] {
		[
			0.99: .hearth,
			0.98: .time,
			0.9: .whirlwind,
			0.85: .bomb,
			0.5: .coin
		]
	}

	var walls: Set<BaseEntity> = []
	var items: Set<BaseEntity> = []
	var goal: BaseEntity?
	private var maze: Maze?
	private var dimension: Int = 0
	private let mazeView: UIView

	init(mazeView: UIView, dimension: Int) {
		self.mazeView = mazeView
		self.dimension = dimension

		makeMaze()
	}

	func makeMaze() {
		// generating the maze
		let startRow = Constants.STARTING_CELL.row
		let startCol = Constants.STARTING_CELL.col
		let maze = MazeGenerator.calculateMaze(startRow: startRow, startCol: startCol, dimension: dimension)

		for row in 0 ..< dimension {
			for col in 0 ..< dimension {
				switch maze[row, col] {
				case .wall:
					makeWall(for: maze, row: row, col: col)
				case .start:
					break
				case .goal:
					makeGoal(for: maze, row: row, col: col)
				default:
					makeItem(for: maze, col: col, row: row)
				}
			}
		}

		makeKey(for: maze)
		maze.removeFreePositions()
	}

	// MARK: - Private

	private func makeWall(for maze: Maze, row: Int, col: Int) {
		let tile = BaseEntity(type: .wall, row: row, col: col)
		tile.isDestroyable = !(row == 0 || col == 0 || row == dimension - 1 || col == dimension - 1)
		tile.add(to: mazeView)
		walls.insert(tile)
	}

	private func makeGoal(for maze: Maze, row: Int, col: Int) {
		let tile = BaseEntity(type: .goal_close, row: row, col: col)
		tile.add(to: mazeView)
		items.insert(tile)
		goal = tile
	}

	private func makeKey(for maze: Maze) {
		let tile = BaseEntity(type: .key, position: maze.getFreePosition())
		tile.add(to: mazeView)
		items.insert(tile)
	}

	func makeItem(for maze: Maze, col: Int, row: Int) {
		let position = Position(row: row, col: col)
		let rand = Float.random(in: 0 ..< 1)

		if let type = itemProbabilities.filter({ $0.0 < rand }).last {
			let tile = BaseEntity(type: type.value, position: position)
			tile.add(to: mazeView)
			items.insert(tile)
		} else {
			maze.markFree(position: position)
		}
	}
}
