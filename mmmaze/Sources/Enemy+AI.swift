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

	func search(_ target: Frame) -> Path {
		let startingFrame = frame.boundingTile()
		let path = Path(origin: startingFrame, target: target)
		let currentSpeed = CGFloat(Frame.SIZE)
		var targetFound = false

		while !targetFound {
			targetFound = path.collides(target)

			if targetFound,
				 let index = path.steps.map({$0.frame}).firstIndex(of: startingFrame),
				 !path.steps[index].frame.collides(target) {
				path.steps.remove(at: index)
				path.cleanupVisited()
				break
			}

			let upFrame = path.currentFrame.translate(y: -currentSpeed)
			let downFrame = path.currentFrame.translate(y: currentSpeed)
			let leftFrame = path.currentFrame.translate(x: -currentSpeed)
			let rightFrame = path.currentFrame.translate(x: currentSpeed)

			var possibleDirections = [(Direction, Frame)]()
			if !isWall(at: path.currentFrame, direction: Direction.up) && !path.collides(upFrame) {
				possibleDirections.append((Direction.up, upFrame))
			}

			if !isWall(at: path.currentFrame, direction: Direction.down) && !path.collides(downFrame) {
				possibleDirections.append((Direction.down, downFrame))
			}

			if !isWall(at: path.currentFrame, direction: Direction.left) && !path.collides(leftFrame) {
				possibleDirections.append((Direction.left, leftFrame))
			}

			if !isWall(at: path.currentFrame, direction: Direction.right) && !path.collides(rightFrame) {
				possibleDirections.append((Direction.right, rightFrame))
			}

			if !possibleDirections.isEmpty {
				let direction = getBestDirection(possibleDirections, targetFrame: target)
				path.addStep(direction.1)
			} else {
				path.backtrack()
			}
		}
		return path
	}

	func getBestDirection(_ directions: [(Direction, Frame)], targetFrame: Frame) -> (Direction, Frame) {
		var shortestDistance = CGFloat(Float.greatestFiniteMagnitude)
		var bestDirection: (Direction, Frame)!

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
		let speed = CGFloat(self.speed)
		let upFrame = frame.translate(y: -speed)
		let downFrame = frame.translate(y: speed)
		let leftFrame = frame.translate(x: -speed)
		let rightFrame = frame.translate(x: speed)
		
		var possibleDirections = [(Direction, Frame)]()
		if !gameSession!.checkWallCollision(upFrame) {
			possibleDirections.append((Direction.up, upFrame))
		}

		if !gameSession!.checkWallCollision(downFrame) {
			possibleDirections.append((Direction.down, downFrame))
		}

		if !gameSession!.checkWallCollision(leftFrame) {
			possibleDirections.append((Direction.left, leftFrame))
		}

		if !gameSession!.checkWallCollision(rightFrame) {
			possibleDirections.append((Direction.right, rightFrame))
		}

		let nextFrame = path.nextFrameToFollow(from: frame)
		let bestDirection = getBestDirection(possibleDirections, targetFrame: nextFrame)
		didSwipe(bestDirection.0)
	}
}
