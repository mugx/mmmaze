//
//  Enemy+AI.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension Enemy {
	@objc func calculatePath() {
		guard timeAccumulator > 1 || path.count == 0 else { return }
		timeAccumulator = 0

		let currentPosition = self.currentPosition()
		let newPath = search(gameSession.player.frame) ?? []
		let firstPathFrame = (path.firstObject as? NSValue)?.cgRectValue ?? CGRect.zero
		let firstNewPathFrame = (newPath.first as? NSValue)?.cgRectValue ?? CGRect.zero
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

	@objc func refinesPath() {
		let currentPosition = self.currentPosition()
		let enrolledPath: [CGRect] = path.compactMap { ($0 as? NSValue)?.cgRectValue }
		if collides(target: currentPosition, path: enrolledPath) {
			path.remove(currentPosition)
		}
	}

	@objc func decideNextMove(_ delta: TimeInterval) {
		let speed = CGFloat(self.speed + self.speed * Float(delta))
		let eastFrame = CGRect(x: CGFloat(frame.origin.x - speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let westFrame = CGRect(x: CGFloat(frame.origin.x + speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let northFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y - speed), width: frame.size.width, height: frame.size.height)
		let southFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y + speed), width: frame.size.width, height: frame.size.height)
		let collidesEast = checkWallCollision(eastFrame) != nil
		let collidesWest = checkWallCollision(westFrame) != nil
		let collidesNorth = checkWallCollision(northFrame) != nil
		let collidesSouth = checkWallCollision(southFrame) != nil

		var possibleDirections: [[String: Any]] = []
		if !collidesEast {
			possibleDirections.append(["move": "e", "frame": NSValue(cgRect: eastFrame)])
		}

		if !collidesWest {
			possibleDirections.append(["move": "w", "frame": NSValue(cgRect: westFrame)])
		}

		if !collidesNorth {
			possibleDirections.append(["move": "n","frame": NSValue(cgRect: northFrame)])
		}

		if !collidesSouth {
			possibleDirections.append(["move": "s","frame": NSValue(cgRect: southFrame)])
		}

		let nextFrame = (path.firstObject as? NSValue)?.cgRectValue ?? CGRect.zero
		switch getBestDirection(possibleDirections, targetFrame: nextFrame) {
		case "e":
			didSwipe(UISwipeGestureRecognizer.Direction.left)
		case "w":
			didSwipe(UISwipeGestureRecognizer.Direction.right)
		case "n":
			didSwipe(UISwipeGestureRecognizer.Direction.up)
		case "s":
			didSwipe(UISwipeGestureRecognizer.Direction.down)
		default:
			break
		}
	}

	// MARK: - Private

	@objc private func currentPosition() -> CGRect {
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