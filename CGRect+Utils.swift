//
//  CGRect+Utils.swift
//  mmmaze
//
//  Created by mugx on 02/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

extension CGRect {
	init(row: Int, col: Int) {
		self.init(
			origin: CGPoint(x: Double(col) * TILE_SIZE, y: Double(row) * TILE_SIZE),
			size: CGSize(width: TILE_SIZE, height: TILE_SIZE)
		)
	}

	func distance(from rect: CGRect) -> CGFloat {
		return abs(origin.x - rect.origin.x) + abs(origin.y - rect.origin.y)
	}
}
