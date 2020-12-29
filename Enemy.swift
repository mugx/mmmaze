//
//  Enemy.swift
//  mmmaze
//
//  Created by mugx on 29/12/20.
//  Copyright © 2020 mugx. All rights reserved.
//

import Foundation

extension Enemy {
	@objc static let SPEED = 1.5

	@objc convenience init(frame: CGRect, gameSession: GameSession) {
		self.init(frame: frame)
		self.gameSession = gameSession

		path = []
		layer.zPosition = 10
		velocity = CGPoint.zero
	}
}
