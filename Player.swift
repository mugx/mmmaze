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

	@objc convenience init(frame: CGRect, gameSession: GameSession) {
		self.init(frame: frame)
		self.gameSession = gameSession
		self.speed = Float(Self.SPEED)
		self.layer.zPosition = 10
	}

	open override var isAngry: Bool {
		didSet {
			animationImages = UIImage(named: isAngry ? "player_angry" : "player")?.sprites(with: CGSize(width: TILE_SIZE, height: TILE_SIZE))
			startAnimating()
		}
	}
}
