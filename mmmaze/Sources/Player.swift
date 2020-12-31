//
//  Player.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

@objc class Player: Tile {
	@objc static let SPEED = 3.0
	open override var isAngry: Bool { didSet { setupAnimations() } }

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


	private func setupAnimations() {
		animationDuration = 0.4
		animationImages = UIImage(named: isAngry ? "player_angry" : "player")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
		startAnimating()
	}
}
