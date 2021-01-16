//
//  GameSession+Maze.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension GameSession {
	func makeMaze() {
		mazeView = UIView(frame: gameView.frame)
		gameView.addSubview(mazeView)
		stats.mazeRotation = 0

		items = []
		walls = []

		// generating the maze 
		let startRow = Constants.STARTING_CELL.row
		let startCol = Constants.STARTING_CELL.col
		let maze = MazeGenerator.calculateMaze(startRow: startRow, startCol: startCol, rows: numRow, cols: numCol)

		for row in 0 ..< numRow {
			for col in 0 ..< numCol {
				switch maze[row, col] {
				case .wall:
					makeWall(for: maze, row: row, col: col)
				case .start:
					makeStart(for: maze, row: row, col: col)
				case .goal:
					makeGoal(for: maze, row: row, col: col)
				default:
					makeItem(for: maze, col: col, row: row)
				}
			}
		}

		makeKey(for: maze)
	}
	
	// MARK: - Private

	private func makeWall(for maze: Maze, row: Int, col: Int) {
		let tile = Tile(type: .wall, row: row, col: col)
		tile.image = TileType.wall.image
		tile.isDestroyable = !(row == 0 || col == 0 || row == self.numRow - 1 || col == self.numCol - 1)
		mazeView.addSubview(tile)
		walls.insert(tile)
	}

	private func makeStart(for maze: Maze, row: Int, col: Int) {
		let tile = Tile(type: .start, row: row, col: col)
		mazeView.addSubview(tile)
		items.insert(tile)
	}

	private func makeGoal(for maze: Maze, row: Int, col: Int) {
		let tile = Tile(type: .goal_close, row: row, col: col)
		tile.image = TileType.goal_close.image
		mazeGoalTile = tile
		mazeView.addSubview(tile)
		items.insert(tile)
	}

	private func makeKey(for maze: Maze) {
		let tile = maze.randFreeTile()
		tile.type = .key
		tile.image = TileType.key.image
		mazeView.addSubview(tile)
		items.insert(tile)
		maze.freeTiles.removeAll()
	}
}
