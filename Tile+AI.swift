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

	@objc func collides(target: CGRect, path: [CGRect]) -> Bool {
		path.contains { $0.intersects(target) }
	}

	@objc func euclideanDistance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		let center1 = CGPoint(x: rect1.midX, y: rect1.midY)
		let center2 = CGPoint(x: rect2.midX, y: rect2.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance;
	}

	@objc func getBestDirection(_ directions: [[String: Any]], targetFrame: CGRect) -> String {
		var bestManhattan = CGFloat(Float.greatestFiniteMagnitude)
		var bestDirection = ""

		for direction in directions {
			let frame = (direction["frame"] as! NSValue).cgRectValue
			let move = (direction["move"] as! String)
			let manhattan = euclideanDistance(rect1: frame, rect2: targetFrame)
			if manhattan < bestManhattan {
				bestManhattan = manhattan
				bestDirection = move
			}
		}
		
		return bestDirection
 }

	@objc func search2() {
		let originalFrame = CGRect(
			x: round(Double(Float(frame.origin.x) / Float(TILE_SIZE))) * TILE_SIZE,
			y: round(Double(Float(frame.origin.y) / Float(TILE_SIZE))) * TILE_SIZE,
			width: TILE_SIZE,
			height: TILE_SIZE
		)

//		CGRect originalFrame = CGRectMake((int)roundf(self.frame.origin.x / TILE_SIZE) * TILE_SIZE, (int)roundf(self.frame.origin.y / TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
//		CGRect currentFrame = CGRectMake((int)roundf(self.frame.origin.x / TILE_SIZE) * TILE_SIZE, (int)roundf(self.frame.origin.y / TILE_SIZE) * TILE_SIZE, TILE_SIZE, TILE_SIZE);
//		CGFloat currentSpeed = TILE_SIZE;
//		CGFloat currentSize = TILE_SIZE;
//		NSMutableArray *path = [@[[NSValue valueWithCGRect:currentFrame]] mutableCopy];
//		bool targetFound = false;
	}
}
