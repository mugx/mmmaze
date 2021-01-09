//
//  CGRect+Utils.swift
//  mmmaze
//
//  Created by mugx on 02/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

extension CGRect {
	var cols: Int { Int(floor(origin.x / size.width)) }
	var rows: Int { Int(floor(origin.y / size.height)) }

	init(row: Int, col: Int) {
		self.init(
			origin: CGPoint(x: Double(col) * TILE_SIZE, y: Double(row) * TILE_SIZE),
			size: CGSize(width: TILE_SIZE, height: TILE_SIZE)
		)
	}

	func translate(x: CGFloat = 0, y: CGFloat = 0) -> CGRect {
		return CGRect(origin: CGPoint(x: origin.x + x, y: origin.y + y), size: size)
	}

	func distance(to rect: CGRect) -> CGFloat {
		return abs(origin.x - rect.origin.x) + abs(origin.y - rect.origin.y)
	}

	func isNeighbour(of frame: CGRect) -> Bool {
		return translate(x: CGFloat(TILE_SIZE)).intersects(frame) ||
			translate(x: CGFloat(-TILE_SIZE)).intersects(frame) ||
			translate(y: CGFloat(TILE_SIZE)).intersects(frame) ||
			translate(y: CGFloat(-TILE_SIZE)).intersects(frame)
	}
}
