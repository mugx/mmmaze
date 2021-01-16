//
//  Player.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2016-2021 mugx. All rights reserved.
//

import UIKit

class Player: Tile {
	enum State {
		case normal
		case angry

		var color: UIColor {
			self == .normal ? .white : .red
		}
	}

	open override var power: UInt {
		didSet {
			state = power > 0 ? .angry : .normal
		}
	}

	var state: State = .normal {
		didSet {
			refresh()
		}
	}

	private static let SPEED = 3.0

	init(gameSession: GameSession) {
		super.init(type: .player, rect: .zero)

		self.gameSession = gameSession
		self.speed = Float(Self.SPEED)
		self.state = .normal

		respawnAtInitialFrame()
		refresh()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func didSwipe(_ direction: Direction) {
		lastDirection = direction

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

	// MARK: - Private

	private func refresh() {
		set(images: type.image?.sprites(color: state.color) ?? [])
	}
}
