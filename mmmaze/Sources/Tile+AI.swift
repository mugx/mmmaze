//
//  Tile+AI.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension Tile {
	func collides(target: CGRect, path: [CGRect]) -> Bool {
		path.contains { $0.intersects(target) }
	}

	func getBestDirection(_ directions: [(UISwipeGestureRecognizer.Direction, CGRect)], targetFrame: CGRect) -> (UISwipeGestureRecognizer.Direction, CGRect) {
		var bestManhattan = CGFloat(Float.greatestFiniteMagnitude)
		var bestDirection: (UISwipeGestureRecognizer.Direction, CGRect)!

		for direction in directions {
			let manhattan = euclideanDistance(rect1: direction.1, rect2: targetFrame)
			if manhattan < bestManhattan {
				bestManhattan = manhattan
				bestDirection = direction
			}
		}
		
		return bestDirection
	}

	// MARK: - Private

	private func euclideanDistance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		let center1 = CGPoint(x: rect1.midX, y: rect1.midY)
		let center2 = CGPoint(x: rect2.midX, y: rect2.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance
	}
}
