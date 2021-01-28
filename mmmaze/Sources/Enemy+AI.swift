//
//  Enemy+AI.swift
//  mmmaze
//
//  Created by mugx on 31/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

extension Enemy {

	// MARK: - Public
	
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
			if !mazeInteractor.isWall(at: path.currentFrame, direction: Direction.up) && !path.collides(upFrame) {
				possibleDirections.append((Direction.up, upFrame))
			}

			if !mazeInteractor.isWall(at: path.currentFrame, direction: Direction.down) && !path.collides(downFrame) {
				possibleDirections.append((Direction.down, downFrame))
			}

			if !mazeInteractor.isWall(at: path.currentFrame, direction: Direction.left) && !path.collides(leftFrame) {
				possibleDirections.append((Direction.left, leftFrame))
			}

			if !mazeInteractor.isWall(at: path.currentFrame, direction: Direction.right) && !path.collides(rightFrame) {
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

	func decideNextMove(_ delta: TimeInterval) {
		let speed = CGFloat(self.speed)
		let upFrame = frame.translate(y: -speed)
		let downFrame = frame.translate(y: speed)
		let leftFrame = frame.translate(x: -speed)
		let rightFrame = frame.translate(x: speed)
		
		var possibleDirections = [(Direction, Frame)]()
		if !mazeInteractor.checkWallCollision(upFrame) {
			possibleDirections.append((Direction.up, upFrame))
		}

		if !mazeInteractor.checkWallCollision(downFrame) {
			possibleDirections.append((Direction.down, downFrame))
		}

		if !mazeInteractor.checkWallCollision(leftFrame) {
			possibleDirections.append((Direction.left, leftFrame))
		}

		if !mazeInteractor.checkWallCollision(rightFrame) {
			possibleDirections.append((Direction.right, rightFrame))
		}

		let nextFrame = path.nextFrameToFollow(from: frame)
		let bestDirection = getBestDirection(possibleDirections, targetFrame: nextFrame)
		move(to: bestDirection.0)
	}

	// MARK: - Private

	private func getBestDirection(_ directions: [(Direction, Frame)], targetFrame: Frame) -> (Direction, Frame) {
		var shortestDistance = Float.greatestFiniteMagnitude
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
}
