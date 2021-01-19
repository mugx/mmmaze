//
//  GameSession+Items.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension GameSession {
	private var itemProbabilities: [Float: BaseEntityType] {
		[
			0.99: .hearth,
			0.98: .time,
			0.9: .whirlwind,
			0.85: .bomb,
			0.5: .coin
		]
	}

	func makeItem(for maze: Maze, col: Int, row: Int) {
		let position = Position(row: row, col: col)
		let rand = Float.random(in: 0 ..< 1)

		if let type = itemProbabilities.filter({ $0.0 < rand }).last {
			let tile = Tile(type: type.value, position: position)
			tile.add(to: mazeView)
			items.insert(tile)
		} else {
			maze.markFree(position: position)
		}
	}
}
