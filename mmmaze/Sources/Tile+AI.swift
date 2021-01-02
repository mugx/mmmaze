//
//  Tile+AI.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension Tile {
	func distance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		return abs(rect1.origin.x - rect2.origin.x) + abs(rect1.origin.y - rect2.origin.y)
	}

	func collides(target: CGRect, path: [CGRect]) -> Bool {
		path.contains { $0.intersects(target) }
	}

	private func euclideanDistance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		let center1 = CGPoint(x: rect1.midX, y: rect1.midY)
		let center2 = CGPoint(x: rect2.midX, y: rect2.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance
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

	func search(_ target: CGRect) -> [CGRect] {
		let originalFrame = CGRect(
			x: round(Double(Float(frame.origin.x) / Float(TILE_SIZE))) * TILE_SIZE,
			y: round(Double(Float(frame.origin.y) / Float(TILE_SIZE))) * TILE_SIZE,
			width: TILE_SIZE,
			height: TILE_SIZE
		)
		var currentFrame = originalFrame
		let currentSpeed = TILE_SIZE
		let currentSize = TILE_SIZE
		
		var path = [currentFrame]
		var targetFound = false

		while (!targetFound) {
			targetFound = collides(target: target, path: path)

			if targetFound, let index = path.firstIndex(of: originalFrame) {
				path.remove(at: index)
				break
			}

			let upFrame = CGRect(x: Double(currentFrame.origin.x), y: Double(currentFrame.origin.y) - currentSpeed, width: currentSize, height: currentSize)
			let downFrame = CGRect(x: Double(currentFrame.origin.x), y: Double(currentFrame.origin.y) + currentSpeed, width: currentSize, height: currentSize)
			let leftFrame = CGRect(x: Double(currentFrame.origin.x) - currentSpeed, y: Double(currentFrame.origin.y), width: currentSize, height: currentSize)
			let rightFrame = CGRect(x: Double(currentFrame.origin.x) + currentSpeed, y: Double(currentFrame.origin.y), width: currentSize, height: currentSize)

			let collidesUp = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.up) || path.contains(upFrame)
			let collidesDown = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.down) || path.contains(downFrame)
			let collidesLeft = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.left) || path.contains(leftFrame)
			let collidesRight = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.right) || path.contains(rightFrame)

			var possibleDirections = [(UISwipeGestureRecognizer.Direction, CGRect)]()
			if !collidesUp {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.up, upFrame))
			}

			if !collidesDown {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.down, downFrame))
			}

			if !collidesLeft {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.left, leftFrame))
			}

			if !collidesRight {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.right, rightFrame))
			}

			if !possibleDirections.isEmpty {
				let direction = getBestDirection(possibleDirections, targetFrame: target)
				currentFrame = direction.1
				path.append(currentFrame)
			} else {
				// backtracking
				if let currentIndex = path.firstIndex(of: currentFrame) {
					currentFrame = path[currentIndex - 1]
				}
			}
		}
		return path
	}

	// MARK: - Private
}
