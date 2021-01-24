//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Enemy: AIEntity {
	var wantSpawn: Bool = false
	private(set) var path = Path()
	unowned let mazeInteractor: MazeInteractor
	private var timeAccumulator: TimeInterval = 0.0
	private var target: Frame?
	private var lastDirection: Direction?
	private static let SPEED: Float = 1.5

	convenience init(from spawnable: Enemy, mazeInteractor: MazeInteractor) {
		self.init(mazeInteractor: mazeInteractor)
		frame = spawnable.frame
		spawnable.wantSpawn = false
	}
	
	init(mazeInteractor: MazeInteractor) {
		self.mazeInteractor = mazeInteractor

		super.init(type: .enemy, speed: Self.SPEED)

		visible = false
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public
	
	func update(delta: TimeInterval, target: Frame) {
		guard visible else { return }
		
		timeAccumulator += delta
		self.target = target

		calculatePath()
		decideNextMove(delta)

		var frame = self.frame

		// check vertical collision
		var frameOnMove = frame.translate(y: velocity.y)
		if !mazeInteractor.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.x != 0 && lastDirection?.isVertical ?? false {
				velocity = CGPoint(x: 0, y: velocity.y)
			}
		}

		// check horizontal collision
		frameOnMove = frame.translate(x: velocity.x)
		if !mazeInteractor.checkWallCollision(frameOnMove) {
			frame = frameOnMove

			if velocity.y != 0 && lastDirection?.isHorizontal ?? false {
				velocity = CGPoint(x: velocity.x, y: 0)
			}
		}

		if self.frame != frame {
			self.frame = frame
		} else {
			velocity = .zero
		}
	}

	func move(to direction: Direction) {
		lastDirection = direction

		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: 0)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: 0)
		case .up:
			velocity = CGPoint(x: 0, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: 0, y: CGFloat(speed))
		}
	}

	// MARK: - Private

	private func calculatePath() {
		guard let target = target, timeAccumulator > 1.0 || path.isEmpty else { return }
		timeAccumulator = 0

		let newPath = search(target)

		if path.steps.isEmpty || !path.hasSameTarget(of: newPath) || newPath.steps.count < path.steps.count {
			path = newPath
		}
	}
}
