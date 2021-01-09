//
//  Enemy+AI.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension Enemy {
	func calculatePath() {
		guard timeAccumulator > 1.0 || path.isEmpty else { return }
		timeAccumulator = 0

		let target = gameSession!.player.frame
		let newPath = search(target)

		if path.steps.isEmpty || !path.hasSameTarget(of: newPath) || newPath.steps.count < path.steps.count {
			path = newPath
		}
	}

	func search(_ target: CGRect) -> Path {
		let originalFrame = CGRect(
			x: round(Double(Float(frame.origin.x) / Float(TILE_SIZE))) * TILE_SIZE,
			y: round(Double(Float(frame.origin.y) / Float(TILE_SIZE))) * TILE_SIZE,
			width: TILE_SIZE,
			height: TILE_SIZE
		)
		var currentFrame = originalFrame
		let currentSpeed = CGFloat(TILE_SIZE)

		let path = Path(origin: originalFrame, target: target)
		var targetFound = false

		while !targetFound {
			targetFound = path.collides(target)

			if targetFound,
				 let index = path.steps.map({$0.frame}).firstIndex(of: originalFrame),
				 !path.steps[index].frame.intersects(target) {
				path.steps.remove(at: index)
				path.cleanupVisited()
				break
			}

			let upFrame = currentFrame.translate(y: -currentSpeed)
			let downFrame = currentFrame.translate(y: currentSpeed)
			let leftFrame = currentFrame.translate(x: -currentSpeed)
			let rightFrame = currentFrame.translate(x: currentSpeed)

			var possibleDirections = [(UISwipeGestureRecognizer.Direction, CGRect)]()
			if !isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.up) && !path.collides(upFrame) {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.up, upFrame))
			}

			if !isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.down) && !path.collides(downFrame) {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.down, downFrame))
			}

			if !isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.left) && !path.collides(leftFrame) {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.left, leftFrame))
			}

			if !isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.right) && !path.collides(rightFrame) {
				possibleDirections.append((UISwipeGestureRecognizer.Direction.right, rightFrame))
			}

			if !possibleDirections.isEmpty {
				let direction = getBestDirection(possibleDirections, targetFrame: target)
				currentFrame = direction.1
				path.addStep(currentFrame)
			} else {
				currentFrame = path.backtrack(from: currentFrame)
			}
		}
		return path
	}

	func getBestDirection(_ directions: [(UISwipeGestureRecognizer.Direction, CGRect)], targetFrame: CGRect) -> (UISwipeGestureRecognizer.Direction, CGRect) {
		var shortestDistance = CGFloat(Float.greatestFiniteMagnitude)
		var bestDirection: (UISwipeGestureRecognizer.Direction, CGRect)!

		for direction in directions {
			let distance = direction.1.distance(to: targetFrame)
			if distance < shortestDistance {
				shortestDistance = distance
				bestDirection = direction
			}
		}

		return bestDirection
	}

	func decideNextMove(_ delta: TimeInterval) {
		let speed = CGFloat(self.speed)//CGFloat(self.speed + self.speed * Float(delta))
		let upFrame = frame.translate(y: -speed)
		let downFrame = frame.translate(y: speed)
		let leftFrame = frame.translate(x: -speed)
		let rightFrame = frame.translate(x: speed)
		
		var possibleDirections = [(UISwipeGestureRecognizer.Direction, CGRect)]()
		if !gameSession!.checkWallCollision(upFrame) {
			possibleDirections.append((UISwipeGestureRecognizer.Direction.up, upFrame))
		}

		if !gameSession!.checkWallCollision(downFrame) {
			possibleDirections.append((UISwipeGestureRecognizer.Direction.down, downFrame))
		}

		if !gameSession!.checkWallCollision(leftFrame) {
			possibleDirections.append((UISwipeGestureRecognizer.Direction.left, leftFrame))
		}

		if !gameSession!.checkWallCollision(rightFrame) {
			possibleDirections.append((UISwipeGestureRecognizer.Direction.right, rightFrame))
		}

		let nextFrame = path.nextFrameToFollow(from: frame)
		let bestDirection = getBestDirection(possibleDirections, targetFrame: nextFrame)
		didSwipe(bestDirection.0)
	}
}
