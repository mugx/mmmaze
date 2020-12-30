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

	init(gameSession: GameSession) {
		super.init(frame: .zero)

		self.gameSession = gameSession
		speed = Float(Self.SPEED)
		layer.zPosition = 10
		animationImages = UIImage(named: "player")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
		animationDuration = 0.4
		animationRepeatCount = 0
		startAnimating()

		respawnAtInitialFrame()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	open override var isAngry: Bool {
		didSet {
			animationImages = UIImage(named: isAngry ? "player_angry" : "player")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
			startAnimating()
		}
	}
}
