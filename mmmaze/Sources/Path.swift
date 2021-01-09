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
		return target.intersects(other.target)
	}
}
