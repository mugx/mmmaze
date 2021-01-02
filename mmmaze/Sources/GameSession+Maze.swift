//
//  GameSession+Maze.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension GameSession {
	func makeMaze() {
		items = NSMutableArray(array: [Tile]())
		mazeView = UIView(frame: gameView.frame)
		gameView.addSubview(mazeView)
		mazeRotation = 0
		isGameOver = false

		//--- generating the maze ---//
		let startRow: Int = Int(Constants.STARTING_CELL.x)
		let startCol: Int = Int(Constants.STARTING_CELL.y)
		let numRow = Int(self.numRow)
		let numCol = Int(self.numCol)
		let maze = MazeGenerator.calculateMaze(startRow: startRow, startCol: startCol, rows: numRow, cols: numCol)
		wallsDictionary = NSMutableDictionary()

		for r in 0 ..< numRow {
			for c in 0 ..< numCol {
				if maze[r, c] == .wall {
					let tile = Tile(frame: CGRect(x: Double(c) * TILE_SIZE, y: Double(r) * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE))
					tile.tag = TyleType.wall.rawValue
					tile.image = UIImage(named: "wall")?.colored(with: UIColor.white)
					tile.isDestroyable = !(r == 0 || c == 0 || r == self.numRow - 1 || c == self.numCol - 1)
					tile.x = r;
					tile.y = c;
					mazeView.addSubview(tile)
					wallsDictionary.setObject(tile, forKey: NSValue(cgPoint: CGPoint(x: r, y: c)))
				} else if maze[r, c] == .start {
					let tile = Tile(frame: CGRect(x: Double(c) * TILE_SIZE, y: Double(r) * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE))
					tile.tag = TyleType.door.rawValue
					tile.isDestroyable = false
					tile.x = r;
					tile.y = c;
					mazeView.addSubview(tile)
					items.add(tile)
				} else if maze[r, c] == .end {
					let tile = Tile(frame: CGRect(x: Double(c) * TILE_SIZE, y: Double(r) * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE))
					tile.x = r
					tile.y = c
					tile.tag = TyleType.mazeEnd_close.rawValue
					tile.isDestroyable = false
					tile.image = UIImage(named: "gate_close")
					mazeView.addSubview(tile)
					wallsDictionary.setObject(tile, forKey: NSValue(cgPoint: CGPoint(x: r, y: c)))
					mazeGoalTile = tile
					items.add(tile)
				} else {
					if makeItem(col: c, row: r) == nil {
						maze.markFree(row: r, col: c)
					}
				}
			}
		}

		//--- make key ---//
		let freeTile = maze.randFreeTile()
		let keyItem = Tile(frame: CGRect(x: Double(freeTile.x) * TILE_SIZE, y: Double(freeTile.y) * TILE_SIZE, width: TILE_SIZE, height: TILE_SIZE))
		keyItem.x = Int(freeTile.x)
		keyItem.y = Int(freeTile.y)
		keyItem.tag = TyleType.key.rawValue
		keyItem.image = UIImage(named: "key")?.colored(with: .green)
		mazeView.addSubview(keyItem)
		items.add(keyItem)
	}
}
