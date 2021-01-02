//
//  Player.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import UIKit

class Player: Tile {
	open override var isAngry: Bool { didSet { setupAnimations() } }
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


	private func setupAnimations() {
		animationDuration = 0.4
		animationImages = UIImage(named: isAngry ? "player_angry" : "player")?.sprites(with: TILE_SIZE)
		startAnimating()
	}
}
