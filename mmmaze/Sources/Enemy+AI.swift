//
//  Enemy+AI.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

extension Enemy {
	func calculatePath() {
		guard timeAccumulator > 1 || path.count == 0 else { return }
		timeAccumulator = 0

		let currentPosition = self.currentPosition()
		let newPath = search(gameSession!.player.frame)
		let firstPathFrame = path.firstObject as? CGRect ?? CGRect.zero
		let firstNewPathFrame = newPath.first ?? CGRect.zero
		
		let currentSteps = path.count
		let newSteps = newPath.count

		let d1 = distance(rect1: currentPosition, rect2: firstPathFrame)
		let d2 = distance(rect1: currentPosition, rect2: firstNewPathFrame)

		let hasToUpdatePath =
			currentSteps == 0 ||
			currentSteps > newSteps ||
			d1 > d2

		if hasToUpdatePath {
			path = NSMutableArray(array: newPath)
		}
	}

	func refinesPath() {
		let currentPosition = self.currentPosition()
		let enrolledPath: [CGRect] = path.compactMap { ($0 as? NSValue)?.cgRectValue }
		if collides(target: currentPosition, path: enrolledPath) {
			path.remove(currentPosition)
		}
	}

	func decideNextMove(_ delta: TimeInterval) {
		let speed = CGFloat(self.speed + self.speed * Float(delta))
		let upFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y - speed), width: frame.size.width, height: frame.size.height)
		let downFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y + speed), width: frame.size.width, height: frame.size.height)
		let leftFrame = CGRect(x: CGFloat(frame.origin.x - speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let rightFrame = CGRect(x: CGFloat(frame.origin.x + speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let collidesUp = checkWallCollision(upFrame) != nil
		let collidesDown = checkWallCollision(downFrame) != nil
		let collidesLeft = checkWallCollision(leftFrame) != nil
		let collidesRight = checkWallCollision(rightFrame) != nil

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

		let nextFrame = (path.firstObject as? NSValue)?.cgRectValue ?? CGRect.zero
		let bestDirection = getBestDirection(possibleDirections, targetFrame: nextFrame)
		didSwipe(bestDirection.0)
	}

	// MARK: - Private

	private func currentPosition() -> CGRect {
		let initialTile_x = round(Double(Float(frame.origin.x) / Float(TILE_SIZE))) * TILE_SIZE
		let initialTile_y = round(Double(Float(frame.origin.y) / Float(TILE_SIZE))) * TILE_SIZE

		return CGRect(
			x: initialTile_x,
			y: initialTile_y,
			width: TILE_SIZE,
			height: TILE_SIZE
		)
	}
}
