//
//  AIEntity.swift
//  mmmaze
//
//  Created by mugx on 24/01/21.
//  Copyright © 2021 mugx. All rights reserved.
//

import UIKit

class AIEntity: BaseEntity {
	var velocity: CGPoint = .zero
	private(set) var speed: Float

	init(type: BaseEntityType, frame: Frame = .zero, speed: Float) {
		self.speed = speed

		super.init(type: type, frame: frame)

		respawnAtInitialFrame()
	}

	// MARK: - Public
	
	func show(after time: TimeInterval = 1.0) {
		imageView?.isHidden = false
		imageView?.alpha = 0

		UIView.animate(withDuration: 0.5, delay: time) {
			self.imageView?.alpha = 1.0
		}
	}
	
	func blink(_ duration: CFTimeInterval, completion: @escaping ()->()) {
		imageView?.blink(duration, completion: completion)
	}
	
	// A moving tile can't match the TILE_SIZE or it collides with the borders, hence it doesn't move.
	// Instead we consider its frame as centered and resized of a speed factor so it has margin to move.
	func respawnAtInitialFrame() {
		switch type {
		case .player, .enemy:
			velocity = .zero
			frame = Frame(row: Constants.STARTING_CELL.row, col: Constants.STARTING_CELL.col)
			frame = frame.resize(with: Float(Frame.SIZE) - Float(speed))
			frame = frame.centered()
		default: break
		}
	}
}
