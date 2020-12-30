//
//  Tile+AI.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

@objc extension Tile {
	@objc func distance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		return abs(rect1.origin.x - rect2.origin.x) + abs(rect1.origin.y - rect2.origin.y)
	}

	@objc func euclideanDistance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		let center1 = CGPoint(x: rect1.midX, y: rect1.midY)
		let center2 = CGPoint(x: rect2.midX, y: rect2.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance;
	}

	@objc func collides(target: CGRect, path: [CGRect]) -> Bool {
		for p in path {
			if target.intersects(p) {
				return true
			}
		}
		return false
	}
}
