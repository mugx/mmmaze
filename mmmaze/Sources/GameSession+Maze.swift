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
		let numRow = Int(self.numRow)
		let numCol = Int(self.numCol)
		let maze = MazeGenerator.calculateMaze(startRow: startRow, startCol: startCol, rows: numRow, cols: numCol)
		wallsDictionary = [:]

		for r in 0 ..< numRow {
			for c in 0 ..< numCol {
				if maze[r, c] == .wall {
					let tile = Tile(type: .wall, frame: CGRect(row: r, col: c))
					tile.image = TyleType.wall.image
					tile.isDestroyable = !(r == 0 || c == 0 || r == self.numRow - 1 || c == self.numCol - 1)
					tile.x = r
					tile.y = c
					mazeView.addSubview(tile)
					wallsDictionary[NSValue(cgPoint: CGPoint(x: r, y: c))] = tile
				} else if maze[r, c] == .start {
					let tile = Tile(type: .door, frame: CGRect(row: r, col: c))
					tile.isDestroyable = false
					tile.x = r
					tile.y = c
					mazeView.addSubview(tile)
					items.append(tile)
				} else if maze[r, c] == .goal {
					let tile = Tile(type: .goal_close, frame: CGRect(row: r, col: c))
					tile.x = r
					tile.y = c
					tile.isDestroyable = false
					tile.image = TyleType.goal_close.image
					mazeView.addSubview(tile)
					wallsDictionary[NSValue(cgPoint: CGPoint(x: r, y: c))] = tile
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
		keyItem.x = Int(freeTile.x)
		keyItem.y = Int(freeTile.y)
		keyItem.image = TyleType.key.image
		mazeView.addSubview(keyItem)
		items.append(keyItem)
	}
}
