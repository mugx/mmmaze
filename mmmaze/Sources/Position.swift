//
//  Position.swift
//  mmmaze
//
//  Created by mugx on 17/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import Foundation

struct Position: Hashable {
	var row: Int
	var col: Int

	init(row: Int, col: Int) {
		self.row = row
		self.col = col
	}

	func move(_ direction: Direction, _ steps: Int = 1) -> Position {
		let spin = direction == .up || direction == .left ? -1 : 1
		let row_offset = direction.isVertical ? steps * spin : 0
		let col_offset = direction.isHorizontal ? steps * spin : 0
		return Position(row: row + row_offset, col: col + col_offset)
	}
}
