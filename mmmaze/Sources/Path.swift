//
//  Path.swift
//  mmmaze
//
//  Created by mugx on 07/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class Path {
	struct Step {
		let frame: Frame
		var visited: Bool
	}

	var steps: [Step] = []
	var isEmpty: Bool { steps.isEmpty }
	private(set) var currentFrame: Frame
	private var target: Frame

	init(origin: Frame = .zero, target: Frame = .zero) {
		steps = [Step(frame: origin, visited: false)]
		self.currentFrame = origin
		self.target = target
	}

	func addStep(_ frame: Frame) {
		steps.append(Step(frame: frame, visited: false))
		currentFrame = frame
	}

	func collides(_ frame: Frame) -> Bool {
		return steps.contains { (step) -> Bool in
			step.frame.collides(frame)
		}
	}

	func cleanupVisited() {
		steps = steps.filter { !$0.visited }
	}

	func nextFrameToFollow(from frame: Frame) -> Frame {
		var nextFrame = steps.first?.frame ?? Frame.zero
		if nextFrame.collides(frame) {
			steps.removeFirst()
			nextFrame = steps.first?.frame ?? target
		}
		return nextFrame
	}

	func backtrack() {
		if let index = steps.firstIndex(where: { $0.frame.collides(currentFrame) }) {
			if index > 0 {
				steps[index].visited = true
				currentFrame = steps[index - 1].frame
			} else {
				// snake-tail: couldn't find the target
				let newOrigin = steps[index]
				steps.removeAll()
				addStep(newOrigin.frame)
			}
		}
	}

	func hasSameTarget(of other: Path) -> Bool {
		return target.collides(other.target)
	}
}
