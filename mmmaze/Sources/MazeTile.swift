//
//  MazeTile.swift
//  mmmaze
//
//  Created by mugx on 31/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

struct MazeTile {
	enum `Type` {
		case wall
		case path
		case start
		case key
		case goal
	}

	var type: Type
	var pos: Position
	var row: Int { pos.row }
	var col: Int { pos.col }
	var steps: Int

	init(_ type: Type, row: Int = 0, col: Int = 0, steps: Int = 0) {
		self.type = type
		self.pos = Position(row: row, col: col)
		self.steps = 0
	}

	init(_ type: Type, pos: Position, steps: Int = 0) {
		self.type = type
		self.pos = pos
		self.steps = 0
	}
}
