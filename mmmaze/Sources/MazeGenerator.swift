//
//  MazeGenerator.swift
//  mmmaze
//
//  Created by mugx on 01/01/21.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class MazeGenerator {
	static func calculateMaze(startRow: Int, startCol: Int, rows: Int, cols: Int) -> Maze {
		let maze = Maze(rows: rows, columns: cols)
		let startTile = MazeTile(row: startRow, col: startCol, steps: 0)
		maze[startRow, startCol] = MazeTileType.start

		var visitedTiles = [MazeTile]()
		var currentPath = [startTile]
		var currentRow = startRow
		var currentCol = startCol

		while !currentPath.isEmpty {
			var possibleDirections = [String]()
			if (currentRow - 2 >= 0) && maze[currentRow - 2, currentCol] == .wall {
				possibleDirections.append("n")
			}

			if (currentRow + 2 < rows) && maze[currentRow + 2, currentCol] == .wall {
				possibleDirections.append("s")
			}

			if (currentCol + 2 < cols) && maze[currentRow, currentCol + 2] == .wall {
				possibleDirections.append("e")
			}

			if (currentCol - 2 >= 0) && maze[currentRow, currentCol - 2] == .wall {
				possibleDirections.append("w")
			}

			if !possibleDirections.isEmpty {  // forward
				let dir = possibleDirections[Int(arc4random()) % possibleDirections.count]
				switch dir {
				case "n":
					maze[currentRow - 2, currentCol] = .path
					maze[currentRow - 1, currentCol] = .path
					currentRow -= 2
				case "s":
					maze[currentRow + 2, currentCol] = .path
					maze[currentRow + 1, currentCol] = .path
					currentRow += 2
				case "w":
					maze[currentRow, currentCol - 2] = .path
					maze[currentRow, currentCol - 1] = .path
					currentCol -= 2
				case "e":
					maze[currentRow, currentCol + 2] = .path
					maze[currentRow, currentCol + 1] = .path
					currentCol += 2
				default:
					break
				}

				let tile = MazeTile(row: currentRow, col: currentCol, steps: currentPath.count * 2)
				currentPath.append(tile)
				visitedTiles.append(tile)
			}
			else { //backtracking
				let backTile = currentPath.removeLast()
				currentRow = backTile.row
				currentCol = backTile.col
			}
		}

		// taking end tile 
		var end = startTile
		for tile in visitedTiles {
			if tile.steps >= end.steps {
				end = tile
			}
		}
		maze[end.row, end.col] = .goal
		return maze
	}
}
