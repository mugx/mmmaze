//
//  Enemy+AI.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Path {
	struct Step {
		let frame: CGRect
		var visited: Bool
	}

	var steps: [Step] = []
	var isEmpty: Bool { steps.isEmpty }
	var count: Int { steps.count }
	var target: CGRect

	init(origin: CGRect = .zero, target: CGRect = .zero) {
		steps = [Step(frame: origin, visited: false)]
		self.target = target
	}

	func addStep(_ frame: CGRect) {
		steps.append(Step(frame: frame, visited: false))
	}

	func collides(_ frame: CGRect) -> Bool {
		return steps.contains { (step) -> Bool in
			step.frame.intersects(frame)
		}
	}

	func cleanupVisited() {
		steps = steps.filter { !$0.visited }
	}

	func nextFrameToFollow(from frame: CGRect) -> CGRect {
		var nextFrame = steps.first?.frame ?? CGRect.zero
		if nextFrame.intersects(frame) {
			steps.removeFirst()
			nextFrame = steps.first?.frame ?? target
		}
		return nextFrame
	}

	func backtrack(from frame: CGRect) -> CGRect {
		if let index = steps.firstIndex(where: { $0.frame.intersects(frame) }) {
			steps[index].visited = true
			return steps[index - 1].frame
		}
		return frame
	}

	func hasSameTarget(of other: Path) -> Bool {
		return steps.last?.frame.intersects(other.steps.last?.frame ?? .zero) ?? false
	}
}

extension Enemy {
	func calculatePath() {
		guard timeAccumulator > 1.0 || path.isEmpty else { return }
		timeAccumulator = 0

		let newPath = search(gameSession!.player.frame)
		let currentPosition = self.currentPosition()
		let currentPathFirstFrame = path.steps.first?.frame ?? .zero
		let newPathFirstFrame = newPath.steps.first?.frame ?? .zero
		let currentSteps = path.isEmpty ? Int.max : path.count
		let newSteps = newPath.count

		let d1 = currentPosition.distance(from: currentPathFirstFrame)
		let d2 = currentPosition.distance(from: newPathFirstFrame)

		// TODO: to migrate bunch of logic from here into the Path class
		let hasToUpdatePath = (currentSteps > newSteps || d1 > d2) && !path.hasSameTarget(of: newPath)
		if hasToUpdatePath {
			path = newPath

			if !path.collides(gameSession!.player.frame) {
				print("BUG: the path doesn't contain the player frame")
			}
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

		let path = Path(origin: currentFrame, target: target)
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

			let collidesUp = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.up) || path.collides(upFrame)
			let collidesDown = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.down) || path.collides(downFrame)
			let collidesLeft = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.left) || path.collides(leftFrame)
			let collidesRight = isWall(at: currentFrame, direction: UISwipeGestureRecognizer.Direction.right) || path.collides(rightFrame)

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
				path.addStep(currentFrame)
			} else {
				currentFrame = path.backtrack(from: currentFrame)
			}
		}
		return path
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

	func euclideanDistance(rect1: CGRect, rect2: CGRect) -> CGFloat {
		let center1 = CGPoint(x: rect1.midX, y: rect1.midY)
		let center2 = CGPoint(x: rect2.midX, y: rect2.midY)
		let horizontalDistance = center2.x - center1.x
		let verticalDistance = center2.y - center1.y
		let distance = sqrt(pow(horizontalDistance, 2) + pow(verticalDistance, 2))
		return distance
	}

	func decideNextMove(_ delta: TimeInterval) {
		let speed = CGFloat(self.speed + self.speed * Float(delta))
		let upFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y - speed), width: frame.size.width, height: frame.size.height)
		let downFrame = CGRect(x: frame.origin.x, y: CGFloat(frame.origin.y + speed), width: frame.size.width, height: frame.size.height)
		let leftFrame = CGRect(x: CGFloat(frame.origin.x - speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let rightFrame = CGRect(x: CGFloat(frame.origin.x + speed), y: frame.origin.y, width: frame.size.width, height: frame.size.height)
		let collidesUp = gameSession?.checkWallCollision(upFrame) != nil
		let collidesDown = gameSession?.checkWallCollision(downFrame) != nil
		let collidesLeft = gameSession?.checkWallCollision(leftFrame) != nil
		let collidesRight = gameSession?.checkWallCollision(rightFrame) != nil

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

		let nextFrame = path.nextFrameToFollow(from: frame)
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
