//
//  Player.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Player: Tile {
	open override var power: UInt { didSet { setupAnimations() } }
	private static let SPEED = 3.0
	
	init(gameSession: GameSession) {
		super.init(frame: .zero)

		self.gameSession = gameSession
		self.speed = Float(Self.SPEED)

		setupAnimations()
		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func didSwipe(_ direction: UISwipeGestureRecognizer.Direction) {
		lastSwipe = direction

		switch direction {
		case .right:
			velocity = CGPoint(x: CGFloat(speed), y: velocity.y)
		case .left:
			velocity = CGPoint(x: CGFloat(-speed), y: velocity.y)
		case .up:
			velocity = CGPoint(x: velocity.x, y: CGFloat(-speed))
		case .down:
			velocity = CGPoint(x: velocity.x, y: CGFloat(speed))
		default:
			break
		}
	}

	// MARK: - Private

	private func setupAnimations() {
		animationDuration = 0.4
		animationImages = (power > 0 ? TyleType.player_angry.image : TyleType.player.image)?.sprites(with: TILE_SIZE)
		startAnimating()
	}
}
