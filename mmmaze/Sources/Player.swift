//
//  Player.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Player: AIEntity {
	var currentLives: UInt = 0
	private(set) var isBlinking: Bool = false
	private unowned let mazeInteractor: MazeInteractor
	private var lastDirection: Direction?
	private static let SPEED: Float = 3.0
	private static let MAX_LIVES: UInt = 3
	private var faceRight: Bool = true

	init(mazeInteractor: MazeInteractor) {
		self.currentLives = Self.MAX_LIVES
		self.mazeInteractor = mazeInteractor

		super.init(type: .player, speed: Self.SPEED)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func move(to direction: Direction) {
		lastDirection = direction
		faceDirection()

		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: velocity.y)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: velocity.y)
		case .up:
			velocity = CGPoint(x: velocity.x, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: velocity.x, y: CGFloat(speed))
		}
	}

	func adjustFace() {
		let rotation = mazeInteractor.rotation % 4
		let x = CGFloat(transform.a)

		if faceRight {
			if rotation == 1 {
				transform = transform.scaledBy(x: x < 0 ? -1 : 1, y: 1)
			} else if rotation == 2 {
				transform = transform.scaledBy(x: x < 0 ? 1 : -1, y: 1)
			} else if rotation == 3 {
				transform = transform.scaledBy(x: x < 0 ? 1 : -1, y: 1)
			} else {
				transform = transform.scaledBy(x: x < 0 ? -1 : 1, y: 1)
			}
		} else {
			if rotation == 1 {
				transform = transform.scaledBy(x: x < 0 ? 1 : -1, y: 1)
			} else if rotation == 2 {
				transform = transform.scaledBy(x: x < 0 ? -1 : 1, y: 1)
			} else if rotation == 3 {
				transform = transform.scaledBy(x: x < 0 ? -1 : 1, y: 1)
			} else {
				transform = transform.scaledBy(x: x < 0 ? 1 : -1, y: 1)
			}
		}
	}

	func faceDirection() {
		guard let direction = lastDirection else { return }

		let directions: [Direction] = [.right, .up, .left, .down]
		switch direction {
		case directions[mazeInteractor.rotation % 4]:
			faceRight = true
		case directions[(2 + mazeInteractor.rotation) % 4]:
			faceRight = false
		default:
			break
		}
	}

	func update(_ delta: TimeInterval) {
		var frame = self.frame

		adjustFace()

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

	func takeHit() {
		currentLives -= 1
		respawnPlayer()
	}

	// MARK: - Private

	private func respawnPlayer() {
		guard currentLives > 0 else { return }

		isBlinking = true
		UIView.animate(withDuration: 0.4) {
			self.respawnAtInitialFrame()
			self.mazeInteractor.follow(self)
		} completion: { _ in
			self.blink(2) {
				self.isBlinking = false
			}
		}
	}
}
