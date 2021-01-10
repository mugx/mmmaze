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
		items = [Tile]()
		mazeView = UIView(frame: gameView.frame)
		gameView.addSubview(mazeView)
		mazeRotation = 0
		isGameOver = false

		// generating the maze 
		let startRow: Int = Int(Constants.STARTING_CELL.x)
		let startCol: Int = Int(Constants.STARTING_CELL.y)
		let maze = MazeGenerator.calculateMaze(startRow: startRow, startCol: startCol, rows: numRow, cols: numCol)
		walls = []

		for r in 0 ..< numRow {
			for c in 0 ..< numCol {
				if maze[r, c] == .wall {
					let tile = Tile(type: .wall, row: r, col: c)
					tile.image = TyleType.wall.image
					tile.isDestroyable = !(r == 0 || c == 0 || r == self.numRow - 1 || c == self.numCol - 1)
					mazeView.addSubview(tile)
					walls.append(tile)
				} else if maze[r, c] == .start {
					let tile = Tile(type: .start, row: r, col: c)
					tile.isDestroyable = false
					mazeView.addSubview(tile)
					items.append(tile)
				} else if maze[r, c] == .goal {
					let tile = Tile(type: .goal_close, row: r, col: c)
					tile.isDestroyable = false
					tile.image = TyleType.goal_close.image
					mazeView.addSubview(tile)
					walls.append(tile)
					mazeGoalTile = tile
					items.append(tile)
				} else {
					if makeItem(col: c, row: r) == nil {
						maze.markFree(row: r, col: c)
					}
				}
			}
		}

		// make key 
		let freeTile = maze.randFreeTile()
		let keyItem = Tile(type: .key, frame: CGRect(x: Double(freeTile.x) * TILE_SIZE, y: Double(freeTile.y) * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE))
		keyItem.image = TyleType.key.image
		mazeView.addSubview(keyItem)
		items.append(keyItem)
	}

	func checkWallCollision(_ frame: CGRect) -> Bool {
		return walls.contains(where: {
			$0.type != TyleType.explodedWall && $0.frame.intersects(frame)
		})
	}
}
